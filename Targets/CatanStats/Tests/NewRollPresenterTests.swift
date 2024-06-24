//
//  NewRollPresenterTests.swift
//  CatanStatsTests
//
//  Created by Aleksandr Mamlygo on 19.04.24.
//

import XCTest
import CoreData
@testable import CatanStats

final class NewRollPresenterTests: XCTestCase {

	private var coreDataStack: CoreDataStack!
	private var gameManager: GameManagerStub!

	override func setUp() {
		coreDataStack = TestCoreDataStack(modelName: "CatanStats")
		gameManager = GameManagerStub(coreDataStack: coreDataStack)
	}

	override func tearDown() {
		coreDataStack = nil
		gameManager = nil
	}

	func test_didSelectRoll_numberSelected_shouldSaveCorrectRoll() {
		let sut = makePresenter()
		let expectedRollValue = 2
		let diceModel = DiceModel(rollResult: .number(expectedRollValue))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(diceModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		let savedRolls = try? fetchRolls()

		guard let roll = savedRolls?.last as? NumberRoll else {
			XCTFail("Expected to get NumberRoll")
			return
		}
		XCTAssertNotNil(roll.dateCreated, "Expected date to be not nil")
		XCTAssertEqual(roll.value, Int16(expectedRollValue), "Expected value to be \(expectedRollValue)")
	}

	func test_didSelectRoll_numberSelected_shouldAddToCurrentGame() throws {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = DiceModel(rollResult: .number(expectedRollValue))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(rollModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")

		XCTAssertNotNil(currentGame.rolls?.lastObject as? NumberRoll, "Expected number roll to be added")
	}

	func test_didSelectRoll_numberSelected_shouldAddToCurrentPlayer() throws {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = DiceModel(rollResult: .number(expectedRollValue))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(rollModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")
		let currentPlayer = try XCTUnwrap(fetchCurrentPlayer(from: currentGame), "Failed to fetch current player")

		XCTAssertNotNil(currentPlayer.rolls?.lastObject as? NumberRoll, "Expected number roll to be added")
	}

	func test_didSelectRoll_numberSelected_shouldCallRollAdded() {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = DiceModel(rollResult: .number(expectedRollValue))

		sut.didSelectRollItem(rollModel)

		XCTAssertTrue(gameManager.didCallRollAdded, "Expected rollAdded() to be called")
	}

	func test_didSelectRoll_shipSelected_shouldSaveShip() {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(shipModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedRolls = try? fetchRolls()

		guard let roll = savedRolls?.last as? ShipRoll else {
			XCTFail("Expected to get ShipRoll")
			return
		}
		XCTAssertNotNil(roll.dateCreated, "Expected date created to be non-nil")
	}

	func test_didSelectRoll_shipSelected_shouldAddToCurrentGame() throws {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(shipModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")

		XCTAssertNotNil(currentGame.rolls?.lastObject as? ShipRoll, "Expected ship roll to be added")
	}

	func test_didSelectRoll_shipSelected_shouldAddToCurrentPlayer() throws {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(shipModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")
		let currentPlayer = try XCTUnwrap(fetchCurrentPlayer(from: currentGame), "Failed to fetch current player")

		XCTAssertNotNil(currentPlayer.rolls?.lastObject as? ShipRoll, "Expected ship roll to be added")
	}

	func test_didSelectRoll_shipSelected_shouldCallRollAdded() throws {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))

		sut.didSelectRollItem(shipModel)

		XCTAssertTrue(gameManager.didCallRollAdded, "Expected rollAdded() to be called")
	}

	func test_didSelectRoll_castleSelected_shouldSaveCorrectCastle() {
		let sut = makePresenter()
		let expectedColor = CastleColor.green
		let castleModel = DiceModel(rollResult: .castleShip(.castle(color: expectedColor)))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedRolls = try? fetchRolls()

		guard let roll = savedRolls?.last as? CastleRoll else {
			XCTFail("Expected to get CastleRoll")
			return
		}
		XCTAssertEqual(
			roll.color?.description,
			expectedColor.rawValue,
			"Expected color to be \(expectedColor.rawValue)"
		)
		XCTAssertNotNil(roll.dateCreated, "Expected date created to be non-nil")
	}

	func test_didSelectRoll_castleSelected_shouldAddToCurrentGame() throws {
		let sut = makePresenter()
		let castleModel = DiceModel(rollResult: .castleShip(.castle(color: .green)))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")

		XCTAssertNotNil(currentGame.rolls?.lastObject as? CastleRoll, "Expected castle roll to be added")
	}

	func test_didSelectRoll_castleSelected_shouldAddToCurrentPlayer() throws {
		let sut = makePresenter()
		let castleModel = DiceModel(rollResult: .castleShip(.castle(color: .green)))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let currentGame = try XCTUnwrap(fetchCurrentGame(), "Failed to fetch current game")
		let currentPlayer = try XCTUnwrap(fetchCurrentPlayer(from: currentGame), "Failed to fetch current player")

		XCTAssertNotNil(currentPlayer.rolls?.lastObject as? CastleRoll, "Expected castle roll to be added")
	}

	func test_didSelectRoll_castleSelected_shouldCallRollAdded() throws {
		let sut = makePresenter()
		let castleModel = DiceModel(rollResult: .castleShip(.castle(color: .green)))

		sut.didSelectRollItem(castleModel)

		XCTAssertTrue(gameManager.didCallRollAdded, "Expected rollAdded() to be called")
	}

	func test_undoRoll_withOneRoll_shouldRemoveRoll() {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))
		sut.didSelectRollItem(shipModel)
		var savedRolls = try? fetchRolls()
		XCTAssertEqual(savedRolls?.count, 1, "Expected to get 1 roll after adding a roll")

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.undoRoll()
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		savedRolls = try? fetchRolls()
		XCTAssertEqual(savedRolls?.count, 0, "Expected to get 0 rolls")
	}

	func test_undoRoll_withTwoRolls_shouldRemoveLatest() {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))
		sut.didSelectRollItem(shipModel)
		sut.didSelectRollItem(shipModel)

		let savedRolls = try? fetchRolls()
		XCTAssertEqual(savedRolls?.count, 2, "Expected to get 2 rolls after adding two rolls")
		let firstRollId = savedRolls?.first?.objectID
		let secondRollId = savedRolls?.last?.objectID

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.undoRoll()
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}

