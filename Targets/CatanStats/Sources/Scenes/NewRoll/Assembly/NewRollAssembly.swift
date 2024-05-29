//
//  NewRollAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class NewRollAssembly {
	func makeViewController(coreDataStack: CoreDataStack, gameManager: GameManagerProtocol) -> UIViewController {
		let newRollViewController = NewRollViewController(
			sectionLayoutProviderFactory: SectionLayoutProviderFactory(),
			modelProvider: GameModelProvider()
		)
		let presenter = NewRollPresenter(
			coreDataStack: coreDataStack,
			gameManager: gameManager,
			viewController: newRollViewController
		)
		newRollViewController.presenter = presenter

		return newRollViewController
	}
}
