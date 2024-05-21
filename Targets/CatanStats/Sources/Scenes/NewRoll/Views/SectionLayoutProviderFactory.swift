//
//  StatsSectionLayoutProvider.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

protocol ISectionLayoutProvider {
	func generateLayoutSection() -> NSCollectionLayoutSection
}

struct SectionLayoutProviderFactory {
	func makeSectionProvider(for section: RollSection) -> ISectionLayoutProvider {
		switch section {
		case .numberRolls:
			return RollsSectionLayoutProvider()
		case .shipAndCastles:
			return ShipAndCastlesSectionLayoutProvider()
		}
	}
}

struct RollsSectionLayoutProvider: ISectionLayoutProvider {
	func generateLayoutSection() -> NSCollectionLayoutSection {
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
	}
}

struct ShipAndCastlesSectionLayoutProvider: ISectionLayoutProvider {
	func generateLayoutSection() -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0)
			)
		)
		item.contentInsets = Sizes.defaultInsets

		let shipGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(1/7)
			),
			subitems: [item]
		)

		let combinedGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(12/35)
			),
			subitems: [shipGroup, makeThreeButtonGroup()]
		)

		return NSCollectionLayoutSection(group: combinedGroup)
	}
}

extension ISectionLayoutProvider {
	func makeThreeButtonGroup() -> NSCollectionLayoutGroup {
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

	func makeTwoButtonGroup() -> NSCollectionLayoutGroup {
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

	func makeSquareWithLeadingPairGroup() -> NSCollectionLayoutGroup {
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
			subitems: [pairItem, pairItem]
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
