//
//  PlayerNameTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 18.06.24.
//

import UIKit

final class PlayerNameTableViewCell: UITableViewCell {
	static let reuseIdentifier = "PlayerNameCell"

	private lazy var textField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		return textField
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		textField.backgroundColor = .systemBackground
	}

	func configure(at indexPath: IndexPath, delegate: UITextFieldDelegate, currentInput: String) {
		selectionStyle = .none
		textField.placeholder = CatanStatsStrings.NewGame.playerNamePlaceholder(indexPath.row + 1)

		textField.text = currentInput
		textField.tag = indexPath.row
		textField.delegate = delegate
	}

	func configureError(at indexPath: IndexPath) {
		let placeholderText = CatanStatsStrings.NewGame.playerNamePlaceholder(indexPath.row + 1)
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.darkGray
		]
		let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)

		textField.attributedPlaceholder = attributedPlaceholder
		textField.backgroundColor = Color.lightRed
	}

	private func setupUI() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textField)
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			textField.topAnchor.constraint(equalTo: contentView.topAnchor),
			textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.Padding.normal)
		])
	}
}
