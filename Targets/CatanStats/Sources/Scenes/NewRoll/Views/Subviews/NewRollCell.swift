//
//  NewRollCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//

import UIKit

final class NewRollCell: UICollectionViewCell {
	static let reuseIdentifier = "newRollButtonIdentifier"

	// MARK: Private properties
	private lazy var imageView = UIImageView()
	private var targetNumberImageSize: CGSize {
		CGSize(width: contentView.bounds.height * 0.5, height: contentView.bounds.width * 0.5)
	}

	// MARK: Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Internal methods
	func configure(with model: DiceModel) {
		switch model.rollResult {
		case .number(let value):
			imageView.image = UIImage(systemName: "\(value).circle")?
				.scalePreservingAspectRatio(targetSize: targetNumberImageSize)
			backgroundColor = Colors.red
		case .castleShip(let castleShipResult):
			switch castleShipResult {
			case .ship:
				imageView.image = UIImage(systemName: "sailboat")
				backgroundColor = UIColor.systemGray
			case .castle(let color):
				imageView.image = UIImage(systemName: "house.lodge")
				switch color {
				case .yellow:
					backgroundColor = Colors.lightOrange
				case .green:
					backgroundColor = Colors.green
				case .blue:
					backgroundColor = Colors.lightBlue
				}
			}
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
