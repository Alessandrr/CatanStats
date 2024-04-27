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

	init(viewController: GameDetailsViewControllerProtocol, coreDataStack: CoreDataStack, gameID: NSManagedObjectID) {
		self.viewController = viewController
		self.coreDataStack = coreDataStack
		self.gameID = gameID
	}

	// MARK: Internal methods
	func loadData() {
		do {
			try fetchedResultsController.performFetch()
		} catch let error {
			print(error.localizedDescription)
		}
	}

	// MARK: Private methods
	private func mapSnapshotToRollCounts(
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
				print("Unknown roll")
			}
		}

		return counts.map { RollModelCounter(rollModel: $0.key, count: $0.value) }.sorted { counter1, counter2 in
			if counter1.count != counter2.count {
				return counter1.count > counter2.count
			}

			return counter1.hashValue > counter2.hashValue
		}
	}
}

// MARK: NSFetchedResultsControllerDelegate
extension GameDetailsPresenter: NSFetchedResultsControllerDelegate {
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
	) {
		let rollCounts = mapSnapshotToRollCounts(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>)
		viewController?.updateRollCounts(rollCounts)
	}
}
