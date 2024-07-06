//
//  GameDetailsSectionHeaderView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.05.24.
//

import UIKit

class GameDetailsSectionHeaderView: UIView {

	func configure(with headerText: String) {
		backgroundColor = UIColor.systemGroupedBackground

		let headerLabel = UILabel()
		headerLabel.font = UIFont.systemFont(ofSize: Sizes.TextSizes.normal, weight: .semibold)
		headerLabel.textColor = UIColor.label
		headerLabel.text = headerText

		addSubview(headerLabel)
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Padding.small)
		])
	}
}
