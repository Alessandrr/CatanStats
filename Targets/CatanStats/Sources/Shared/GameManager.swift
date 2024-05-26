//
//  GameManager.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 26.05.24.
//

import Foundation
import CoreData

protocol GameManagerProtocol {
	func deleteGame(_ game: Game)
	func createGame()
	func getCurrentGame() -> Game?
}

final class GameManager: GameManagerProtocol {

	private var currentGame: Game?
	private var coreDataStack: CoreDataStack

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		setLatestGameAsCurrent()
	}

	func getCurrentGame() -> Game? {
		guard let currentGame = currentGame else {
			currentGame = createFirstGame()
			return currentGame
		}
		return currentGame
	}

	func deleteGame(_ game: Game) {
		coreDataStack.managedContext.delete(game)

		do {
			try coreDataStack.managedContext.save()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}

		if game === currentGame {
			setLatestGameAsCurrent()
		}
	}

	func createGame() {
		do {
			let gameRequest = Game.fetchRequest()
			let gameCount = try coreDataStack.managedContext.count(for: gameRequest)
			guard let newGame = NSEntityDescription.insertNewObject(
				forEntityName: "Game",
				into: coreDataStack.managedContext
			) as? Game else { return }
			newGame.dateCreated = Date.now
			newGame.title = CatanStatsStrings.GameList.sectionTitle(gameCount + 1)
			currentGame = newGame
			try coreDataStack.managedContext.obtainPermanentIDs(for: [newGame])
			coreDataStack.saveContext()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	private func setLatestGameAsCurrent() {
		let gameRequest = NSFetchRequest<Game>(entityName: "Game")
		let sortByDate = NSSortDescriptor(key: #keyPath(Game.dateCreated), ascending: true)
		gameRequest.sortDescriptors = [sortByDate]

		do {
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			currentGame = results.last
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	private func createFirstGame() -> Game? {
		let firstGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
		firstGame?.dateCreated = Date.now
		firstGame?.title = CatanStatsStrings.GameList.sectionTitle(1)
		coreDataStack.saveContext()
		return firstGame
	}
}
