//
//  NewRollViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class NewRollViewController: UIViewController {

	// MARK: Private properties
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<RollSection, RollModel>!
	private var sections: [RollSection]

	// MARK: Dependencies
	private var presenter: NewRollPresenterProtocol
	private var sectionLayoutProviderFactory: SectionLayoutProviderFactory
	private var modelProvider: GameModelProviderProtocol

	// MARK: Initialization
	init(
		presenter: NewRollPresenterProtocol,
		sectionLayoutProviderFactory: SectionLayoutProviderFactory,
		modelProvider: GameModelProviderProtocol,
		sections: [RollSection] = RollSection.allCases
	) {
		self.presenter = presenter
		self.sectionLayoutProviderFactory = sectionLayoutProviderFactory
		self.modelProvider = modelProvider
		self.sections = sections
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		configureDataSource()
		setupUI()
		presenter.loadData()
	}

	// MARK: Private methods
	@objc private func newGameTapped() {
		presenter.addNewGame()
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
		<RollSection, RollModel>(collectionView: collectionView) { (collectionView, indexPath, newRollModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: NewRollCell.reuseIdentifier,
				for: indexPath
			) as? NewRollCell else { return UICollectionViewCell() }

			cell.configure(with: newRollModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<RollSection, RollModel>()
		snapshot.appendSections(sections)
		for section in sections {
			snapshot.appendItems(modelProvider.makeModelsForSection(section), toSection: section)
		}
		dataSource.apply(snapshot)
	}
}

// MARK: Layout
extension NewRollViewController {
	private func setupUI() {
		navigationItem.title = CatanStatsStrings.NewRoll.navigationBarTitle
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.sizeToFit()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(newGameTapped)
		)
	}

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
		presenter.didSelectRollItem(dataSource.itemIdentifier(for: indexPath) ?? RollModel.ship)
	}
}
