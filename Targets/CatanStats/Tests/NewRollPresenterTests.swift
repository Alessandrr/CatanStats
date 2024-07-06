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

	override func setUp() {
		coreDataStack = TestCoreDataStack(modelName: "CatanStats")
	}

	override func tearDown() {
		coreDataStack = nil
	}

	func test_didSelectRollItem_numberSelected_shouldSaveCorrectRoll() {
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

	func test_didSelectRoll_numberSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = DiceModel(rollResult: .number(expectedRollValue))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(rollModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGame = try? fetchGames().last

		XCTAssertNotNil(savedGame?.rolls?.lastObject as? NumberRoll, "Expected dice roll to be added")
	}

	func test_didSelectRollItem_shipSelected_shouldSaveShip() {
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

	func test_didSelectRollItem_shipSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let shipModel = DiceModel(rollResult: .castleShip(.ship))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(shipModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGame = try? fetchGames().last

		XCTAssertNotNil(savedGame?.rolls?.lastObject as? ShipRoll, "Expected ship roll to be added")
	}

	func test_didSelectRollItem_castleSelected_shouldSaveCorrectCastle() {
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

	func test_didSelectRollItem_castleSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let castleModel = DiceModel(rollResult: .castleShip(.castle(color: .green)))

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGame = try? fetchGames().last

		XCTAssertNotNil(savedGame?.rolls?.lastObject as? CastleRoll, "Expected castle roll to be added")
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
			gameManager: GameManagerStub(coreDataStack: coreDataStack),
			viewController: NewRollViewControllerStub()
		)
	}

	func fetchGames() throws -> [Game] {
		let fetchRequest = Game.fetchRequest()
		let results = try coreDataStack.managedContext.fetch(fetchRequest)
		return results
	}

	func fetchRolls() throws -> [Roll] {
		let fetchRequest = Roll.fetchRequest()
		let sortByDate = NSSortDescriptor(key: #keyPath(Roll.dateCreated), ascending: true)
		fetchRequest.sortDescriptors = [sortByDate]

		let results = try coreDataStack.managedContext.fetch(fetchRequest)
		return results
	}
}
