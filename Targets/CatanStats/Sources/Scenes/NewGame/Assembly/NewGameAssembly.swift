//
//  NewGameAssembly.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 15.06.24.
//

import UIKit

final class NewGameAssembly {
	func makeViewController(gameManager: GameManagerProtocol) -> UIViewController {
		let newGameViewController = NewGameViewController()
		let presenter = NewGamePresenter(gameManager: gameManager, viewController: newGameViewController)

		newGameViewController.presenter = presenter

		return newGameViewController
	}
}
