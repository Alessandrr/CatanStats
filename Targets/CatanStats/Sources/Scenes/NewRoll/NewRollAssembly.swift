//
//  NewRollAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class NewRollAssembly {
	func makeViewController(coreDataStack: CoreDataStack) -> UIViewController {
		let presenter = NewRollPresenter(coreDataStack: coreDataStack)
		let rollStatsViewController = NewRollViewController(
			presenter: presenter,
			sectionLayoutProviderFactory: SectionLayoutProviderFactory()
		)

		return rollStatsViewController
	}
}
