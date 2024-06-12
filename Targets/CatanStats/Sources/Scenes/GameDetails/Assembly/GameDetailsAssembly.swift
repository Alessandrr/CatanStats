//
//  GameDetailsAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import UIKit
import CoreData

final class GameDetailsAssembly {
	func makeViewController(
		coreDataStack: CoreDataStack,
		gameID: NSManagedObjectID?,
		gameModelProvider: GameModelProviderProtocol = GameModelProvider()
	) -> UIViewController {
		let viewController = GameDetailsViewController()
		let presenter = GameDetailsPresenter(
			viewController: viewController,
			coreDataStack: coreDataStack,
			gameID: gameID,
			gameModelProvider: gameModelProvider
		)

		viewController.presenter = presenter

		return viewController
	}
}
