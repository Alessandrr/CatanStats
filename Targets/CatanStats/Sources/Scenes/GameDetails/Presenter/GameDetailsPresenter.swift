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
	private func prepareViewData(from counters: [RollModelCounter]) -> GameDetailsViewData {
		let tableViewCounters: [RollSection: [RollModelCounter]] = [
			.numberRolls: filterCounters(counters, for: .numberRolls),
			.shipAndCastles: filterCounters(counters, for: .shipAndCastles)
		]
		let chartViewCounters: [RollModelCounter] = prepareDiceModelCountersForChart(counters)

		return GameDetailsViewData(
			tableViewCounters: tableViewCounters.filter { !$0.value.isEmpty },
			chartViewCounters: chartViewCounters
		)
	}

	private func mapSnapshotToRollCounters(
		_ snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
	) -> [RollModelCounter] {
		var counts: [DiceModel: Int] = [:]

		for id in snapshot.itemIdentifiers {
			guard let roll = try? coreDataStack.managedContext.existingObject(with: id) as? Roll else { return [] }

			switch roll {
			case let roll as DiceRoll:
				let model = NumberDiceModel(rollResult: Int(roll.value))
				counts[model, default: 0] += 1
			case roll as ShipRoll:
				let model = ShipAndCastlesDiceModel(rollResult: .ship)
				counts[model, default: 0] += 1
			case let roll as CastleRoll:
				if let color = roll.color, let castleColor = CastleColor(rawValue: color) {
					let model = ShipAndCastlesDiceModel(rollResult: .castle(color: castleColor))
					counts[model, default: 0] += 1
				}
			default:
				assertionFailure("New type of roll not processed")
			}
		}

		return counts.map { RollModelCounter(diceModel: $0.key, count: $0.value) }.sorted { counter1, counter2 in
			if counter1.count != counter2.count {
				return counter1.count > counter2.count
			}
			// Maintaints consistent order for items with equal counts
			return counter1.hashValue > counter2.hashValue
		}
	}

	private func filterCounters(_ counters: [RollModelCounter], for section: RollSection) -> [RollModelCounter] {
		switch section {
		case .numberRolls:
			counters.filter { $0.diceModel is NumberDiceModel }
		case .shipAndCastles:
			counters.filter { $0.diceModel is ShipAndCastlesDiceModel }
		}
	}

	private func prepareDiceModelCountersForChart(_ counters: [RollModelCounter]) -> [RollModelCounter] {
		var chartCounters: [RollModelCounter] = []

		gameModelProvider.makeModelsForSection(.numberRolls).forEach { diceModel in
			guard let expectedDiceModel = diceModel as? NumberDiceModel else { return }

			chartCounters.append(
				counters.first { counter in
					counter.diceModel == expectedDiceModel
				} ?? RollModelCounter(diceModel: expectedDiceModel, count: 0)
			)
		}

		gameModelProvider.makeModelsForSection(.shipAndCastles).forEach { diceModel in
			guard let expectedDiceModel = diceModel as? ShipAndCastlesDiceModel else { return }

			chartCounters.append(
				counters.first { counter in
					counter.diceModel ==  expectedDiceModel
				} ?? RollModelCounter(diceModel: expectedDiceModel, count: 0)
			)
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
		let counters = mapSnapshotToRollCounters(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>)
		let viewData = prepareViewData(from: counters)

		viewController?.render(viewData)
	}
}
