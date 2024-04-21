//
//  ShipRoll+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 16.04.24.
//
//

import Foundation
import CoreData

extension ShipRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShipRoll> {
        return NSFetchRequest<ShipRoll>(entityName: "ShipRoll")
    }
}
