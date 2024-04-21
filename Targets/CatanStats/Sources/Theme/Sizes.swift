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
		static let large: CGFloat = 15
	}

	static let defaultInsets = NSDirectionalEdgeInsets(
		top: 5,
		leading: 5,
		bottom: 5,
		trailing: 5
	)

	static let rollCellCornerRadius: CGFloat = 10

	static let historyHeaderViewHeight: CGFloat = 25
}
