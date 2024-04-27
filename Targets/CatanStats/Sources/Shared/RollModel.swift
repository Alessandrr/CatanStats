//
//  RollModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum RollModel: Hashable {
	case number(rollResult: Int)
	case ship
	case castle(color: CastleColor)
}

enum CastleColor: String {
	case yellow
	case green
	case blue
}
