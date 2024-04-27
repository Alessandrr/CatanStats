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
			contentConfiguration.text = "Rolled \(rollResult)"
		case .ship:
			contentConfiguration.text = "Ship"
		case .castle(let color):
			contentConfiguration.text = "\(color.rawValue) Castle"
		}

		contentConfiguration.secondaryText = model.count.formatted()
		self.contentConfiguration = contentConfiguration
	}
}
