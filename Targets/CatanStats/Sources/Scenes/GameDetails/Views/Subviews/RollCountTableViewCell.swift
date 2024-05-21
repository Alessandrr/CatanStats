//
//  RollCountTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import UIKit

final class RollCountTableViewCell: UITableViewCell {

	static let reuseIdentifier = "rollCountTableViewCell"

	func configure(with model: RollModelCounter) {
		var contentConfiguration = UIListContentConfiguration.valueCell()
		let diceModel = model.diceModel

		switch diceModel {
		case let diceModel as NumberDiceModel:
			contentConfiguration.text = CatanStatsStrings.GameDetails.diceCell(diceModel.rollResult)
		case let diceModel as ShipAndCastlesDiceModel:
			switch diceModel.rollResult {
			case .ship:
				contentConfiguration.text = CatanStatsStrings.shipDescription
			case .castle(color: let color):
				contentConfiguration.text = CatanStatsStrings.castleDescription(color.description)
			}
		default:
			assertionFailure("New type of roll not processed")
		}

		contentConfiguration.secondaryText = model.count.formatted()
		self.contentConfiguration = contentConfiguration
	}
}
