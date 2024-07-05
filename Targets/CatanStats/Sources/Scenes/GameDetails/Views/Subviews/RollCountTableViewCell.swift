//
//  RollCountTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import UIKit

final class RollCountTableViewCell: UITableViewCell {

	static let reuseIdentifier = "rollCountTableViewCell"

	func configure(with displayItem: TableRollDisplayItem) {
		var contentConfiguration = UIListContentConfiguration.valueCell()

		contentConfiguration.text = displayItem.rollDescription

		contentConfiguration.secondaryText = displayItem.rollCount
		self.contentConfiguration = contentConfiguration
	}
}
