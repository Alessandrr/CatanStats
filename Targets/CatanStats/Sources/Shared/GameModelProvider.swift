//
//  GameModelProvider.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import Foundation

protocol GameModelProviderProtocol {
	func makeModelsForSection(_ section: NewRollSection) -> [RollModel]
}

struct GameModelProvider: GameModelProviderProtocol {
	func makeModelsForSection(_ section: NewRollSection) -> [RollModel] {
		switch section {
		case .rolls:
			(2...12).map { RollModel.number(rollResult: $0) }
		case .ship:
			[RollModel.ship]
		case .castles:
			[
				RollModel.castle(color: CastleColor.yellow),
				RollModel.castle(color: CastleColor.blue),
				RollModel.castle(color: CastleColor.green)
			]
		}
	}
}
