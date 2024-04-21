//
//  Colors.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 05.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum Colors {
	case red
	case green
	case lightOrange
	case lightBlue

	var colorValue: UIColor {
		switch self {
		case .red:
			UIColor.color(
				light: UIColor(red: 224, green: 102, blue: 102),
				dark: UIColor(red: 157, green: 71, blue: 71)
			)
		case .green:
			UIColor.color(
				light: UIColor(red: 187, green: 201, blue: 173),
				dark: UIColor(red: 137, green: 151, blue: 123)
			)
		case .lightOrange:
			UIColor.color(
				light: UIColor(red: 249, green: 203, blue: 156),
				dark: UIColor(red: 199, green: 153, blue: 106)
			)
		case .lightBlue:
			UIColor.color(
				light: UIColor(red: 184, green: 211, blue: 232),
				dark: UIColor(red: 134, green: 161, blue: 182)
			)
		}
	}

	var description: String {
		switch self {
		case .red:
			"Red"
		case .green:
			"Green"
		case .lightOrange:
			"Orange"
		case .lightBlue:
			"Blue"
		}
	}
}
