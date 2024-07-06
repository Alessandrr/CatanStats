//
//  RollSection.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import Foundation

enum RollSection: CaseIterable, Comparable {
	case numberRolls
	case shipAndCastles

	var description: String {
		switch self {
		case .numberRolls:
			CatanStatsStrings.RollSection.rolls
		case .shipAndCastles:
			CatanStatsStrings.RollSection.shipAndCastles
		}
	}

	static func < (lhs: RollSection, rhs: RollSection) -> Bool {
		switch (lhs, rhs) {
		case (.numberRolls, .shipAndCastles):
			return true
		default:
			return false
		}
	}
}
