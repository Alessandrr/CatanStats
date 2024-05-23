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
	func deleteGameAt(_ indexPath: IndexPath)
}

final class GameListPresenter: GameListPresenterProtocol {

	// MARK: Dependenciesn
	private var coreDataStack: CoreDataStack
	private weak var viewController: GameListViewControllerProtocol?

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

	// MARK: Initialization
	init(coreDataStack: CoreDataStack, gameListViewController: GameListViewController) {
		self.coreDataStack = coreDataStack
		self.viewController = gameListViewController
	}

	// MARK: Internal methods
	func initialFetch() {
		do {
			try fetchedResultsController.performFetch()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	func getGameForCellAt(_ indexPath: IndexPath) -> Game {
		fetchedResultsController.object(at: indexPath)
	}

	func deleteGameAt(_ indexPath: IndexPath) {
		let gameToDelete = fetchedResultsController.object(at: indexPath)
		coreDataStack.managedContext.delete(gameToDelete)

		do {
			try coreDataStack.managedContext.save()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}

		viewController?.gameDeleted(gameToDelete.objectID)
	}
}
