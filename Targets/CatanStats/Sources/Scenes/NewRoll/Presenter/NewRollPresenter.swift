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
	func initialSetup()
}

final class NewRollPresenter: NewRollPresenterProtocol {

	// MARK: Private properties
	private var currentGame: Game?
	private var currentPlayer: Player?
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private let coreDataStack: CoreDataStack
	private let gameManager: GameManagerProtocol
	private weak var viewController: NewRollViewControllerProtocol?

	// MARK: Initializer
	init(coreDataStack: CoreDataStack, gameManager: GameManagerProtocol, viewController: NewRollViewControllerProtocol) {
		self.coreDataStack = coreDataStack
		self.gameManager = gameManager
		self.viewController = viewController
	}

	// MARK: Internal methods
	func initialSetup() {
		setupBindings()
	}

	func didSelectRollItem(_ item: DiceModel) {
		switch item.rollResult {
		case .number(let value):
			guard let numberRoll = NSEntityDescription.insertNewObject(
				forEntityName: "NumberRoll",
				into: coreDataStack.managedContext
			) as? NumberRoll else { return }
			numberRoll.value = Int16(value)
			numberRoll.dateCreated = Date.now
			currentGame?.addToRolls(numberRoll)
			currentPlayer?.addToRolls(numberRoll)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				guard let shipRoll = NSEntityDescription.insertNewObject(
					forEntityName: "ShipRoll",
					into: coreDataStack.managedContext
				) as? ShipRoll else { return }
				shipRoll.dateCreated = Date.now
				currentGame?.addToRolls(shipRoll)
				currentPlayer?.addToRolls(shipRoll)
			case .castle(color: let color):
				guard let castleRoll = NSEntityDescription.insertNewObject(
					forEntityName: "CastleRoll",
					into: coreDataStack.managedContext
				) as? CastleRoll else { return }
				castleRoll.dateCreated = Date.now
				castleRoll.color = color.rawValue
				currentGame?.addToRolls(castleRoll)
				currentPlayer?.addToRolls(castleRoll)
			}
		}
		gameManager.rollAdded()
		coreDataStack.saveContext()
	}

	func undoRoll() {
		let rollRequest = Roll.fetchRequest()
		let sortByDate = NSSortDescriptor(key: #keyPath(Roll.dateCreated), ascending: true)
		rollRequest.sortDescriptors = [sortByDate]
		guard let gameID = currentGame?.objectID else { return }

		rollRequest.predicate = NSPredicate(format: "game == %@", gameID)

		guard let lastRoll = try? coreDataStack.managedContext.fetch(rollRequest).last else {
			viewController?.renderUndoButton(undoPossible: false)
			return
		}
		coreDataStack.managedContext.delete(lastRoll)
		coreDataStack.saveContext()
		gameManager.rollUndone()
	}

	// MARK: Private methods
	private func checkUndoPossibility() {
		guard let rolls = currentGame?.rolls else {
			viewController?.renderUndoButton(undoPossible: false)
			return
		}
		viewController?.renderUndoButton(undoPossible: rolls.count != 0)
	}

	private func setupBindings() {
		gameManager.currentGamePublisher
			.sink { [weak self] game in
				guard let self = self else { return }
				currentGame = game
				checkUndoPossibility()
				viewController?.renderOverlay(newRollsDisabled: currentGame == nil)
			}
			.store(in: &cancellables)

		gameManager.currentPlayerPublisher
			.sink { [weak self] player in
				guard let self = self else { return }
				guard let playerName = player?.name else { return }
				currentPlayer = player
				checkUndoPossibility()
				viewController?.renderCurrentPlayer(playerName)
			}
			.store(in: &cancellables)
	}
}
