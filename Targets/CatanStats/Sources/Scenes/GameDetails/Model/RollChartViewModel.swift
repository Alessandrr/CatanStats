//
//  RollChartViewModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import Foundation

final class RollChartViewModel: ObservableObject {
	@Published var diceModels: [DiceModel]

	init(models: [DiceModel] = []) {
		self.diceModels = models
	}

	func getModels(for section: RollSection) -> [DiceModel] {
		switch section {
		case .numberRolls:
			return diceModels.filter {
				if case .number = $0.rollResult {
					return true
				}
				return false
			}
		case .shipAndCastles:
			return diceModels.filter {
				if case .castleShip = $0.rollResult {
					return true
				}
				return false
			}
		}
	}
}
