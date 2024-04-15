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
	private let cellReuseIdentifier = "RollCell"

	private lazy var fetchedResultsController: NSFetchedResultsController<DiceRoll> = {
		let fetchRequest = DiceRoll.fetchRequest()

		let sort = NSSortDescriptor(
			key: #keyPath(DiceRoll.game),
			ascending: false
		)
		fetchRequest.sortDescriptors = [sort]

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: coreDataStack.managedContext,
			sectionNameKeyPath: #keyPath(DiceRoll.game.title),
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
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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

			let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
			var content = cell.defaultContentConfiguration()

			if let roll = try? coreDataStack.managedContext.existingObject(with: managedObjectID) as? DiceRoll {
				content.text = roll.value.formatted()
			}
			cell.contentConfiguration = content
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
