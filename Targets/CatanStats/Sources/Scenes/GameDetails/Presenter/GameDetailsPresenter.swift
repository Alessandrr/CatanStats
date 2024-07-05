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

		gameModelProvider.makeModelsForSection(.numberRolls).forEach { diceModel in
			guard case .number(let rollValue) = diceModel.rollResult else { return }

			diceModel.counter = getNumberRollsCount(value: rollValue, playerID: playerID)
			rolls.append(diceModel)
		}

		gameModelProvider.makeModelsForSection(.shipAndCastles).forEach { diceModel in
			guard case .castleShip(let castleShipRoll) = diceModel.rollResult else { return }

			diceModel.counter = getCastleShipRollsCount(rollResult: castleShipRoll, playerID: playerID)
			rolls.append(diceModel)
		}

		return rolls
	}

	private func prepareModelsForTableView(_ models: [DiceModel]) -> [RollSection: [TableRollDisplayItem]] {
		var modelsBySection: [RollSection: [TableRollDisplayItem]] = [:]

		let numberSectionRolls = filterDiceModels(models, for: .numberRolls)
		if numberSectionRolls.contains(where: { $0.counter != 0 }) {
			modelsBySection[.numberRolls] = numberSectionRolls
				.filter { $0.counter != 0 }
				.sorted { $0.counter > $1.counter }
				.map {
					TableRollDisplayItem(
						rollDescription: CatanStatsStrings.GameDetails.numberRollDescription($0.rollResult.description),
						rollCount: $0.counter.formatted()
					)
				}
		}

		let shipCastleSectionRolls = filterDiceModels(models, for: .shipAndCastles)
		if shipCastleSectionRolls.contains(where: { $0.counter != 0 }) {
			modelsBySection[.shipAndCastles] = shipCastleSectionRolls
				.filter { $0.counter != 0 }
				.sorted { $0.counter > $1.counter }
				.map {
					TableRollDisplayItem(
						rollDescription: $0.rollResult.description,
						rollCount: $0.counter.formatted()
					)
				}
		}

		return modelsBySection
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

	private func getNumberRollsCount(value: Int, playerID: NSManagedObjectID?) -> Int {
		let fetchRequest: NSFetchRequest<NumberRoll> = NumberRoll.fetchRequest()
		var subpredicates: [NSPredicate] = []

		if let gameID {
			subpredicates.append(NSPredicate(format: "game == %@", gameID))
		}

		if let playerID {
			subpredicates.append(NSPredicate(format: "player == %@", playerID))
		}

		subpredicates.append(NSPredicate(format: "value == %d", value))

		let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
		fetchRequest.predicate = compoundPredicate

		return (try? coreDataStack.managedContext.count(for: fetchRequest)) ?? 0
	}

	private func getCastleShipRollsCount(rollResult: DiceModel.CastleShipResult, playerID: NSManagedObjectID?) -> Int {
		switch rollResult {
		case .ship:
			let fetchRequest: NSFetchRequest<ShipRoll> = ShipRoll.fetchRequest()
			var subpredicates: [NSPredicate] = []

			if let gameID {
				fetchRequest.predicate = NSPredicate(format: "game == %@", gameID)
			}
			if let playerID {
				subpredicates.append(NSPredicate(format: "player == %@", playerID))
			}

			let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
			fetchRequest.predicate = compoundPredicate
			return (try? coreDataStack.managedContext.count(for: fetchRequest)) ?? 0
		case .castle(let color):
			let fetchRequest: NSFetchRequest<CastleRoll> = CastleRoll.fetchRequest()
			var subpredicates: [NSPredicate] = []

			if let gameID {
				subpredicates.append(NSPredicate(format: "game == %@", gameID))
			}
			if let playerID {
				subpredicates.append(NSPredicate(format: "player == %@", playerID))
			}

			subpredicates.append(NSPredicate(format: "color == %@", color.rawValue))
			let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
			fetchRequest.predicate = compoundPredicate

			return (try? coreDataStack.managedContext.count(for: fetchRequest)) ?? 0
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
