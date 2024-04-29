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
		let rollModel = model.rollModel

		switch rollModel {
		case .number(let rollResult):
			contentConfiguration.text = CatanStatsStrings.GameDetails.diceCell(rollResult)
		case .ship:
			contentConfiguration.text = CatanStatsStrings.GameDetails.shipCell
		case .castle(let color):
			switch color {
			case .yellow:
				contentConfiguration.text = CatanStatsStrings.GameDetails.yellowCastleCell
			case .green:
				contentConfiguration.text = CatanStatsStrings.GameDetails.greenCastleCell
			case .blue:
				contentConfiguration.text = CatanStatsStrings.GameDetails.blueCastleCell
			}
		}

		contentConfiguration.secondaryText = model.count.formatted()
		self.contentConfiguration = contentConfiguration
	}
}
