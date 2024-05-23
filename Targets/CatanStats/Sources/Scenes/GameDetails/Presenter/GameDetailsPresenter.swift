//
//  GameDetailsPresenter.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 27.04.24.
//

import CoreData
import UIKit

protocol GameDetailsPresenterProtocol {
	func loadData()
}

final class GameDetailsPresenter: NSObject, GameDetailsPresenterProtocol {

	// MARK: Dependencies
	private weak var viewController: GameDetailsViewControllerProtocol?
	private var coreDataStack: CoreDataStack
	private var gameID: NSManagedObjectID
	private var gameModelProvider: GameModelProviderProtocol

	// MARK: Private properties
	private lazy var fetchedResultsController: NSFetchedResultsController<Roll> = {
		let fetchRequest = Roll.fetchRequest()

		let sortDescriptor = NSSortDescriptor(
			key: #keyPath(Roll.dateCreated),
			ascending: true
		)

		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.predicate = NSPredicate(format: "game == %@", gameID)

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: coreDataStack.managedContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
		fetchedResultsController.delegate = self

		return fetchedResultsController
	}()

	// MARK: Initialization
	init(
		viewController: GameDetailsViewControllerProtocol,
		coreDataStack: CoreDataStack,
		gameID: NSManagedObjectID,
		gameModelProvider: GameModelProviderProtocol
	) {
		self.viewController = viewController
		self.coreDataStack = coreDataStack
		self.gameID = gameID
		self.gameModelProvider = gameModelProvider
	}

	// MARK: Internal methods
	func loadData() {
		do {
			try fetchedResultsController.performFetch()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}

	// MARK: Private methods
	private func mapSnapshotToRollCounters(
		_ snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
	) -> [RollModelCounter] {
		var counts: [RollModel: Int] = [:]

		for id in snapshot.itemIdentifiers {
			guard let roll = try? coreDataStack.managedContext.existingObject(with: id) as? Roll else { return [] }

			switch roll {
			case let roll as DiceRoll:
				let model = RollModel.number(rollResult: Int(roll.value))
				counts[model, default: 0] += 1
			case roll as ShipRoll:
				let model = RollModel.ship
				counts[model, default: 0] += 1
			case let roll as CastleRoll:
				if let color = roll.color, let castleColor = CastleColor(rawValue: color) {
					let model = RollModel.castle(color: castleColor)
					counts[model, default: 0] += 1
				}
			default:
				assertionFailure("New type of roll not processed")
			}
		}

		return counts.map { RollModelCounter(rollModel: $0.key, count: $0.value) }.sorted { counter1, counter2 in
			if counter1.count != counter2.count {
				return counter1.count > counter2.count
			}
			// Maintaints consistent order for items with equal counts
			return counter1.hashValue > counter2.hashValue
		}
	}

	private func prepareCountersForChart(_ counters: [RollModelCounter]) -> [RollModelCounter] {
		var chartCounters: [RollModelCounter] = []

		gameModelProvider.makeModelsForSection(.numberRolls).forEach { rollModel in
			guard case let RollModel.number(expectedRoll) = rollModel else { return }

			let foundCounter = counters.first { counter in
				if case .number(let rollResult) = counter.rollModel, rollResult == expectedRoll {
					return true
				}
				return false
			}

			if let foundCounter = foundCounter {
				chartCounters.append(foundCounter)
			} else {
				chartCounters.append(RollModelCounter(rollModel: rollModel, count: 0))
			}
		}

		return chartCounters
	}
}

// MARK: NSFetchedResultsControllerDelegate
extension GameDetailsPresenter: NSFetchedResultsControllerDelegate {
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
	) {
		let tableViewCounters = mapSnapshotToRollCounters(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>)
		let chartCounters = prepareCountersForChart(tableViewCounters)
		viewController?.updateTableViewModel(tableViewCounters)
		viewController?.updateChartModel(chartCounters)
	}
}
