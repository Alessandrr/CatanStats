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
		let router = GameListRouter(navigationController: navigationController, coreDataStsck: coreDataStack)
		let viewController = GameListViewController(coreDataStack: coreDataStack, router: router)

		return viewController
	}
}
