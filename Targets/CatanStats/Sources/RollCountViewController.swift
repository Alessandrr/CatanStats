//
//  RollCountViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class RollCountViewController: UIViewController {
	private enum Section {
		case rolls
	}

	// MARK: Private properties
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<Section, RollButtonModel>!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Roll stats"
		navigationController?.navigationBar.prefersLargeTitles = true
		configureCollectionView()
		configureDataSource()
	}

	private func configureCollectionView() {
		let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		collectionView.register(StatButtonCell.self, forCellWithReuseIdentifier: StatButtonCell.reuseIdentifier)
		self.collectionView = collectionView
	}

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource
		<Section, RollButtonModel>(collectionView: collectionView) { (collectionView, indexPath, rollButtonModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: StatButtonCell.reuseIdentifier,
				for: indexPath
			) as? StatButtonCell else { return UICollectionViewCell() }

			cell.configure(with: rollButtonModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<Section, RollButtonModel>()
		snapshot.appendSections([Section.rolls])
		snapshot.appendItems(makeButtonModels())
		dataSource.apply(snapshot)
	}

	private func makeButtonModels() -> [RollButtonModel] {
		(2...12).map { RollButtonModel.number(rollResult: $0) }
	}
}

// MARK: Layout
extension RollCountViewController {
	private func generateLayout() -> UICollectionViewLayout {
		let nestedGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.75)
			),
			subitems: generateGroups()
		)

		let section = NSCollectionLayoutSection(group: nestedGroup)
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}

	private func generateGroups() -> [NSCollectionLayoutItem] {
		let defaultInsets = NSDirectionalEdgeInsets(
			top: 5,
			leading: 5,
			bottom: 5,
			trailing: 5
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
				heightDimension: .fractionalHeight(1/10)
			),
			subitems: [oneThirdButtonItem, oneThirdButtonItem, oneThirdButtonItem]
		)

		let largeItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .fractionalHeight(1.0)
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
				heightDimension: .fractionalHeight(0.35)
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
				heightDimension: .fractionalHeight(1/10)
			),
			subitems: [halfButtonItem, halfButtonItem]
		)

		return [threeGroup, largeWithPairGroup, threeGroup, twoGroup]
	}
}

extension RollCountViewController: UICollectionViewDelegate {

}
