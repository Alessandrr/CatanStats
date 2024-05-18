//
//  RollSection.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import Foundation

enum RollSection: CaseIterable {
	case numberRolls
	case ship
	case castles

	var description: String {
		switch self {
		case .numberRolls:
			CatanStatsStrings.RollSection.rolls
		case .ship:
			CatanStatsStrings.RollSection.ship
		case .castles:
			CatanStatsStrings.RollSection.castles
		}
	}
}
