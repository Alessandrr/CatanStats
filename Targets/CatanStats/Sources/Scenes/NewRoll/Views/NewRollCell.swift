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
	func configure(with model: RollModel) {
		switch model {
		case .number(let rollResult):
			imageView.image = UIImage(systemName: "\(rollResult).circle")
			layer.backgroundColor = Color.red.cgColor
		case .ship:
			imageView.image = UIImage(systemName: "sailboat")
			layer.backgroundColor = UIColor.systemGray.cgColor
		case .castle(let color):
			imageView.image = UIImage(systemName: "house.lodge")
			switch color {
			case .yellow:
				layer.backgroundColor = Color.lightOrange.cgColor
			case .green:
				layer.backgroundColor = Color.green.cgColor
			case .blue:
				layer.backgroundColor = Color.lightBlue.cgColor
			}
		}
	}

	func animateTap() {
		guard let originalBackgroundColor = layer.backgroundColor else { return }
		UIView.animate(
			withDuration: 0.15,
			delay: 0,
			options: [.allowUserInteraction],
			animations: { [unowned self] in
				contentView.alpha = 0.5
				layer.backgroundColor = UIColor(cgColor: originalBackgroundColor).withAlphaComponent(0.5).cgColor
			}
		)
		UIView.animate(
			withDuration: 0.15,
			delay: 0,
			options: [.allowUserInteraction],
			animations: { [unowned self] in
				contentView.alpha = 1
				layer.backgroundColor = originalBackgroundColor
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
