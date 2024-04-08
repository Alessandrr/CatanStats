//
//  RollStatsAssembler.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 09.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

final class RollStatsAssembler {
	func assembly() -> RollStatsViewController {
		let presenter = RollStatsPresenter()
		let rollStatsViewController = RollStatsViewController(
			presenter: presenter,
			sectionLayoutProviderFactory: SectionLayoutProviderFactory()
		)

		return rollStatsViewController
	}
}
