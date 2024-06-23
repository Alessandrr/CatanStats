//
//  RollCountTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import UIKit

final class RollCountTableViewCell: UITableViewCell {

	static let reuseIdentifier = "rollCountTableViewCell"

	func configure(with diceModel: DiceModel) {
		var contentConfiguration = UIListContentConfiguration.valueCell()

		switch diceModel.rollResult {
		case .number(let rollValue):
			contentConfiguration.text = CatanStatsStrings.GameDetails.diceCell(rollValue)
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				contentConfiguration.text = CatanStatsStrings.shipDescription
			case .castle(color: let color):
				contentConfiguration.text = CatanStatsStrings.castleDescription(color.description)
			}
		}

		contentConfiguration.secondaryText = diceModel.counter.formatted()
		self.contentConfiguration = contentConfiguration
	}
}
