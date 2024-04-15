//
//  RollStatsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class RollStatsViewController: UIViewController {

	// MARK: Dependencies
	private var presenter: IRollStatsPresenter
	private var sectionLayoutProviderFactory: SectionLayoutProviderFactory

	// MARK: Initialization
	init(
		presenter: IRollStatsPresenter,
		sectionLayoutProviderFactory: SectionLayoutProviderFactory,
		sections: [RollStatsSection] = [.rolls, .ship, .castles]
	) {
		self.presenter = presenter
		self.sectionLayoutProviderFactory = sectionLayoutProviderFactory
		self.sections = sections
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private properties
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<RollStatsSection, RollStatsModel>!
	private var sections: [RollStatsSection]

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Roll stats"
		configureCollectionView()
		configureDataSource()
	}

	// MARK: Private methods
	private func configureCollectionView() {
		let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		collectionView.isScrollEnabled = false
		collectionView.register(StatButtonCell.self, forCellWithReuseIdentifier: StatButtonCell.reuseIdentifier)
		self.collectionView = collectionView
	}

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource
		<RollStatsSection, RollStatsModel>(collectionView: collectionView) { (collectionView, indexPath, rollStatsModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: StatButtonCell.reuseIdentifier,
				for: indexPath
			) as? StatButtonCell else { return UICollectionViewCell() }

			cell.configure(with: rollStatsModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<RollStatsSection, RollStatsModel>()
		snapshot.appendSections(sections)
		snapshot.appendItems(makeButtonModels(), toSection: RollStatsSection.rolls)
		snapshot.appendItems([RollStatsModel.ship], toSection: RollStatsSection.ship)
		snapshot.appendItems([
			RollStatsModel.castle(color: Colors.lightOrange),
			RollStatsModel.castle(color: Colors.green),
			RollStatsModel.castle(color: Colors.lightBlue)
		], toSection: RollStatsSection.castles)
		dataSource.apply(snapshot)
	}

	private func makeButtonModels() -> [RollStatsModel] {
		(2...12).map { RollStatsModel.number(rollResult: $0) }
	}
}

// MARK: Layout
extension RollStatsViewController {
	private func generateLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
			let section = sections[sectionIndex]
			let layoutProvider = sectionLayoutProviderFactory.makeSectionProvider(for: section)
			return layoutProvider.generateLayoutSection()
		}

		return layout
	}
}

// MARK: UICollectionViewDelegate
extension RollStatsViewController: UICollectionViewDelegate {
}
