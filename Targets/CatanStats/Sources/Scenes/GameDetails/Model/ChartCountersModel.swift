//
//  ChartCountersModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import Foundation

final class ChartCountersModel: ObservableObject {
	@Published var counters: [RollModelCounter]

	init(counters: [RollModelCounter] = []) {
		self.counters = counters
	}

	func getCounters(for section: RollSection) -> [RollModelCounter] {
		switch section {
		case .numberRolls:
			return counters.filter {
				if case .number = $0.diceModel.rollResult {
					return true
				}
				return false
			}
		case .shipAndCastles:
			return counters.filter {
				if case .castleShip = $0.diceModel.rollResult {
					return true
				}
				return false
			}
		}
	}
}
