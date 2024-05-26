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
	func didSelectRollItem(_ item: DiceModel)
}

final class NewRollPresenter: NewRollPresenterProtocol {
	// MARK: Dependencies
	private var coreDataStack: CoreDataStack
	private var gameManager: GameManagerProtocol

	init(coreDataStack: CoreDataStack, gameManager: GameManagerProtocol) {
		self.coreDataStack = coreDataStack
		self.gameManager = gameManager
	}

	func didSelectRollItem(_ item: DiceModel) {
		guard let currentGame = gameManager.getCurrentGame() else { return }

		switch item {
		case let item as NumberDiceModel:
			guard let roll = NSEntityDescription.insertNewObject(
				forEntityName: "DiceRoll",
				into: coreDataStack.managedContext
			) as? DiceRoll else { return }
			roll.value = Int16(item.rollResult)
			roll.dateCreated = Date.now
			currentGame.addToRolls(roll)
		case let item as ShipAndCastlesDiceModel:
			switch item.rollResult {
			case .ship:
				guard let ship = NSEntityDescription.insertNewObject(
					forEntityName: "ShipRoll",
					into: coreDataStack.managedContext
				) as? ShipRoll else { return }
				ship.dateCreated = Date.now
				currentGame.addToRolls(ship)
			case .castle(color: let color):
				guard let castle = NSEntityDescription.insertNewObject(
					forEntityName: "CastleRoll",
					into: coreDataStack.managedContext
				) as? CastleRoll else { return }
				castle.dateCreated = Date.now
				castle.color = color.rawValue
				currentGame.addToRolls(castle)
			}
		default:
			assertionFailure("New type of roll not processed")
		}
		coreDataStack.saveContext()
	}
}