		do {
			let savedRolls = try fetchRolls()
			XCTAssertEqual(savedRolls.count, 1, "Expected to get 1 roll")
			XCTAssertFalse(savedRolls.contains { $0.objectID == secondRollId }, "Expected the latest roll to be removed")
			XCTAssertTrue(savedRolls.contains { $0.objectID == firstRollId }, "Expected first roll not to be removed")
		} catch let error {
			XCTFail("Core data error: \(error)")
		}
	}
}

private extension NewRollPresenterTests {
	func makePresenter() -> NewRollPresenter {
		NewRollPresenter(
			coreDataStack: coreDataStack,
			gameManager: gameManager,
			viewController: NewRollViewControllerStub()
		)
	}

	func fetchCurrentGame() -> Game? {
		let fetchRequest = Game.fetchRequest()
		let isCurrentPredicate = NSPredicate(format: "isCurrent == %@", NSNumber(value: true))
		fetchRequest.predicate = isCurrentPredicate
		let results = try? coreDataStack.managedContext.fetch(fetchRequest)
		return results?.first
	}

	func fetchCurrentPlayer(from game: Game) -> Player? {
		let currentPlayerIndex = Int(game.currentPlayerIndex)
		guard let players = game.players,
			(0..<players.count).contains(currentPlayerIndex) else {
			return nil
		}
		return players[currentPlayerIndex] as? Player
	}

	func fetchRolls() throws -> [Roll] {
		let fetchRequest = Roll.fetchRequest()
		let sortByDate = NSSortDescriptor(key: #keyPath(Roll.dateCreated), ascending: true)
		fetchRequest.sortDescriptors = [sortByDate]

		let results = try coreDataStack.managedContext.fetch(fetchRequest)
		return results
	}
}
