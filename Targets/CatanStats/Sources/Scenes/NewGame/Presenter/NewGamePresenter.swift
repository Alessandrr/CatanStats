//
//  NewGamePresenter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.06.24.
//

import Foundation

protocol NewGamePresenterProtocol {
	func createGame(with input: NewGameUserInput)
	func validate(_ input: NewGameUserInput) -> Result<NewGameUserInput, ValidationErrors>
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

	func validate(_ input: NewGameUserInput) -> Result<NewGameUserInput, ValidationErrors> {
		var errors: [ValidationError] = []
		let gameTitle = !input.gameTitle.isEmpty ? input.gameTitle : "New game"

		let playerNames = Array(input.playerNames.prefix(input.playerCount)).map {
			$0.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		for index in 0..<playerNames.count where playerNames[index].isEmpty {
			errors.append(.emptyPlayerName(index: index))
		}

		if errors.isEmpty {
			return .success(NewGameUserInput(gameTitle: gameTitle, playerCount: playerNames.count, playerNames: playerNames))
		} else {
			return .failure(ValidationErrors(validationErrors: errors))
		}
	}
}
