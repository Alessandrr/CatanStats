//
//  UIColor+Dynamic.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 05.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

extension UIColor {
	static func color(light: UIColor, dark: UIColor) -> UIColor {
		return .init { traitCollection in
			return traitCollection.userInterfaceStyle == .dark ? dark : light
		}
	}

	convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
		self.init(
			red: CGFloat(red) / 255.0,
			green: CGFloat(green) / 255.0,
			blue: CGFloat(blue) / 255.0,
			alpha: CGFloat(alpha) / 255.0
		)
	}
}
