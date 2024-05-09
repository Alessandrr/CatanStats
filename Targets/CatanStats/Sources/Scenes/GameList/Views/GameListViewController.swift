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
	private var router: GameListRouterProtocol
	var presenter: GameListPresenterProtocol?

	// MARK: Private properties
	private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
	private var dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?

	// MARK: Initialization

	init(router: GameListRouterProtocol) {
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
		presenter?.initialFetch()
		if let snapshot = dataSourceSnapshot {
			dataSource?.apply(snapshot)
		}
	}

	private func setupUI() {
		navigationItem.title = CatanStatsStrings.GameHistory.navigationBarTitle
	}
}

// MARK: Data source
extension GameListViewController {
	private func setupDataSource() {
		dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
			guard let game = self?.presenter?.getGameForCellAt(indexPath) else {
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
