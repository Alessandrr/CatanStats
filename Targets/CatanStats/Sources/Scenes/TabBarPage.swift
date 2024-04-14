//
//  TabBarPage.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum TabBarPage {
	case rolls
	case history

	func pageTitle() -> String {
		switch self {
		case .rolls:
			return "New roll"
		case .history:
			return "Game history"
		}
	}

	func pageIcon() -> UIImage? {
		switch self {
		case .rolls:
			return UIImage(systemName: "dice.fill")
		case .history:
			return UIImage(systemName: "list.bullet.below.rectangle")
		}
	}

	static let allPages: [TabBarPage] = [.rolls, .history]

	var pageOrderNumber: Int {
		guard let num = TabBarPage.allPages.firstIndex(of: self) else { return .zero }
		return num
	}
}
