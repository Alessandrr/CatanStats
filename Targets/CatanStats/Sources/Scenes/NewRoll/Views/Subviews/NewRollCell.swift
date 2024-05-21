//
//  NewRollCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class NewRollCell: UICollectionViewCell {
	static let reuseIdentifier = "newRollButtonIdentifier"

	private lazy var imageView = UIImageView()

	// MARK: Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Public methods
	func configure(with model: DiceModel) {
		switch model {
		case let model as NumberDiceModel:
			imageView.image = UIImage(systemName: "\(model.rollResult).circle")
			backgroundColor = Color.red
		case let model as ShipAndCastlesDiceModel:
			switch model.rollResult {
			case .ship:
				imageView.image = UIImage(systemName: "sailboat")
				backgroundColor = UIColor.systemGray
			case .castle(color: let color):
				imageView.image = UIImage(systemName: "house.lodge")
				switch color {
				case .yellow:
					backgroundColor = Color.lightOrange
				case .green:
					backgroundColor = Color.green
				case .blue:
					backgroundColor = Color.lightBlue
				}
			}
		default:
			assertionFailure("New roll type not processed")
		}
	}

	func animateTap() {
		guard let originalBackgroundColor = backgroundColor else { return }
		UIView.animate(
			withDuration: 0.15,
			delay: 0,
			options: [.allowUserInteraction],
			animations: { [unowned self] in
				contentView.alpha = 0.5
				backgroundColor = originalBackgroundColor.withAlphaComponent(0.5)
			}
		)
		UIView.animate(
			withDuration: 0.15,
			delay: 0,
			options: [.allowUserInteraction],
			animations: { [unowned self] in
				contentView.alpha = 1
				backgroundColor = originalBackgroundColor
			}
		)
	}

	// MARK: Private methods
	private func setupUI() {
		layer.cornerRadius = Sizes.rollCellCornerRadius

		imageView.tintColor = .white
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = false

		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
}
