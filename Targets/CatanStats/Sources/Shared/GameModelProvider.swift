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
			(2...12).map { DiceModel(rollResult: .number($0)) }
		case .shipAndCastles:
			[
				DiceModel(rollResult: .castleShip(.ship)),
				DiceModel(rollResult: .castleShip(.castle(color: .yellow))),
				DiceModel(rollResult: .castleShip(.castle(color: .blue))),
				DiceModel(rollResult: .castleShip(.castle(color: .green)))
			]
		}
	}
}
