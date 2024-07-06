//
//  GameDetailsPresenter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import CoreData
import UIKit
import Combine

protocol GameDetailsPresenterProtocol {
	func loadData()
}

final class GameDetailsPresenter: NSObject, GameDetailsPresenterProtocol {

	// MARK: Private properties
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private weak var viewController: GameDetailsViewControllerProtocol?
	private let coreDataStack: CoreDataStack
	private let gameID: NSManagedObjectID?
	private let gameModelProvider: GameModelProviderProtocol

	// MARK: Initialization
	init(
		viewController: GameDetailsViewControllerProtocol,
		coreDataStack: CoreDataStack,
		gameID: NSManagedObjectID?,
		gameModelProvider: GameModelProviderProtocol
	) {
		self.viewController = viewController
		self.coreDataStack = coreDataStack
		self.gameID = gameID
		self.gameModelProvider = gameModelProvider
	}

	// MARK: Internal methods
	func loadData() {
		setupRenderingBinding()
		viewController?.setTitle(getGameDetailsTitle())
		renderData()
	}

	// MARK: Private methods
	private func prepareViewData(from diceModels: [DiceModel]) -> GameDetailsViewData {
		return GameDetailsViewData(
			tableViewModels: prepareModelsForTableView(diceModels),
			chartViewModels: prepareChartViewData()
		)
	}

	private func prepareChartViewData() -> [RollSection: [ChartRollDisplayItem]] {
		var displayItemsBySection: [RollSection: [ChartRollDisplayItem]] = [:]

		let players = getPlayers()
		for player in players {
			let rolls = fetchRollsWithCount(playerID: player.objectID)
			let numberSectionRolls = filterDiceModels(rolls, for: .numberRolls)

			displayItemsBySection[.numberRolls, default: []] += numberSectionRolls.map { diceModel in
				ChartRollDisplayItem(
					playerName: player.name ?? "",
					description: diceModel.rollResult.description,
					count: diceModel.counter
				)
			}

			let shipCastleSectionRolls = filterDiceModels(rolls, for: .shipAndCastles)
			displayItemsBySection[.shipAndCastles, default: []] += shipCastleSectionRolls.map { diceModel in
				ChartRollDisplayItem(
					playerName: player.name ?? "",
					description: diceModel.rollResult.description,
					count: diceModel.counter
				)
			}
		}

		return displayItemsBySection
	}
	
	private func fetchRollsWithCount(playerID: NSManagedObjectID?) -> [DiceModel] {
		var rolls: [DiceModel] = []
		
		for section in RollSection.allCases {
			let sectionRolls = gameModelProvider.makeModelsForSection(section).map { diceModel in
				diceModel.counter = getRollCount(for: diceModel.rollResult, playerID: playerID)
				return diceModel
			}
			rolls.append(contentsOf: sectionRolls)
		}
		
		return rolls
	}
	
	private func prepareModelsForTableView(_ models: [DiceModel]) -> [RollSection: [TableRollDisplayItem]] {
		var modelsBySection: [RollSection: [TableRollDisplayItem]] = [:]

		for section in RollSection.allCases {
			let sectionRolls = filterDiceModels(models, for: section)
			if sectionRolls.contains(where: { $0.counter != 0 }) {
				modelsBySection[section] = sectionRolls
					.filter { $0.counter != 0 }
					.sorted { $0.counter > $1.counter }
					.map {
						TableRollDisplayItem(
							rollDescription: getRollDescriptionForTableView(for: $0),
							rollCount: $0.counter.formatted()
						)
					}
			}
		}

		return modelsBySection
	}
	
	private func getRollDescriptionForTableView(for diceModel: DiceModel) -> String {
		switch diceModel.rollResult {
		case .number(let value):
			return CatanStatsStrings.GameDetails.numberRollDescription(value.description)
		case .castleShip(let castleShipResult):
			return castleShipResult.description
		}
	}

	private func filterDiceModels(_ models: [DiceModel], for section: RollSection) -> [DiceModel] {
		switch section {
		case .numberRolls:
			return models.filter {
				if case .number = $0.rollResult {
					return true
				}
				return false
			}
		case .shipAndCastles:
			return models.filter {
				if case .castleShip = $0.rollResult {
					return true
				}
				return false
			}
		}
	}

	private func getGameDetailsTitle() -> String {
		guard let gameID else {
			return CatanStatsStrings.GameDetails.allTimeStatsTitle
		}
		let game = coreDataStack.managedContext.object(with: gameID) as? Game

		return game?.title ?? ""
	}

	private func getPlayers() -> [Player] {
		guard let gameID else { return [] }
		let game = coreDataStack.managedContext.object(with: gameID) as? Game

		guard let players = game?.players?.array as? [Player] else { return [] }
		return players
	}
}

// MARK: Rendering methods
private extension GameDetailsPresenter {
	private func setupRenderingBinding() {
		NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
			.sink { [weak self ] _ in
				guard let self = self else { return }
				renderData()
			}
			.store(in: &cancellables)
	}

	private func renderData() {
		let rolls = fetchRollsWithCount(playerID: nil)
		let viewData = prepareViewData(from: rolls)

		viewController?.render(viewData)
	}
}

// MARK: Count fetch methods
private extension GameDetailsPresenter {
	private func getRollCount(for rollResult: DiceModel.RollResult, playerID: NSManagedObjectID?) -> Int {
		switch rollResult {
		case .number(let value):
			return createFetchRequest(for: NumberRoll.self, rollResult: value, rollResultPropertyName: "value", playerID: playerID)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				return createFetchRequest(for: ShipRoll.self, rollResult: nil, rollResultPropertyName: nil, playerID: playerID)
			case .castle(color: let color):
				return createFetchRequest(for: CastleRoll.self, rollResult: color.rawValue, rollResultPropertyName: "color", playerID: playerID)
			}
		}
	}
	
	private func createFetchRequest<T: NSManagedObject>(
		for entity: T.Type,
		rollResult: Any? = nil,
		rollResultPropertyName: String? = nil,
		playerID: NSManagedObjectID?
	) -> Int {
		let fetchRequest = T.fetchRequest()
		var subpredicates: [NSPredicate] = []
		
		if let gameID {
			subpredicates.append(NSPredicate(format: "game == %@", gameID))
		}
		
		if let playerID {
			subpredicates.append(NSPredicate(format: "player == %@", playerID))
		}
		
		if let rollResult = rollResult, let propertyName = rollResultPropertyName {
			switch rollResult {
			case let stringValue as String:
				subpredicates.append(NSPredicate(format: "\(propertyName) == %@", stringValue))
			case let intValue as Int:
				subpredicates.append(NSPredicate(format: "\(propertyName) == %d", intValue))
			default:
				assertionFailure("Unexpected roll property type: \(type(of: rollResult))")
			}
		}
		
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
		return (try? coreDataStack.managedContext.count(for: fetchRequest)) ?? 0
	}
}
