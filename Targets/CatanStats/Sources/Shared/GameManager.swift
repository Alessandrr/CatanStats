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
	func createGame(with gameInput: NewGameUserInput) -> Game?
	func setCurrentGame(_ game: Game)
	func rollAdded()
	func rollUndone()
	var currentGamePublisher: AnyPublisher<Game?, Never> { get }
	var currentPlayerPublisher: AnyPublisher<Player?, Never> { get }
}

final class GameManager: GameManagerProtocol {

	// MARK: Internal properties
	var currentGamePublisher: AnyPublisher<Game?, Never> {
		return currentGameSubject.eraseToAnyPublisher()
	}

	var currentPlayerPublisher: AnyPublisher<Player?, Never> {
		return currentPlayerSubject.eraseToAnyPublisher()
	}

	// MARK: Private properties
	private var currentGameSubject = CurrentValueSubject<Game?, Never>(nil)
	private var currentPlayerSubject = CurrentValueSubject<Player?, Never>(nil)
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private var coreDataStack: CoreDataStack

	// MARK: Initializers
	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		setupBindings()
		fetchCurrentGame()
		fetchCurrentPlayer()
	}

	// MARK: Internal Methods
	func setCurrentGame(_ game: Game) {
		currentGameSubject.value = game
	}

	func deleteGame(_ game: Game) {
		coreDataStack.managedContext.delete(game)

		if game === currentGameSubject.value {
			setLatestGameAsCurrent()
		}
		coreDataStack.saveContext()
	}

	func createGame(with gameInput: NewGameUserInput) -> Game? {
		do {
			guard let newGame = NSEntityDescription.insertNewObject(
				forEntityName: "Game",
				into: coreDataStack.managedContext
			) as? Game else { return nil }
			newGame.dateCreated = Date.now
			newGame.title = gameInput.gameTitle
			gameInput.playerNames.forEach { playerName in
				guard let player = createPlayer(name: playerName) else { return }
				newGame.addToPlayers(player)
			}
			newGame.currentPlayerIndex = 0
			currentPlayerSubject.value = newGame.players?[0] as? Player
			try coreDataStack.managedContext.obtainPermanentIDs(for: [newGame])
			coreDataStack.saveContext()
			return newGame
		} catch {
			assertionFailure(error.localizedDescription)
		}
		return nil
	}

	func rollAdded() {
		guard let currentGame = currentGameSubject.value else { return }
		guard let playerCount = currentGame.players?.count else { return }
		if (0..<playerCount).contains(Int(currentGame.currentPlayerIndex + 1)) {
			currentGame.currentPlayerIndex += 1
		} else {
			currentGame.currentPlayerIndex = 0
		}
		let playerIndex = Int(currentGame.currentPlayerIndex)
		currentPlayerSubject.value = currentGame.players?[playerIndex] as? Player
	}

	func rollUndone() {
		guard let currentGame = currentGameSubject.value else { return }
		guard let playerCount = currentGame.players?.count else { return }

		if currentGame.currentPlayerIndex > 0 {
			currentGame.currentPlayerIndex -= 1
		} else {
			currentGame.currentPlayerIndex = Int16(playerCount - 1)
		}
		let playerIndex = Int(currentGame.currentPlayerIndex)
		currentPlayerSubject.value = currentGame.players?[playerIndex] as? Player
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

	private func fetchCurrentPlayer() {
		guard let currentPlayerIndex = currentGameSubject.value?.currentPlayerIndex else { return }
		guard let players = currentGameSubject.value?.players else { return }
		guard Int(currentPlayerIndex) < players.count else { return }
		currentPlayerSubject.value = players[Int(currentPlayerIndex)] as? Player
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

	private func createPlayer(name: String) -> Player? {
		guard let player = NSEntityDescription.insertNewObject(
			forEntityName: "Player",
			into: coreDataStack.managedContext
		) as? Player else { return nil }
		player.name = name
		return player
	}

	private func setupBindings() {
		currentGameSubject
			.scan((oldGame: Game?.none, newGame: Game?.none)) { ($0.1, $1) }
			.sink { [weak self] (oldGame, newGame) in
				self?.fetchCurrentPlayer()
				if oldGame?.managedObjectContext != nil {
					oldGame?.isCurrent = false
				}
				newGame?.isCurrent = true
				self?.coreDataStack.saveContext()
			}
			.store(in: &cancellables)
	}
}
