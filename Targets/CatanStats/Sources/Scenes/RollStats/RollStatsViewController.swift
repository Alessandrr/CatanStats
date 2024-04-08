//
//  RollStatsViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class RollStatsViewController: UIViewController {
	// MARK: Constants for layout
	private enum Section: Int {
		case rolls
		case ship
		case castles
	}

	private enum Sizes {
		static let defaultInsets = NSDirectionalEdgeInsets(
			top: 5,
			leading: 5,
			bottom: 5,
			trailing: 5
		)
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
		<Section, RollStatsModel>(collectionView: collectionView) { (collectionView, indexPath, rollStatsModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: StatButtonCell.reuseIdentifier,
				for: indexPath
			) as? StatButtonCell else { return UICollectionViewCell() }

			cell.configure(with: rollStatsModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<Section, RollStatsModel>()
		snapshot.appendSections([Section.rolls, Section.ship, Section.castles])
		snapshot.appendItems(makeButtonModels(), toSection: Section.rolls)
		snapshot.appendItems([RollStatsModel.ship], toSection: Section.ship)
		snapshot.appendItems([
			RollStatsModel.castle(color: Colors.lightOrange),
			RollStatsModel.castle(color: Colors.green),
			RollStatsModel.castle(color: Colors.lightBlue)
		])
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
			let sectionLayoutKind = Section(rawValue: sectionIndex) ?? .ship
			switch sectionLayoutKind {
			case .rolls:
				let subgroups = [
					makeThreeButtonGroup(),
					makeSquareWithLeadingPairGroup(),
					makeTwoButtonGroup(),
					makeThreeButtonGroup()
				]

				let nestedGroup = NSCollectionLayoutGroup.vertical(
					layoutSize: NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .fractionalWidth(14/15)
					),
					subitems: subgroups
				)

				return NSCollectionLayoutSection(group: nestedGroup)
			case .ship:
				let item = NSCollectionLayoutItem(
					layoutSize: NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .fractionalHeight(1.0)
					)
				)
				item.contentInsets = Sizes.defaultInsets

				let group = NSCollectionLayoutGroup.horizontal(
					layoutSize: NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .fractionalWidth(1/7)
					),
					subitems: [item]
				)
				return NSCollectionLayoutSection(group: group)
			case .castles:
				let group = makeThreeButtonGroup()
				return NSCollectionLayoutSection(group: group)
			}
		}

		return layout
	}

	private func makeThreeButtonGroup() -> NSCollectionLayoutGroup {
		let thirdWidthButtonItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1/3),
				heightDimension: .fractionalHeight(1.0)
			)
		)
		thirdWidthButtonItem.contentInsets = Sizes.defaultInsets

		let threeGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/5)
			),
			subitems: [thirdWidthButtonItem, thirdWidthButtonItem, thirdWidthButtonItem]
		)

		return threeGroup
	}

	private func makeTwoButtonGroup() -> NSCollectionLayoutGroup {
		let halfWidthButtonItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1/2),
				heightDimension: .fractionalHeight(1.0)
			)
		)
		halfWidthButtonItem.contentInsets = Sizes.defaultInsets

		let twoGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/5)
			),
			subitems: [halfWidthButtonItem, halfWidthButtonItem]
		)

		return twoGroup
	}

	private func makeSquareWithLeadingPairGroup() -> NSCollectionLayoutGroup {
		let largeSquareItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1/2),
				heightDimension: .fractionalWidth(1/3)
			)
		)
		largeSquareItem.contentInsets = Sizes.defaultInsets

		let pairItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1/2)
			)
		)
		pairItem.contentInsets = Sizes.defaultInsets

		let leadingGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1/2),
				heightDimension: .fractionalHeight(1.0)
			),
			subitem: pairItem,
			count: 2
		)

		let largeWithPairGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/3)
			),
			subitems: [leadingGroup, largeSquareItem]
		)

		return largeWithPairGroup
	}
}

// MARK: UICollectionViewDelegate
extension RollStatsViewController: UICollectionViewDelegate {
}
