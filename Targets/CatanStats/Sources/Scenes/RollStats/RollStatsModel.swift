//
//  RollStatsModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum RollStatsModel: Hashable {
	case number(rollResult: Int)
	case ship
	case castle(color: UIColor)
}
