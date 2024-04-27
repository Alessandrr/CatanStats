//
//  GameDetailsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit

protocol GameDetailsViewControllerProtocol: AnyObject {
	func updateRollCounts(_ models: [RollModelCounter])
}

final class GameDetailsViewController: UIViewController {
	// MARK: Table view sections
	enum RollCountSections: Hashable {
		case main
	}

	// MARK: Dependencies
	var presenter: GameDetailsPresenterProtocol?

	// MARK: Private properties
	private lazy var tableView = makeTableView()
	private var dataSource: UITableViewDiffableDataSource<RollCountSections, RollModelCounter>?
	private var snapshot: NSDiffableDataSourceSnapshot<RollCountSections, RollModelCounter>?

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		layout()
		setupDataSource()
		presenter?.loadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		if let snapshot = snapshot {
			dataSource?.apply(snapshot, animatingDifferences: true)
		}
	}
}

// MARK: UI Setup
private extension GameDetailsViewController {
	func layout() {
		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	func makeTableView() -> UITableView {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)

		return tableView
	}

	func setupDataSource() {
		tableView.register(RollCountTableViewCell.self, forCellReuseIdentifier: RollCountTableViewCell.reuseIdentifier)

		dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, rollModelCounter in
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: RollCountTableViewCell.reuseIdentifier,
				for: indexPath
			) as? RollCountTableViewCell else { return UITableViewCell() }

			cell.configure(with: rollModelCounter)
			return cell
		}
	}
}

extension GameDetailsViewController: GameDetailsViewControllerProtocol {
	func updateRollCounts(_ models: [RollModelCounter]) {
		var snapshot = NSDiffableDataSourceSnapshot<RollCountSections, RollModelCounter>()
		snapshot.appendSections([.main])
		snapshot.appendItems(models, toSection: .main)
		self.snapshot = snapshot
	}
}
