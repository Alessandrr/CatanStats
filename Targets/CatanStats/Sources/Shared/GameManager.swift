//
//  GameManager.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 26.05.24.
//

import Foundation
import CoreData
import Combine

protocol GameManagerProtocol {
	func deleteGame(_ game: Game)
	func createGame() -> Game?
	func setCurrentGame(_ game: Game)
	var currentGamePublisher: AnyPublisher<Game?, Never> { get }
}

final class GameManager: GameManagerProtocol {

	// MARK: Internal properties
	var currentGamePublisher: AnyPublisher<Game?, Never> {
		return currentGameSubject.eraseToAnyPublisher()
	}

	// MARK: Private properties
	private var currentGameSubject = CurrentValueSubject<Game?, Never>(nil)
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private var coreDataStack: CoreDataStack

	// MARK: Initializers
	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		setupBindings()
		fetchCurrentGame()
	}

	// MARK: Internal Methods
	func setCurrentGame(_ game: Game) {
		currentGameSubject.value = game
	}

	func deleteGame(_ game: Game) {
		coreDataStack.managedContext.delete(game)
		coreDataStack.saveContext()

		if game === currentGameSubject.value {
			setLatestGameAsCurrent()
		}
	}

	func createGame() -> Game? {
		do {
			let gameRequest = Game.fetchRequest()
			let gameCount = try coreDataStack.managedContext.count(for: gameRequest)
			guard let newGame = NSEntityDescription.insertNewObject(
				forEntityName: "Game",
				into: coreDataStack.managedContext
			) as? Game else { return nil }
			newGame.dateCreated = Date.now
			newGame.title = CatanStatsStrings.GameList.sectionTitle(gameCount + 1)
			try coreDataStack.managedContext.obtainPermanentIDs(for: [newGame])
			coreDataStack.saveContext()
			return newGame
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
		return nil
	}

	// MARK: Private Methods
	private func setLatestGameAsCurrent() {
		let gameRequest = Game.fetchRequest()
		let sortByDate = NSSortDescriptor(key: #keyPath(Game.dateCreated), ascending: true)
		gameRequest.sortDescriptors = [sortByDate]

		do {
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			currentGameSubject.value = results.last
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	private func fetchCurrentGame() {
		let gameRequest = Game.fetchRequest()
		gameRequest.predicate = NSPredicate(format: "isCurrent == %@", NSNumber(value: true))

		do {
			let results = try coreDataStack.managedContext.fetch(gameRequest)
			currentGameSubject.value = results.last
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	private func createFirstGame() -> Game? {
		guard let firstGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game else { return nil }
		firstGame.dateCreated = Date.now
		firstGame.title = CatanStatsStrings.GameList.sectionTitle(1)
		try? coreDataStack.managedContext.obtainPermanentIDs(for: [firstGame])
		coreDataStack.saveContext()
		return firstGame
	}

	private func setupBindings() {
		currentGameSubject
			.scan((oldGame: Game?.none, newGame: Game?.none)) { ($0.1, $1) }
			.sink { [weak self] (oldGame, newGame) in
				if oldGame?.managedObjectContext != nil {
					oldGame?.isCurrent = false
				}
				newGame?.isCurrent = true
				self?.coreDataStack.saveContext()
			}
			.store(in: &cancellables)
	}
}
