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
	func makeSectionProvider(for section: NewRollSection) -> ISectionLayoutProvider {
		switch section {
		case .rolls:
			return RollsSectionLayoutProvider()
		case .ship:
			return ShipSectionLayoutProvider()
		case .castles:
			return CastlesSectionLayoutProvider()
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

struct ShipSectionLayoutProvider: ISectionLayoutProvider {
	func generateLayoutSection() -> NSCollectionLayoutSection {
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
	}
}

struct CastlesSectionLayoutProvider: ISectionLayoutProvider {
	func generateLayoutSection() -> NSCollectionLayoutSection {
		let group = makeThreeButtonGroup()
		return NSCollectionLayoutSection(group: group)
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
