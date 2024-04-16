//
//  GameHistoryViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import CoreData

final class GameHistoryViewController: UITableViewController {

	// MARK: Dependencies
	var coreDataStack: CoreDataStack

	// MARK: Private properties
	private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
	private var snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?

	private lazy var fetchedResultsController: NSFetchedResultsController<Roll> = {
		let fetchRequest = Roll.fetchRequest()

		let sort = NSSortDescriptor(
			key: #keyPath(Roll.game),
			ascending: false
		)
		fetchRequest.sortDescriptors = [sort]

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: coreDataStack.managedContext,
			sectionNameKeyPath: #keyPath(Roll.game.title),
			cacheName: nil
		)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Game history"
		tableView.register(RollHistoryTableViewCell.self, forCellReuseIdentifier: RollHistoryTableViewCell.reuseIdentifier)
		dataSource = setupDataSource()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		do {
			try fetchedResultsController.performFetch()
			if let snapshot = snapshot {
				dataSource?.apply(snapshot)
			}
		} catch let error {
			print("Fetching error: \(error.localizedDescription)")
		}
	}
}

// MARK: Data source
extension GameHistoryViewController {
	private func setupDataSource() -> UITableViewDiffableDataSource<String, NSManagedObjectID> {
		UITableViewDiffableDataSource(
			tableView: tableView
		) { [unowned self] (tableView, indexPath, managedObjectID) -> UITableViewCell? in

			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: RollHistoryTableViewCell.reuseIdentifier,
				for: indexPath
			) as? RollHistoryTableViewCell else { return UITableViewCell() }

			guard let rollModel = try? coreDataStack.managedContext.existingObject(with: managedObjectID) else {
				return UITableViewCell()
			}

			cell.configure(with: rollModel)
			return cell
		}
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionInfo = fetchedResultsController.sections?[section]

		let headerView = HistorySectionHeaderView()
		headerView.configure(with: sectionInfo?.name)

		return headerView
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		Sizes.historyHeaderViewHeight
	}
}

// MARK: NSFetchedResultsControllerDelegate
extension GameHistoryViewController: NSFetchedResultsControllerDelegate {
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
	) {
		self.snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
	}
}
