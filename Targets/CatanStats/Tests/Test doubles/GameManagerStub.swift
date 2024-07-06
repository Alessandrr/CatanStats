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

	private var coreDataStack: CoreDataStack
	private var stubGame: Game?

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		stubGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
	}

	func deleteGame(_ game: CatanStats.Game) {
	}

	func createGame() -> Game? {
		return nil
	}

	func setCurrentGame(_ game: CatanStats.Game) {
	}
}
