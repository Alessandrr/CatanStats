//
//  MainPageViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class MainPageViewController: UITabBarController {
	private let coreDataStack = CoreDataStack(modelName: "CatanStats")

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabs()
	}

	private func setupTabs() {
		let controllers = TabBarPage.allCases.map { getTabController($0) }

		setViewControllers(controllers, animated: true)
	}

	private func getTabController(_ page: TabBarPage) -> UINavigationController {
		let navigationController = UINavigationController()

		switch page {
		case .rolls:
			navigationController.setViewControllers(
				[NewRollAssembly().makeViewController(coreDataStack: coreDataStack)],
				animated: true
			)
		case .history:
			navigationController.setViewControllers(
				[GameListAssembly().makeViewController(coreDataStack: coreDataStack, navigationController: navigationController)],
				animated: true
			)
		}

		navigationController.tabBarItem = UITabBarItem(
			title: page.pageTitle(),
			image: page.pageIcon(),
			tag: page.pageOrderNumber
		)

		return navigationController
	}
}
