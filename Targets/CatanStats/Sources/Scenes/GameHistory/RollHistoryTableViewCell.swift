//
//  RollHistoryTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 16.04.24.
//

import UIKit
import CoreData

class RollHistoryTableViewCell: UITableViewCell {

	static let reuseIdentifier = "rollHistoryTableViewCell"

	func configure(with roll: NSManagedObject) {
		var content = defaultContentConfiguration()

		switch roll {
		case let roll as DiceRoll:
			content.text = roll.value.formatted()
		case roll as ShipRoll:
			content.text = "Ship"
		case let roll as CastleRoll:
			content.text = "\(roll.color ?? "") castle"
		default:
			content.text = "Unknown"
		}

		contentConfiguration = content
	}
}
