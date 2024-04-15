//
//  DiceRoll+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 15.04.24.
//
//

import Foundation
import CoreData


extension DiceRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiceRoll> {
        return NSFetchRequest<DiceRoll>(entityName: "DiceRoll")
    }

    @NSManaged public var value: Int16
    @NSManaged public var game: Game?

}

extension DiceRoll : Identifiable {

}
