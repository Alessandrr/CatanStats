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

	func test_loadData_withoutGame_shouldCreateGame() {
		let sut = makePresenter()

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.loadData()
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGames = try? fetchGames()
		let expectedTitle = CatanStatsStrings.GameHistory.sectionTitle(1)

		XCTAssertEqual(savedGames?.count, 1, "Expected to fetch 1 saved game")
		XCTAssertEqual(savedGames?.first?.title, expectedTitle, "Expected title to be \(expectedTitle)")
		XCTAssertNotNil(sut.currentGame, "Current game wasn't set")
	}

	func test_loadData_withTwoGames_shouldGetLastGame() {
		let expectedTitle = "Game 2"
		let sut = makePresenterWithTwoGames(lastGameTitle: expectedTitle)

		sut.loadData()
		let savedGames = try? fetchGames()

		XCTAssertEqual(savedGames?.count, 2, "Expected to fetch 2 saved games")
		XCTAssertNotNil(sut.currentGame, "Current game wasn't set")
		XCTAssertEqual(sut.currentGame?.title, expectedTitle, "Expected title of current game to be \(expectedTitle)")
	}

	func test_didSelectRollItem_numberSelected_shouldSaveCorrectRoll() {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = RollModel.number(rollResult: expectedRollValue)

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(rollModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedRolls = try? fetchRolls()

		guard let roll = savedRolls?.first as? DiceRoll else {
			XCTFail("Expected to get DiceRoll")
			return
		}
		XCTAssertEqual(roll.value, Int16(expectedRollValue), "Expected value to be \(expectedRollValue)")
	}

	func test_didSelectRoll_numberSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let expectedRollValue = 2
		let rollModel = RollModel.number(rollResult: expectedRollValue)

		sut.loadData()
		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(rollModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGame = try? fetchGames().last

		XCTAssertNotNil(savedGame?.rolls?.lastObject as? DiceRoll, "Expected dice roll to be added")
	}

	func test_didSelectRollItem_shipSelected_shouldSaveShip() {
		let sut = makePresenter()
		let shipModel = RollModel.ship

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(shipModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedRolls = try? fetchRolls()

		XCTAssertNotNil(savedRolls?.first as? ShipRoll, "Expected to get ShipRoll")
	}

	func test_didSelectRollItem_shipSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let shipModel = RollModel.ship

		sut.loadData()
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
		let castleModel = RollModel.castle(color: expectedColor)

		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedRolls = try? fetchRolls()

		guard let roll = savedRolls?.first as? CastleRoll else {
			XCTFail("Expected to get CastleRoll")
			return
		}
		XCTAssertEqual(
			roll.color?.description,
			expectedColor.rawValue,
			"Expected color to be \(expectedColor.rawValue)"
		)
	}

	func test_didSelectRollItem_castleSelected_shouldAddToCurrentGame() {
		let sut = makePresenter()
		let castleModel = RollModel.castle(color: CastleColor.green)

		sut.loadData()
		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.managedContext)
		sut.didSelectRollItem(castleModel)
		waitForExpectations(timeout: 0.5) { error in
			XCTAssertNil(error, "Managed context wasn't saved")
		}
		let savedGame = try? fetchGames().last

		XCTAssertNotNil(savedGame?.rolls?.lastObject as? CastleRoll, "Expected castle roll to be added")
	}
}

private extension NewRollPresenterTests {
	func makePresenter() -> NewRollPresenter {
		NewRollPresenter(coreDataStack: coreDataStack)
	}

	func makePresenterWithTwoGames(lastGameTitle: String) -> NewRollPresenter {
		let presenter = NewRollPresenter(coreDataStack: coreDataStack)

		let firstGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
		firstGame?.dateCreated = Date.now

		let secondGame = NSEntityDescription.insertNewObject(
			forEntityName: "Game",
			into: coreDataStack.managedContext
		) as? Game
		secondGame?.dateCreated = Date.now
		secondGame?.title = lastGameTitle

		coreDataStack.saveContext()
		return presenter
	}

	func fetchGames() throws -> [Game] {
		let fetchRequest = Game.fetchRequest()
		let results = try coreDataStack.managedContext.fetch(fetchRequest)
		return results
	}

	func fetchRolls() throws -> [Roll] {
		let fetchRequest = Roll.fetchRequest()
		let results = try coreDataStack.managedContext.fetch(fetchRequest)
		return results
	}
}
