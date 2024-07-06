//
//  GameListTableViewCell.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.05.24.
//

import UIKit

final class GameListTableViewCell: UITableViewCell {
	static let reuseIdentifier = "GameListTableViewCell"

	func configure(with game: Game) {
		var content = defaultContentConfiguration()
		content.text = game.title
		content.secondaryText = game.isCurrent ? CatanStatsStrings.GameList.gameCellCurrentLabel: ""
		contentConfiguration = content
	}
}
