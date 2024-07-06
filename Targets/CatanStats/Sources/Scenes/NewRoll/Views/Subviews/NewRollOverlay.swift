//
//  NewRollOverlay.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.05.24.
//

import UIKit

final class NewRollOverlayView: UIView {
	private lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = UIFont.boldSystemFont(ofSize: Sizes.TextSizes.large)
		label.translatesAutoresizingMaskIntoConstraints = false

		label.layer.shadowColor = UIColor.black.cgColor
		label.layer.shadowOffset = CGSize(width: 2, height: 2)
		label.layer.shadowRadius = 3
		label.layer.shadowOpacity = 0.7

		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}

	private func configure() {
		backgroundColor = UIColor.black.withAlphaComponent(0.5)

		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.5
		layer.shadowOffset = CGSize(width: 0, height: -3)
		layer.shadowRadius = 5
		layer.masksToBounds = false

		warningLabel.text = CatanStatsStrings.NewRoll.overlayWarningText
		addSubview(warningLabel)
		NSLayoutConstraint.activate([
			warningLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			warningLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal)
		])
	}
}
