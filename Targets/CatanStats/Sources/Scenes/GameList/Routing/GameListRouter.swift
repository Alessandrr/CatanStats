//
//  GameListRouter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit
import CoreData

protocol GameListRouterProtocol {
	func routeToGameDetails(for gameID: NSManagedObjectID?)
	func routeToNewGame()
}

final class GameListRouter: GameListRouterProtocol {
	private weak var navigationController: UINavigationController?
	private let coreDataStack: CoreDataStack
	private let gameManager: GameManagerProtocol

	init(navigationController: UINavigationController?, coreDataStack: CoreDataStack, gameManager: GameManagerProtocol) {
		self.navigationController = navigationController
		self.coreDataStack = coreDataStack
		self.gameManager = gameManager
	}

	func routeToGameDetails(for gameID: NSManagedObjectID?) {
		navigationController?.pushViewController(
			GameDetailsAssembly().makeViewController(coreDataStack: coreDataStack, gameID: gameID),
			animated: true
		)
	}

	func routeToNewGame() {
		navigationController?.present(
			UINavigationController(rootViewController: NewGameAssembly().makeViewController(gameManager: gameManager)),
			animated: true
		)
	}
}
