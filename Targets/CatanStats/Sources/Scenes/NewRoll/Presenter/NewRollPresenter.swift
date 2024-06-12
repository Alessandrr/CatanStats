//
//  RollStatsPresenter.swift
//  CatanStats
//
//  Created by Александр Мамлыго on /74/2567 BE.
//

import Foundation
import CoreData
import Combine

protocol NewRollPresenterProtocol {
	func didSelectRollItem(_ item: DiceModel)
	func undoRoll()
}

final class NewRollPresenter: NewRollPresenterProtocol {

	// MARK: Private properties
	private var currentGame: Game?
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private var coreDataStack: CoreDataStack
	private var gameManager: GameManagerProtocol
	private weak var viewController: NewRollViewControllerProtocol?

	// MARK: Initializer
	init(coreDataStack: CoreDataStack, gameManager: GameManagerProtocol, viewController: NewRollViewControllerProtocol) {
		self.coreDataStack = coreDataStack
		self.gameManager = gameManager
		self.viewController = viewController
		setupBindings()
	}

	// MARK: Internal methods
	func didSelectRollItem(_ item: DiceModel) {
		switch item.rollResult {
		case .number(let value):
			guard let roll = NSEntityDescription.insertNewObject(
				forEntityName: "DiceRoll",
				into: coreDataStack.managedContext
			) as? DiceRoll else { return }
			roll.value = Int16(value)
			roll.dateCreated = Date.now
			currentGame?.addToRolls(roll)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				guard let ship = NSEntityDescription.insertNewObject(
					forEntityName: "ShipRoll",
					into: coreDataStack.managedContext
				) as? ShipRoll else { return }
				ship.dateCreated = Date.now
				currentGame?.addToRolls(ship)
			case .castle(color: let color):
				guard let castle = NSEntityDescription.insertNewObject(
					forEntityName: "CastleRoll",
					into: coreDataStack.managedContext
				) as? CastleRoll else { return }
				castle.dateCreated = Date.now
				castle.color = color.rawValue
				currentGame?.addToRolls(castle)
			}
		}
		coreDataStack.saveContext()
	}

	func undoRoll() {
		let rollRequest = Roll.fetchRequest()
		let sortByDate = NSSortDescriptor(key: #keyPath(Roll.dateCreated), ascending: true)
		rollRequest.sortDescriptors = [sortByDate]

		guard let lastRoll = try? coreDataStack.managedContext.fetch(rollRequest).last else { return }
		coreDataStack.managedContext.delete(lastRoll)
		coreDataStack.saveContext()
	}

	// MARK: Private methods
	private func setupBindings() {
		gameManager.currentGamePublisher
			.sink { [unowned self] game in
				currentGame = game
				viewController?.render(newRollsDisabled: currentGame == nil)
			}
			.store(in: &cancellables)
	}
}
