//
//  Sizes.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum Sizes {
	enum Padding {
		static let small: CGFloat = 5
		static let normal: CGFloat = 15
		static let large: CGFloat = 25
	}

	enum TextSizes {
		static let normal: CGFloat = 14
	}

	static let defaultInsets = NSDirectionalEdgeInsets(
		top: 5,
		leading: 5,
		bottom: 5,
		trailing: 5
	)

	static let rollCellCornerRadius: CGFloat = 10

	static let sectionHeaderViewHeight: CGFloat = 25
}
