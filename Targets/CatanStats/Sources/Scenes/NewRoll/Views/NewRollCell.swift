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
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		self.addGestureRecognizer(tapGesture)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Public methods
	func configure(with model: NewRollModel) {
		switch model {
		case .number(let rollResult):
			imageView.image = UIImage(systemName: "\(rollResult).circle")
			layer.backgroundColor = Colors.red.cgColor
		case .ship:
			imageView.image = UIImage(systemName: "sailboat")
			layer.backgroundColor = UIColor.systemGray.cgColor
		case .castle(let color):
			imageView.image = UIImage(systemName: "house.lodge")
			layer.backgroundColor = color.cgColor
		}
	}

	// MARK: Private methods
	private func setupUI() {
		layer.cornerRadius = Sizes.rollCellCornerRadius

		imageView.tintColor = .white
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

	@objc private func handleTap() {
		let originalBackgroundColor = layer.backgroundColor ?? Colors.lightBlue.cgColor
		UIView.animate(
			withDuration: 0.1,
			delay: 0,
			options: [.autoreverse, .allowUserInteraction],
			animations: { [unowned self] in
				contentView.alpha = 0.5
				layer.backgroundColor = UIColor(cgColor: originalBackgroundColor).withAlphaComponent(0.5).cgColor
			},
			completion: { [unowned self] _ in
				contentView.alpha = 1.0
				layer.backgroundColor = originalBackgroundColor
			}
		)
	}
}
