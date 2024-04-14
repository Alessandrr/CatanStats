//
//  CoreDataStack.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 14.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
	private let modelName: String

	init(modelName: String) {
		self.modelName = modelName
	}

	lazy var managedContext: NSManagedObjectContext = {
		return storeContainer.viewContext
	}()

	private lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

	func saveContext () {
	  guard managedContext.hasChanges else { return }

	  do {
		try managedContext.save()
	  } catch let error as NSError {
		print("Unresolved error \(error), \(error.userInfo)")
	  }
	}
}
