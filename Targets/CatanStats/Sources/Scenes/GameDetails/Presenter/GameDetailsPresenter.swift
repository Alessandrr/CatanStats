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
	private var players: [Player] = []

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
		players = getPlayers()
		renderData()
	}

	// MARK: Private methods
	private func prepareViewData(from gameData: GameData) -> GameDetailsViewData {
		return GameDetailsViewData(
			tableDisplayItems: prepareTableViewData(from: gameData),
			chartRollDisplayItems: prepareChartViewData(from: gameData),
			chartExpectedDisplayItems: prepareExpectedCountViewData(from: gameData)
		)
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
		let gameData: GameData
		if players.isEmpty {
			gameData = GameData.allTimeStats(fetchRollsWithCount(playerID: nil))
		} else {
			gameData = GameData.singleGameStats(
				players.map { player in
					PlayerData(
						name: player.name ?? "",
						rolls: fetchRollsWithCount(playerID: player.objectID)
					)
				}
			)
		}

		let viewData = prepareViewData(from: gameData)
		viewController?.render(viewData)
	}
}

// MARK: View data mapping
private extension GameDetailsPresenter {
	private func prepareTableViewData(from gameData: GameData) -> [RollSection: [TableRollDisplayItem]] {
		var modelsBySection: [RollSection: [TableRollDisplayItem]] = [:]

		let allRolls: [DiceModel]
		switch gameData {
		case .singleGameStats(let playerData):
			allRolls = playerData.flatMap { $0.rolls }
		case .allTimeStats(let allTimeRolls):
			allRolls = allTimeRolls
		}

		for (section, sectionRolls) in groupRollsBySection(allRolls) {
			let aggregatedRolls = aggregateRolls(sectionRolls)
			if aggregatedRolls.contains(where: { $0.counter != 0 }) {
				modelsBySection[section] = aggregatedRolls
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

	private func prepareChartViewData(from gameData: GameData) -> [RollSection: [ChartRollDisplayItem]] {
		switch gameData {
		case .singleGameStats(let playerData):
			return prepareSingleGameChartData(playerData)
		case .allTimeStats(let allTimeRolls):
			return prepareAllTimeChartData(allTimeRolls)
		}
	}

	private func prepareSingleGameChartData(_ playerDataList: [PlayerData]) -> [RollSection: [ChartRollDisplayItem]] {
		var displayItemsBySection: [RollSection: [ChartRollDisplayItem]] = [:]

		for playerData in playerDataList {
			for (section, diceModels) in groupRollsBySection(playerData.rolls) {
				displayItemsBySection[section, default: []] += diceModels.map { diceModel in
					ChartRollDisplayItem(
						playerName: playerData.name,
						description: diceModel.rollResult.description,
						count: diceModel.counter
					)
				}
			}
		}

		return displayItemsBySection
	}

	private func prepareAllTimeChartData(_ allTimeRolls: [DiceModel]) -> [RollSection: [ChartRollDisplayItem]] {
		var displayItemsBySection: [RollSection: [ChartRollDisplayItem]] = [:]
		let groupedRolls = groupRollsBySection(allTimeRolls)

		for (section, diceModels) in groupedRolls {
			displayItemsBySection[section, default: []] += diceModels.map { diceModel in
				ChartRollDisplayItem(
					playerName: nil,
					description: diceModel.rollResult.description,
					count: diceModel.counter
				)
			}
		}

		return displayItemsBySection
	}

	private func prepareExpectedCountViewData(from gameData: GameData) -> [RollSection: [ExpectedCountDisplayItem]] {
		var itemsBySection: [RollSection: [ExpectedCountDisplayItem]] = [:]

		let allRolls: [DiceModel]
		switch gameData {
		case .singleGameStats(let playerData):
			allRolls = playerData.flatMap { $0.rolls }
		case .allTimeStats(let allTimeRolls):
			allRolls = allTimeRolls
		}

		for (section, sectionRolls) in groupRollsBySection(allRolls) {
			let aggregatedRolls = aggregateRolls(sectionRolls)
			let totalRollCount = aggregatedRolls.reduce(0) { $0 + $1.counter }

			itemsBySection[section] = aggregatedRolls.map { diceModel in
				ExpectedCountDisplayItem(
					description: diceModel.rollResult.description,
					count: DiceModel.probability(for: diceModel.rollResult) * Double(totalRollCount)
				)
			}
		}

		return itemsBySection
	}

	private func aggregateRolls(_ rolls: [DiceModel]) -> [DiceModel] {
		var rollDict: [DiceModel: Int] = [:]

		for roll in rolls {
			if let existingCount = rollDict[roll] {
				rollDict[roll] = existingCount + roll.counter
			} else {
				rollDict[roll] = roll.counter
			}
		}

		return rollDict.map { key, value in
			let aggregatedRoll = key
			aggregatedRoll.counter = value
			return aggregatedRoll
		}
	}

	private func groupRollsBySection(_ rolls: [DiceModel]) -> [RollSection: [DiceModel]] {
		var rollsBySection: [RollSection: [DiceModel]] = [:]
		for roll in rolls {
			switch roll.rollResult {
			case .number:
				rollsBySection[.numberRolls, default: []].append(roll)
			case .castleShip:
				rollsBySection[.shipAndCastles, default: []].append(roll)
			}
		}
		return rollsBySection
	}
}

// MARK: Count fetch methods
private extension GameDetailsPresenter {
	private func getRollCount(for rollResult: DiceModel.RollResult, playerID: NSManagedObjectID?) -> Int {
		switch rollResult {
		case .number(let value):
			return fetchRolls(
				for: NumberRoll.self,
				rollResult: value,
				rollResultPropertyName: "value",
				playerID: playerID
			)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				return fetchRolls(
					for: ShipRoll.self,
					rollResult: nil,
					rollResultPropertyName: nil,
					playerID: playerID
				)
			case .castle(color: let color):
				return fetchRolls(
					for: CastleRoll.self,
					rollResult: color.rawValue,
					rollResultPropertyName: "color",
					playerID: playerID
				)
			}
		}
	}

	private func fetchRolls<T: NSManagedObject>(
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
