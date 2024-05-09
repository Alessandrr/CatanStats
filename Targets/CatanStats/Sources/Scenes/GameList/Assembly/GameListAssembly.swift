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
		navigationController: UINavigationController
	) -> UIViewController {
		let router = GameListRouter(navigationController: navigationController, coreDataStack: coreDataStack)
		let viewController = GameListViewController(router: router)
		let presenter = GameListPresenter(coreDataStack: coreDataStack, gameListViewController: viewController)

		viewController.presenter = presenter

		return viewController
	}
}
