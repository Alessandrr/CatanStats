//
//  GameModelProvider.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import Foundation

protocol GameModelProviderProtocol {
	func makeModelsForSection(_ section: RollSection) -> [DiceModel]
}

struct GameModelProvider: GameModelProviderProtocol {
	func makeModelsForSection(_ section: RollSection) -> [DiceModel] {
		switch section {
		case .numberRolls:
			(2...12).map { NumberDiceModel(rollResult: $0) }
		case .shipAndCastles:
			[
				ShipAndCastlesDiceModel(rollResult: .ship),
				ShipAndCastlesDiceModel(rollResult: .castle(color: .yellow)),
				ShipAndCastlesDiceModel(rollResult: .castle(color: .blue)),
				ShipAndCastlesDiceModel(rollResult: .castle(color: .green))
			]
		}
	}
}
