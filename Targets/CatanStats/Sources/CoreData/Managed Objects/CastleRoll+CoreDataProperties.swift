//
//  CastleRoll+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 21.04.24.
//
//

import Foundation
import CoreData


extension CastleRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CastleRoll> {
        return NSFetchRequest<CastleRoll>(entityName: "CastleRoll")
    }

    @NSManaged public var color: String?

}
