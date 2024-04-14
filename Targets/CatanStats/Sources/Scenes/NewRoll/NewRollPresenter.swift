//
//  RollStatsPresenter.swift
//  CatanStats
//
//  Created by Александр Мамлыго on /74/2567 BE.
//  Copyright © 2567 BE tuist.io. All rights reserved.
//

import Foundation
import CoreData

protocol INewRollPresenter {
	func didSelectRollItem(_ item: NewRollModel)
	func loadData()
}

final class NewRollPresenter: INewRollPresenter {
	private var coreDataStack: CoreDataStack

	init(coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
	}

	func didSelectRollItem(_ item: NewRollModel) {
		switch item {
		case .number(let rollResult):
			let roll = DiceRoll(context: coreDataStack.managedContext)
			roll.value = Int16(rollResult)
			coreDataStack.saveContext()
		case .ship:
			break
		case .castle(let color):
			break
		}
	}

	func loadData() {
		do {
			let fetchReq = DiceRoll.fetchRequest()
			let results = try coreDataStack.managedContext.fetch(fetchReq)
			print(results)
		} catch let error {
			print("Fetch error \(error.localizedDescription)")
		}
	}
}
