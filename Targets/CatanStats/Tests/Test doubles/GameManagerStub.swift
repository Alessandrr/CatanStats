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

	var currentGamePublisher: AnyPublisher<CatanStats.Game?, Never> {
		return Just(stubGame).eraseToAnyPublisher()
	}

	private(set) var didCallRollAdded = false

	private var coreDataStack: CoreDataStack
	private var stubGame: Game?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		stubGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
		stubGame?.isCurrent = true

		guard let stubPlayer = NSEntityDescription.insertNewObject(
			forEntityName: "Player",
			into: coreDataStack.managedContext
		) as? Player else { return }
		stubGame?.insertIntoPlayers(stubPlayer, at: 0)
	}

	func deleteGame(_ game: CatanStats.Game) {
	}


	func setCurrentGame(_ game: CatanStats.Game) {
	}

	func createGame(with gameDetails: CatanStats.GameDetails) -> CatanStats.Game? {
		return nil
	}

	func rollAdded() {
		didCallRollAdded = true
	}
}
