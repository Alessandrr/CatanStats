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
	func configure(with model: RollStatsModel) {
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
		imageView.tintColor = .white

		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
}
