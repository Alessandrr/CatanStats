//
//  RollModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

enum CastleColor: String, CustomStringConvertible {
	case yellow
	case green
	case blue

	var description: String {
		switch self {
		case .yellow:
			CatanStatsStrings.CastleColor.yellow
		case .green:
			CatanStatsStrings.CastleColor.green
		case .blue:
			CatanStatsStrings.CastleColor.blue
		}
	}
}

final class DiceModel: Hashable {
	// MARK: Roll result types
	enum RollResult: CustomStringConvertible {
		case number(Int)
		case castleShip(CastleShipResult)

		var description: String {
			switch self {
			case .number(let rollValue):
				return rollValue.description
			case .castleShip(let castleShipResult):
				return castleShipResult.description
			}
		}
	}

	enum CastleShipResult: CustomStringConvertible, Equatable {
		case ship
		case castle(color: CastleColor)

		var description: String {
			switch self {
			case .ship:
				return CatanStatsStrings.shipDescription
			case .castle(color: let color):
				return CatanStatsStrings.castleDescription(color)
			}
		}

		static func == (lhs: CastleShipResult, rhs: CastleShipResult) -> Bool {
			switch (lhs, rhs) {
			case (.ship, .ship):
				return true
			case (.castle(let lhsColor), .castle(let rhsColor)):
				return lhsColor == rhsColor
			default:
				return false
			}
		}
	}

	// MARK: Properties
	let rollResult: RollResult
	var counter: Int

	// MARK: Initialization
	init(rollResult: RollResult, counter: Int = 0) {
		self.rollResult = rollResult
		self.counter = counter
	}

	// MARK: Static functions
	static func probability(for result: RollResult) -> Double {
		switch result {
		case .number(let value):
			let probabilities: [Int: Double] = [
				2: 1/36.0,
				3: 2/36.0,
				4: 3/36.0,
				5: 4/36.0,
				6: 5/36.0,
				7: 6/36.0,
				8: 5/36.0,
				9: 4/36.0,
				10: 3/36.0,
				11: 2/36.0,
				12: 1/36.0
			]
			return probabilities[value] ?? 0
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				return 0.5
			case .castle:
				return 1/6
			}
		}
	}

	// MARK: Hashable
	static func == (lhs: DiceModel, rhs: DiceModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	func hash(into hasher: inout Hasher) {
		switch rollResult {
		case .number(let value):
			hasher.combine(value)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				hasher.combine("ShipDiceModel")
			case .castle(color: let color):
				hasher.combine(color)
			}
		}
	}
}
