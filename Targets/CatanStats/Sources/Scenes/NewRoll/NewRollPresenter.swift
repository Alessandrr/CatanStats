//
//  RollStatsPresenter.swift
//  CatanStats
//
//  Created by Александр Мамлыго on /74/2567 BE.
//  Copyright © 2567 BE tuist.io. All rights reserved.
//

import Foundation
import CoreData

protocol INewRollPresenter {
	func didSelectRollItem(_ item: NewRollModel)
	func loadData()
}

final class NewRollPresenter: INewRollPresenter {

	// MARK: Dependencies
	private var coreDataStack: CoreDataStack

	// MARK: Private properties
	private var currentGame: Game?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
	}

	func didSelectRollItem(_ item: NewRollModel) {
		switch item {
		case .number(let rollResult):
			let roll = DiceRoll(context: coreDataStack.managedContext)
			roll.value = Int16(rollResult)
			currentGame?.addToRolls(roll)
			coreDataStack.saveContext()
		case .ship:
			break
		case .castle(let color):
			break
		}
	}

	func loadData() {
		do {
			let gameRequest = Game.fetchRequest()
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			if results.isEmpty {
				currentGame = Game(context: coreDataStack.managedContext)
				currentGame?.title = "Game 1"
				coreDataStack.saveContext()
			} else {
				currentGame = results.first
			}
		} catch let error {
			print("Fetch error \(error.localizedDescription)")
		}
	}
}
