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
	func didSelectRollItem(_ item: NewRollModel)
	func loadData()
	func clearHistory()
}

final class NewRollPresenter: NewRollPresenterProtocol {
	// MARK: Dependencies
	private var coreDataStack: CoreDataStack

	// MARK: Private properties
	private(set) var currentGame: Game?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
	}

	func didSelectRollItem(_ item: NewRollModel) {
		switch item {
		case .number(let rollResult):
			let roll = DiceRoll(context: coreDataStack.managedContext)
			roll.value = Int16(rollResult)
			currentGame?.addToRolls(roll)
		case .ship:
			let roll = ShipRoll(context: coreDataStack.managedContext)
			currentGame?.addToRolls(roll)
		case .castle(let color):
			break
		}
		coreDataStack.saveContext()
	}

	func loadData() {
		do {
			let gameRequest = Game.fetchRequest()
			let sortByTitle = NSSortDescriptor(key: #keyPath(Game.dateCreated), ascending: true)
			gameRequest.sortDescriptors = [sortByTitle]
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			if results.isEmpty {
				currentGame = Game(context: coreDataStack.managedContext)
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

	func clearHistory() {
		let rollRequest: NSFetchRequest<NSFetchRequestResult> = Roll.fetchRequest()
		let batchDelete = NSBatchDeleteRequest(fetchRequest: rollRequest)
		do {
			try coreDataStack.managedContext.execute(batchDelete)
			coreDataStack.managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
			coreDataStack.managedContext.refreshAllObjects()
		} catch let error {
			print(error.localizedDescription)
		}
	}
}
