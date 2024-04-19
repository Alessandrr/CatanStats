//
//  TestCoreDataStack.swift
//  CatanStatsTests
//
//  Created by Aleksandr Mamlygo on 19.04.24.
//

import Foundation
import CoreData
@testable import CatanStats

final class TestCoreDataStack: CoreDataStack {
	override init(modelName: String) {
		super.init(modelName: modelName)

		let persistentStoreDescription = NSPersistentStoreDescription()
		persistentStoreDescription.type = NSInMemoryStoreType

		let container = NSPersistentContainer(name: modelName)

		container.persistentStoreDescriptions = [persistentStoreDescription]

		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}

		storeContainer = container
	}
}
