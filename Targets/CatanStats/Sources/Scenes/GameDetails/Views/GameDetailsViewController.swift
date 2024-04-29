//
//  GameDetailsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit
import SwiftUI

protocol GameDetailsViewControllerProtocol: AnyObject {
	func updateTableViewModel(_ models: [RollModelCounter])
	func updateChartModel(_ models: [RollModelCounter])
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

	private var chartHostingController: UIHostingController<RollDistributionChartView>?
	private var chartCountersModel = ChartCountersModel()

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		setupDataSource()
		presenter?.loadData()
		setupChartView()
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
		guard let chartHostingController = chartHostingController else { return }
		NSLayoutConstraint.activate([
			chartHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			chartHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			chartHostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
			chartHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.topAnchor.constraint(equalTo: chartHostingController.view.bottomAnchor, constant: 10),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	func makeTableView() -> UITableView {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)

		return tableView
	}

	func setupChartView() {
		let chartView = RollDistributionChartView(counterModel: chartCountersModel)
		chartHostingController = UIHostingController(rootView: chartView)
		guard let chartHostingController = chartHostingController else { return }

		chartHostingController.sizingOptions = .intrinsicContentSize
		addChild(chartHostingController)
		chartHostingController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(chartHostingController.view)
		chartHostingController.didMove(toParent: self)
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
	func updateTableViewModel(_ models: [RollModelCounter]) {
		var snapshot = NSDiffableDataSourceSnapshot<RollCountSections, RollModelCounter>()
		snapshot.appendSections([.main])
		snapshot.appendItems(models, toSection: .main)
		self.snapshot = snapshot
	}

	func updateChartModel(_ models: [RollModelCounter]) {
		chartCountersModel.counters = models
	}
}
