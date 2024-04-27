//
//  GameListViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import CoreData

final class GameListViewController: UITableViewController {

	// MARK: Dependencies
	private var coreDataStack: CoreDataStack
	private var router: GameListRouterProtocol

	// MARK: Private properties
	private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
	private var dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?

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
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()

	// MARK: Initialization

	init(coreDataStack: CoreDataStack, router: GameListRouterProtocol) {
		self.coreDataStack = coreDataStack
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupDataSource()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		do {
			try fetchedResultsController.performFetch()
			if let snapshot = dataSourceSnapshot {
				dataSource?.apply(snapshot)
			}
		} catch let error {
			print("Fetching error: \(error.localizedDescription)")
		}
	}

	private func setupUI() {
		navigationItem.title = CatanStatsStrings.GameHistory.navigationBarTitle
	}
}

// MARK: Data source
extension GameListViewController {
	private func setupDataSource() {
		dataSource = UITableViewDiffableDataSource(
			tableView: tableView
		) { [unowned self] (_, _, managedObjectID) -> UITableViewCell? in

			guard let game = try? coreDataStack.managedContext.existingObject(with: managedObjectID) as? Game else {
				return UITableViewCell()
			}

			let cell = UITableViewCell()
			var content = cell.defaultContentConfiguration()
			content.text = game.title
			cell.contentConfiguration = content

			return cell
		}
	}
}

// MARK: tableView delegate
extension GameListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let gameId = dataSource?.itemIdentifier(for: indexPath) else { return }
		router.routeToGameDetails(for: gameId)
	}
}

// MARK: NSFetchedResultsControllerDelegate
extension GameListViewController: NSFetchedResultsControllerDelegate {
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
	) {
		dataSourceSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
	}
}
