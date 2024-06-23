//
//  NumberRoll+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 16.04.24.
//
//

import Foundation
import CoreData

extension NumberRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NumberRoll> {
        return NSFetchRequest<NumberRoll>(entityName: "NumberRoll")
    }

    @NSManaged public var value: Int16

}
