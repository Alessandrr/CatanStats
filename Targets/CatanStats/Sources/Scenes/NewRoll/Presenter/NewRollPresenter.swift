//
//  RollStatsPresenter.swift
//  CatanStats
//
//  Created by Александр Мамлыго on /74/2567 BE.
//  Copyright © 2567 BE tuist.io. All rights reserved.
//

import Foundation
import CoreData

protocol NewRollPresenterProtocol {
	func didSelectRollItem(_ item: RollModel)
	func loadData()
	func clearHistory()
	func addNewGame()
}

final class NewRollPresenter: NewRollPresenterProtocol {
	// MARK: Dependencies
	private var coreDataStack: CoreDataStack

	// MARK: Private properties
	private(set) var currentGame: Game?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
	}

	func didSelectRollItem(_ item: RollModel) {
		switch item {
		case .number(let rollResult):
			guard let roll = NSEntityDescription.insertNewObject(
				forEntityName: "DiceRoll",
				into: coreDataStack.managedContext
			) as? DiceRoll else { return }
			roll.value = Int16(rollResult)
			roll.dateCreated = Date.now
			currentGame?.addToRolls(roll)
		case .ship:
			guard let ship = NSEntityDescription.insertNewObject(
				forEntityName: "ShipRoll",
				into: coreDataStack.managedContext
			) as? ShipRoll else { return }
			ship.dateCreated = Date.now
			currentGame?.addToRolls(ship)
		case .castle(let color):
			guard let castle = NSEntityDescription.insertNewObject(
				forEntityName: "CastleRoll",
				into: coreDataStack.managedContext
			) as? CastleRoll else { return }
			castle.dateCreated = Date.now
			castle.color = color.rawValue
			currentGame?.addToRolls(castle)
		}
		coreDataStack.saveContext()
	}

	func loadData() {
		do {
			let gameRequest = NSFetchRequest<Game>(entityName: "Game")
			let sortByTitle = NSSortDescriptor(key: #keyPath(Game.dateCreated), ascending: true)
			gameRequest.sortDescriptors = [sortByTitle]
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			if results.isEmpty {
				currentGame = NSEntityDescription.insertNewObject(
					forEntityName: "Game",
					into: coreDataStack.managedContext
				) as? Game
				// Ломает тесты
				// currentGame = Game(context: coreDataStack.managedContext)
				currentGame?.dateCreated = Date.now
				currentGame?.title = CatanStatsStrings.GameHistory.sectionTitle(1)
				coreDataStack.saveContext()
			} else {
				currentGame = results.last
			}
		} catch let error {
			print("Fetch error \(error.localizedDescription)")
		}
	}

	func addNewGame() {
		do {
			let gameRequest = Game.fetchRequest()
			let gameCount = try coreDataStack.managedContext.count(for: gameRequest)
			currentGame = Game(context: coreDataStack.managedContext)
			currentGame?.title = CatanStatsStrings.GameHistory.sectionTitle(gameCount + 1)
			coreDataStack.saveContext()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	func clearHistory() {
		let gameRequest: NSFetchRequest<NSFetchRequestResult> = Game.fetchRequest()
		let batchDelete = NSBatchDeleteRequest(fetchRequest: gameRequest)
		do {
			try coreDataStack.managedContext.execute(batchDelete)
			coreDataStack.managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
			coreDataStack.managedContext.refreshAllObjects()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}
}
