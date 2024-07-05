//
//  NewGamePresenter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.06.24.
//

import Foundation

import Foundation

enum ValidationError {
	case emptyPlayerName(index: Int)
}

struct ValidationErrors: Error {
	let validationErrors: [ValidationError]

	func hasError(forPlayerAtIndex index: Int) -> Bool {
		return validationErrors.contains { error in
			if case .emptyPlayerName(let errorIndex) = error {
				return errorIndex == index
			}
			return false
		}
	}
}

protocol NewGamePresenterProtocol {
	func createGame(with input: NewGameUserInput)
	func validate(_ input: NewGameUserInput) -> Result<GameData, ValidationErrors>
}

final class NewGamePresenter: NewGamePresenterProtocol {

	private let gameManager: GameManagerProtocol
	private weak var viewController: NewGameViewControllerProtocol?

	init(gameManager: GameManagerProtocol, viewController: NewGameViewControllerProtocol?) {
		self.gameManager = gameManager
		self.viewController = viewController
	}

	func createGame(with input: NewGameUserInput) {
		switch validate(input) {
		case .success(let gameDetails):
			let newGame = gameManager.createGame(with: gameDetails)
			if let newGame = newGame {
				gameManager.setCurrentGame(newGame)
				viewController?.gameCreated()
			}
		case .failure(let errors):
			viewController?.renderErrorStatus(errors)
		}
	}

	func validate(_ input: NewGameUserInput) -> Result<GameData, ValidationErrors> {
		var errors: [ValidationError] = []
		let gameTitle = !input.gameTitle.isEmpty ? input.gameTitle : "New game"

		let playerNames = Array(input.playerNames.prefix(input.playerCount)).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
		for index in 0..<playerNames.count where playerNames[index].isEmpty {
				errors.append(.emptyPlayerName(index: index))
		}

		let playerData = playerNames.map { PlayerData(name: $0, rolls: []) }

		if errors.isEmpty {
			return .success(GameData(title: gameTitle, players: playerData))
		} else {
			return .failure(ValidationErrors(validationErrors: errors))
		}
	}
}
