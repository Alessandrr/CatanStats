//
//  GameManagerStub.swift
//  CatanStatsTests
//
//  Created by Aleksandr Mamlygo on 03.06.24.
//

import Foundation
import Combine
import CoreData
@testable import CatanStats

final class GameManagerStub: GameManagerProtocol {
	var currentPlayerPublisher: AnyPublisher<CatanStats.Player?, Never> {
		return Just(stubPlayer).eraseToAnyPublisher()
	}

	var currentGamePublisher: AnyPublisher<CatanStats.Game?, Never> {
		return Just(stubGame).eraseToAnyPublisher()
	}

	private(set) var didCallRollAdded = false

	private var coreDataStack: CoreDataStack
	private var stubGame: Game?
	private var stubPlayer: Player?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		stubGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
		stubGame?.isCurrent = true

		stubPlayer = NSEntityDescription.insertNewObject(
			forEntityName: "Player",
			into: coreDataStack.managedContext
		) as? Player
		if let stubPlayer {
			stubGame?.insertIntoPlayers(stubPlayer, at: 0)
		}
	}

	func deleteGame(_ game: CatanStats.Game) {
	}

	func setCurrentGame(_ game: CatanStats.Game) {
	}

	func createGame(with gameInput: CatanStats.NewGameUserInput) -> Game? {
		return nil
	}

	func rollAdded() {
		didCallRollAdded = true
	}

	func rollUndone() {
	}
}
