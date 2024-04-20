//
//  NewRollViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class NewRollViewController: UIViewController {

	// MARK: Dependencies
	private var presenter: NewRollPresenterProtocol
	private var sectionLayoutProviderFactory: SectionLayoutProviderFactory

	// MARK: Initialization
	init(
		presenter: NewRollPresenterProtocol,
		sectionLayoutProviderFactory: SectionLayoutProviderFactory,
		sections: [NewRollSection] = [.rolls, .ship, .castles]
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
	private var dataSource: UICollectionViewDiffableDataSource<NewRollSection, NewRollModel>!
	private var sections: [NewRollSection]

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = CatanStatsStrings.NewRoll.navigationBarTitle
		configureCollectionView()
		configureDataSource()
		// Не вызывать при тестах
		presenter.loadData()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .trash,
			target: self,
			action: #selector(clearTapped)
		)
	}

	// MARK: Private methods
	@objc private func clearTapped() {
		presenter.clearHistory()
	}

	private func configureCollectionView() {
		let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		collectionView.isScrollEnabled = false
		collectionView.register(NewRollCell.self, forCellWithReuseIdentifier: NewRollCell.reuseIdentifier)
		self.collectionView = collectionView
	}

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource
		<NewRollSection, NewRollModel>(collectionView: collectionView) { (collectionView, indexPath, rollStatsModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: NewRollCell.reuseIdentifier,
				for: indexPath
			) as? NewRollCell else { return UICollectionViewCell() }

			cell.configure(with: rollStatsModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<NewRollSection, NewRollModel>()
		snapshot.appendSections(sections)
		snapshot.appendItems(makeButtonModels(), toSection: NewRollSection.rolls)
		snapshot.appendItems([NewRollModel.ship], toSection: NewRollSection.ship)
		snapshot.appendItems([
			NewRollModel.castle(color: Colors.lightOrange),
			NewRollModel.castle(color: Colors.green),
			NewRollModel.castle(color: Colors.lightBlue)
		], toSection: NewRollSection.castles)
		dataSource.apply(snapshot)
	}

	private func makeButtonModels() -> [NewRollModel] {
		(2...12).map { NewRollModel.number(rollResult: $0) }
	}
}

// MARK: Layout
extension NewRollViewController {
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
extension NewRollViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? NewRollCell {
			cell.animateTap()
		}
		presenter.didSelectRollItem(dataSource.itemIdentifier(for: indexPath) ?? NewRollModel.ship)
	}
}
