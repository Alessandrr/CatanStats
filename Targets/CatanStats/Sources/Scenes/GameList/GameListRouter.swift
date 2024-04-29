//
//  GameListRouter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.04.24.
//

import UIKit
import CoreData

protocol GameListRouterProtocol {
	func routeToGameDetails(for gameID: NSManagedObjectID)
}

final class GameListRouter: GameListRouterProtocol {
	private weak var navigationController: UINavigationController?
	private var coreDataStack: CoreDataStack

	init(navigationController: UINavigationController?, coreDataStack: CoreDataStack) {
		self.navigationController = navigationController
		self.coreDataStack = coreDataStack
	}

	func routeToGameDetails(for gameID: NSManagedObjectID) {
		navigationController?.pushViewController(
			GameDetailsAssembly().makeViewController(coreDataStack: coreDataStack, gameID: gameID),
			animated: true
		)
	}
}
