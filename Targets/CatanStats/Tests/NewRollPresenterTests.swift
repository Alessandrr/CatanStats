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
}
