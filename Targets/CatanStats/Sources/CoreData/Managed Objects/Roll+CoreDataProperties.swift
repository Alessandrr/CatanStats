//
//  Roll+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 26.04.24.
//
//

import Foundation
import CoreData

extension Roll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roll> {
        return NSFetchRequest<Roll>(entityName: "Roll")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var game: Game?

}

extension Roll: Identifiable {

}
