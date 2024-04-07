//
//  StatButtonCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class StatButtonCell: UICollectionViewCell {
	static let reuseIdentifier = "statButtonIdentifier"

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with model: RollStatsModel) {
		let buttonView = UIButton()
		buttonView.translatesAutoresizingMaskIntoConstraints = false
		var config = UIButton.Configuration.filled()

		switch model {
		case .number(let rollResult):
			config.image = UIImage(systemName: "\(rollResult).circle")
		}
		config.baseBackgroundColor = Colors.red
		buttonView.configuration = config

		contentView.addSubview(buttonView)
		NSLayoutConstraint.activate([
			buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
			buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
