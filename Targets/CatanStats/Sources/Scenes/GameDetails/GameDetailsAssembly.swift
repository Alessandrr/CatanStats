//
//  GameDetailsAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import UIKit
import CoreData

final class GameDetailsAssembly {
	func makeViewController(coreDataStack: CoreDataStack, gameID: NSManagedObjectID) -> UIViewController {
		let viewController = GameDetailsViewController()
		let presenter = GameDetailsPresenter(viewController: viewController, coreDataStack: coreDataStack, gameID: gameID)

		viewController.presenter = presenter

		return viewController
	}
}
