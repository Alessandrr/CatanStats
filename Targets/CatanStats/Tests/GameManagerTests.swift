//
//  GameManagerTests.swift
//  CatanStatsTests
//
//  Created by Aleksandr Mamlygo on 06.06.24.
//

import Foundation
import XCTest
import Combine
import CoreData
@testable import CatanStats

final class GameManagerTests: XCTestCase {
	
	private var coreDataStack: CoreDataStack!
	private var subscriptions = Set<AnyCancellable>()

	override func setUp() {
		coreDataStack = TestCoreDataStack(modelName: "CatanStats")
	}

	override func tearDown() {
		coreDataStack = nil
		subscriptions = []
	}

	func test_createGame_shouldCreateGameWithCorrectProperties() {
		let sut = makeGameManager()

		let startDate = Date()
		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		let createdGame = sut.createGame()
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		
		let endDate = Date()

		XCTAssertNotNil(createdGame, "Game was not created")
		guard let dateCreated = createdGame?.dateCreated else {
			XCTFail("Date created was not set")
			return
		}
		XCTAssertTrue(startDate...endDate ~= dateCreated, "Game date is incorrect")
		XCTAssertNotNil(createdGame?.title, "Game title was not set")
	}

	func test_createGame_shouldIncreaseGameCountByOne() {
		let sut = makeGameManager()
		let expectedCount = getGameCount() + 1

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		_ = sut.createGame()
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		let endDate = Date()
		XCTAssertEqual(expectedCount, getGameCount(), "Expected one game to be added")
	}

	func test_setCurrentGame_shouldPublishCorrectGame() {
		let sut = makeGameManager()
		guard let newGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game else { return }
		var currentGame: Game?
		let gamePublishedExpectation = XCTestExpectation(description: "currentGamePublisher emitted a value other than the initial one")

		sut.currentGamePublisher
			.dropFirst()
			.sink { game in
				gamePublishedExpectation.fulfill()
				currentGame = game
			}
			.store(in: &subscriptions)
		sut.setCurrentGame(newGame)

		wait(for: [gamePublishedExpectation], timeout: 0.5)
		XCTAssertTrue(newGame === currentGame, "Wrong game was published")
	}

	func test_deleteGame_withTwoGames_shouldMakeCountOne() {
		let sut = makeGameManager()
		let firstGame = sut.createGame()
		let secondGame = sut.createGame()
		let gamePublishedExpectation = XCTestExpectation(description: "currentGamePublisher emitted a value other than the initial one")

		guard let lastGameCreated = secondGame else {
			XCTFail("Failed core data fetch")
			return
		}
		let contextDidSaveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.deleteGame(lastGameCreated)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		let gameCount = getGameCount()
		XCTAssertEqual(gameCount, 1, "Expected game count to be one")
	}

	func test_deleteGame_withOneGame_shouldPublishCurrentNil() {
		let sut = makeGameManager()
		guard let game = sut.createGame() else {
			XCTFail("Creating game failed")
			return
		}
		sut.setCurrentGame(game)

		var currentGame: Game?
		sut.currentGamePublisher
			.dropFirst()
			.sink { game in
				currentGame = game
			}
			.store(in: &subscriptions)

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.deleteGame(game)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		XCTAssertNil(currentGame, "Expected current game to be nil after deleting only game")
	}

	func test_deleteGame_nonCurrent_shouldNotPublish() {
		let sut = makeGameManager()
		guard let firstGame = sut.createGame() else {
			XCTFail("Creating game failed")
			return
		}
		guard let secondGame = sut.createGame() else {
			XCTFail("Creating game failed")
			return
		}
		sut.setCurrentGame(secondGame)

		let noEventExpectation = XCTestExpectation(description: "No update for current game should be emitted")
		noEventExpectation.isInverted = true
		sut.currentGamePublisher
			.dropFirst()
			.sink { game in
				noEventExpectation.fulfill()
			}
			.store(in: &subscriptions)

		let contetDidSaveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.deleteGame(firstGame)

		wait(for: [noEventExpectation, contetDidSaveExpectation], timeout: 0.5)
	}
}

private extension GameManagerTests {
	func makeGameManager() -> GameManager {
		GameManager(coreDataStack: coreDataStack)
	}

	func getGameCount() -> Int {
		return (try? coreDataStack.managedContext.count(for: Game.fetchRequest())) ?? 0
	}
}
