//
//  NewRollAssembler.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

final class NewRollAssembler {
	func assembly() -> NewRollViewController {
		let presenter = NewRollPresenter()
		let rollStatsViewController = NewRollViewController(
			presenter: presenter,
			sectionLayoutProviderFactory: SectionLayoutProviderFactory()
		)

		return rollStatsViewController
	}
}
