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
		let presenter = NewRollPresenter(coreDataStack: coreDataStack, gameManager: gameManager)
		let rollStatsViewController = NewRollViewController(
			presenter: presenter,
			sectionLayoutProviderFactory: SectionLayoutProviderFactory(),
			modelProvider: GameModelProvider()
		)

		return rollStatsViewController
	}
}
