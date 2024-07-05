//
//  GameListPresenter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 07.05.24.
//

import Foundation
import CoreData
import Combine

protocol GameListPresenterProtocol {
	func initialFetch()
	func getGameForCellAt(_ indexPath: IndexPath) -> Game
	func gameSelectedAt(_ indexPath: IndexPath)
	func allTimeStatsSelected()
	func deleteGameAt(_ indexPath: IndexPath)
	func didSelectAddGame()
	func currentGameSelectedAt(_ indexPath: IndexPath)
}

final class GameListPresenter: GameListPresenterProtocol {

	// MARK: Private properties
	private lazy var fetchedResultsController: NSFetchedResultsController<Game> = {
		let fetchRequest = Game.fetchRequest()

		let sort = NSSortDescriptor(
			key: #keyPath(Game.dateCreated),
			ascending: false
		)
		fetchRequest.sortDescriptors = [sort]

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: coreDataStack.managedContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
		fetchedResultsController.delegate = viewController
		return fetchedResultsController
	}()
	private var cancellables = Set<AnyCancellable>()

	// MARK: Dependencies
	private let coreDataStack: CoreDataStack
	private let gameManager: GameManagerProtocol
	private weak var viewController: GameListViewControllerProtocol?
	private let router: GameListRouterProtocol

	// MARK: Initialization
	init (
		coreDataStack: CoreDataStack,
		gameListViewController: GameListViewControllerProtocol,
		gameManager: GameManagerProtocol,
		router: GameListRouterProtocol
	) {
		self.coreDataStack = coreDataStack
		self.viewController = gameListViewController
		self.gameManager = gameManager
		self.router = router
		setupBindings()
	}

	// MARK: Internal methods
	func initialFetch() {
		do {
			try fetchedResultsController.performFetch()
			viewController?.render()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	func getGameForCellAt(_ indexPath: IndexPath) -> Game {
		fetchedResultsController.object(at: indexPath)
	}

	func gameSelectedAt(_ indexPath: IndexPath) {
		let game = fetchedResultsController.object(at: indexPath)
		router.routeToGameDetails(for: game.objectID)
	}

	func allTimeStatsSelected() {
		router.routeToGameDetails(for: nil)
	}

	func deleteGameAt(_ indexPath: IndexPath) {
		let gameToDelete = fetchedResultsController.object(at: indexPath)
		gameManager.deleteGame(gameToDelete)
	}

	func didSelectAddGame() {
		router.routeToNewGame()
	}

	func currentGameSelectedAt(_ indexPath: IndexPath) {
		let gameToSetAsCurrent = fetchedResultsController.object(at: indexPath)
		gameManager.setCurrentGame(gameToSetAsCurrent)
	}

	// MARK: Private methods
	private func setupBindings() {
		gameManager.currentGamePublisher
			.scan((oldGame: Game?.none, newGame: Game?.none)) { ($0.1, $1) }
			.sink { [weak self] (oldGame, newGame) in
				if oldGame === newGame { return }
				let idsToReconfigure = [oldGame, newGame]
					.filter { $0?.managedObjectContext != nil && $0?.isDeleted != true }
					.compactMap { $0?.objectID }
				self?.viewController?.renderUpdate(for: idsToReconfigure)
			}
			.store(in: &cancellables)
	}
}
