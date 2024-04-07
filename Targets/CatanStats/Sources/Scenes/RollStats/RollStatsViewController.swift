//
//  RollStatsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class RollStatsViewController: UIViewController {
	private enum Section {
		case rolls
	}

	// MARK: Dependencies
	var presenter: IRollStatsPresenter?

	// MARK: Private properties
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<Section, RollStatsModel>!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Roll stats"
		navigationController?.navigationBar.prefersLargeTitles = true
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
		<Section, RollStatsModel>(collectionView: collectionView) { (collectionView, indexPath, rollButtonModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: StatButtonCell.reuseIdentifier,
				for: indexPath
			) as? StatButtonCell else { return UICollectionViewCell() }

			cell.configure(with: rollButtonModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<Section, RollStatsModel>()
		snapshot.appendSections([Section.rolls])
		snapshot.appendItems(makeButtonModels())
		dataSource.apply(snapshot)
	}

	private func makeButtonModels() -> [RollStatsModel] {
		(2...12).map { RollStatsModel.number(rollResult: $0) }
	}
}

// MARK: Layout
extension RollStatsViewController {
	private func generateLayout() -> UICollectionViewLayout {
		let nestedGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(3/2)
			),
			subitems: generateGroups()
		)

		let section = NSCollectionLayoutSection(group: nestedGroup)
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}

	private func generateGroups() -> [NSCollectionLayoutItem] {
		let defaultInsets = NSDirectionalEdgeInsets(
			top: Sizes.Padding.normal,
			leading: Sizes.Padding.normal,
			bottom: Sizes.Padding.normal,
			trailing: Sizes.Padding.normal
		)

		let thirdSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1/3),
			heightDimension: .fractionalHeight(1.0)
		)
		let oneThirdButtonItem = NSCollectionLayoutItem(layoutSize: thirdSize)
		oneThirdButtonItem.contentInsets = defaultInsets

		let threeGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/5)
			),
			subitems: [oneThirdButtonItem, oneThirdButtonItem, oneThirdButtonItem]
		)

		let largeItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .fractionalWidth(0.5)
			)
		)
		largeItem.contentInsets = defaultInsets

		let pairItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.5)
			)
		)
		pairItem.contentInsets = defaultInsets

		let leadingGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .fractionalHeight(1.0)
			),
			subitem: pairItem,
			count: 2
		)

		let largeWithPairGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/2)
			),
			subitems: [leadingGroup, largeItem]
		)

		let halfSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.5),
			heightDimension: .fractionalHeight(1.0)
		)
		let halfButtonItem = NSCollectionLayoutItem(layoutSize: halfSize)
		halfButtonItem.contentInsets = defaultInsets

		let twoGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/5)
			),
			subitems: [halfButtonItem, halfButtonItem]
		)

		return [threeGroup, largeWithPairGroup, twoGroup, threeGroup]
	}
}

// MARK: UICollectionViewDelegate
extension RollStatsViewController: UICollectionViewDelegate {

}
