//
//  GameListAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit

final class GameListAssembly {
	func makeViewController(
		coreDataStack: CoreDataStack,
		navigationController: UINavigationController,
		gameManager: GameManager
	) -> UIViewController {
		let router = GameListRouter(
			navigationController: navigationController,
			coreDataStack: coreDataStack,
			gameManager: gameManager
		)
		let viewController = GameListViewController()
		let presenter = GameListPresenter(
			coreDataStack: coreDataStack,
			gameListViewController: viewController,
			gameManager: gameManager,
			router: router
		)

		viewController.presenter = presenter

		return viewController
	}
}
