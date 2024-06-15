//
//  GameListViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//

import UIKit
import CoreData

protocol GameListViewControllerProtocol: NSFetchedResultsControllerDelegate {
	func render()
	func renderUpdate(for items: [NSManagedObjectID])
}

final class GameListViewController: UITableViewController {

	// MARK: Private properties
	private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
	private var dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?

	// MARK: Dependencies
	var presenter: GameListPresenterProtocol?

	// MARK: View life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupDataSource()
		presenter?.initialFetch()
	}

	// MARK: Private methods
	private func setupUI() {
		navigationItem.title = CatanStatsStrings.GameList.navigationBarTitle

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(newGameTapped)
		)

		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "chart.xyaxis.line"),
			style: .plain,
			target: self,
			action: #selector(allTimeStatsTapped)
		)

		tableView.register(GameListTableViewCell.self, forCellReuseIdentifier: GameListTableViewCell.reuseIdentifier)
	}

	@objc private func newGameTapped() {
		presenter?.addNewGame()
	}

	@objc private func allTimeStatsTapped() {
		presenter?.allTimeStatsSelected()
	}
}

// MARK: GameListViewControllerProtocol
extension GameListViewController: GameListViewControllerProtocol {
	func render() {
		if let snapshot = dataSourceSnapshot {
			dataSource?.apply(snapshot, animatingDifferences: true)
			navigationItem.leftBarButtonItem?.isEnabled = snapshot.numberOfItems != 0
		}
	}

	func renderUpdate(for items: [NSManagedObjectID]) {
		dataSourceSnapshot?.reconfigureItems(items)
		render()
	}
}

// MARK: Data source
extension GameListViewController {
	private func setupDataSource() {
		dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] _, indexPath, _ in
			guard let game = self?.presenter?.getGameForCellAt(indexPath) else {
				return UITableViewCell()
			}

			guard let cell = self?.tableView.dequeueReusableCell(
				withIdentifier: GameListTableViewCell.reuseIdentifier
			) as? GameListTableViewCell else {
				return UITableViewCell()
			}
			cell.configure(with: game)

			return cell
		}
	}
}

// MARK: TableView Delegate
extension GameListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.gameSelectedAt(indexPath)
	}

	override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {

		let deleteAction = UIContextualAction(
			style: .destructive,
			title: CatanStatsStrings.GameList.deleteActionTitle
		) { [weak self] _, _, _ in
			self?.presenter?.deleteGameAt(indexPath)
		}
		deleteAction.backgroundColor = .red

		let setCurrentAction = UIContextualAction(
			style: .normal,
			title: CatanStatsStrings.GameList.setCurrentActionTitle
		) { [weak self] _, _, _ in
			self?.presenter?.currentGameSelectedAt(indexPath)
		}
		setCurrentAction.backgroundColor = Color.lightBlue

		let configuration = UISwipeActionsConfiguration(actions: [deleteAction, setCurrentAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}
}

// MARK: NSFetchedResultsControllerDelegate
extension GameListViewController {
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
	) {
		dataSourceSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
		render()
	}
}
