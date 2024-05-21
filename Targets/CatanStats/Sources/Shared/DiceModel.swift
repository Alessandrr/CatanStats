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

protocol Probabilistic: Hashable {
	associatedtype Result: CustomStringConvertible
	var rollResult: Result { get }
	func probability(for result: Result) -> Double
}

class DiceModel: Hashable {
	static func == (lhs: DiceModel, rhs: DiceModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
}

final class NumberDiceModel: DiceModel, Probabilistic {
	let rollResult: Int

	init(rollResult: Int) {
		self.rollResult = rollResult
	}

	static func == (lhs: NumberDiceModel, rhs: NumberDiceModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	override func hash(into hasher: inout Hasher) {
		hasher.combine(rollResult)
	}

	func probability(for result: Int) -> Double {
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

		if let probability = probabilities[result] {
			return probability
		} else {
			return 0
		}
	}
}

final class ShipAndCastlesDiceModel: DiceModel, Probabilistic {
	enum CastleShipRollOutcome: CustomStringConvertible {
		case ship
		case castle(color: CastleColor)

		var description: String {
			switch self {
			case .ship:
				CatanStatsStrings.shipDescription
			case .castle(color: let color):
				CatanStatsStrings.castleDescription(color.self)
			}
		}
	}

	let rollResult: CastleShipRollOutcome

	init(rollResult: CastleShipRollOutcome) {
		self.rollResult = rollResult
	}

	static func == (lhs: ShipAndCastlesDiceModel, rhs: ShipAndCastlesDiceModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	override func hash(into hasher: inout Hasher) {
		switch rollResult {
		case .ship:
			hasher.combine("ShipDiceModel")
		case .castle(color: let color):
			hasher.combine(color)
		}
	}

	func probability(for result: CastleShipRollOutcome) -> Double {
		switch result {
		case .ship:
			return 0.5
		case .castle:
			return 1/6
		}
	}
}
