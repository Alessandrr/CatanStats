//
//  GameDetailsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit
import SwiftUI

protocol GameDetailsViewControllerProtocol: AnyObject {
	func render(_ viewData: GameDetailsViewData)
}

final class GameDetailsViewController: UIViewController {

	// MARK: Private properties
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		return tableView
	}()
	private lazy var chartHostingController: UIHostingController<RollChartsGroupView> = {
		return UIHostingController(
			rootView: RollChartsGroupView(counterModel: chartCountersModel)
		)
	}()

	private var dataSource: UITableViewDiffableDataSource<RollSection, RollModelCounter>?
	private var snapshot: NSDiffableDataSourceSnapshot<RollSection, RollModelCounter>?
	private var chartCountersModel = ChartCountersModel()

	// MARK: Dependencies
	var presenter: GameDetailsPresenterProtocol?

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		setupDataSource()
		presenter?.loadData()
		layout()
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
		addChild(chartHostingController)
		chartHostingController.didMove(toParent: self)
		chartHostingController.view.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(chartHostingController.view)
		view.addSubview(tableView)

		NSLayoutConstraint.activate([
			chartHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			chartHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			chartHostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
			chartHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.topAnchor.constraint(equalTo: chartHostingController.view.bottomAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
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

// MARK: UITableViewDelegate
extension GameDetailsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = GameDetailsSectionHeaderView()
		headerView.configure(with: dataSource?.sectionIdentifier(for: section)?.description ?? "")
		return headerView
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: GameDetailsViewControllerProtocol
extension GameDetailsViewController: GameDetailsViewControllerProtocol {
	func render(_ viewData: GameDetailsViewData) {
		var snapshot = NSDiffableDataSourceSnapshot<RollSection, RollModelCounter>()
		snapshot.appendSections(Array(viewData.tableViewCounters.keys).sorted())

		for section in snapshot.sectionIdentifiers {
			guard let counters = viewData.tableViewCounters[section] else { return }
			snapshot.appendItems(counters, toSection: section)
		}
		self.snapshot = snapshot

		chartCountersModel.counters = viewData.chartViewCounters

		navigationItem.title = viewData.navigationTitle
	}
}
