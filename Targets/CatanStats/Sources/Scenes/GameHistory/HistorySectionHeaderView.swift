//
//  HistorySectionHeaderView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 15.04.24.
//

import UIKit

final class HistorySectionHeaderView: UIView {
	private var titleLabel = UILabel()

	init() {
		super.init(frame: .zero)
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupLayout() {
		backgroundColor = .systemBackground.withAlphaComponent(0.8)

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)

		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Sizes.Padding.small),
			titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Sizes.Padding.small),
			titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Sizes.Padding.large),
			titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Sizes.Padding.large)
		])
	}

	func configure(with title: String?) {
		titleLabel.text = title
	}
}
