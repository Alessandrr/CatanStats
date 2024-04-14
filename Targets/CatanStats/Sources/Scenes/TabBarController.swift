//
//  TabBarController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabs()
	}

	private func setupTabs() {
		let controllers = TabBarPage.allPages.map { getTabController($0) }

		setViewControllers(controllers, animated: true)
	}

	private func getTabController(_ page: TabBarPage) -> UINavigationController {
		let navigationController = UINavigationController()

		switch page {
		case .rolls:
			navigationController.setViewControllers([NewRollAssembler().assembly()], animated: true)
		case .history:
			navigationController.setViewControllers([GameHistoryViewController()], animated: true)
		}

		navigationController.tabBarItem = UITabBarItem(
			title: page.pageTitle(),
			image: page.pageIcon(),
			tag: page.pageOrderNumber
		)

		return navigationController
	}
}
