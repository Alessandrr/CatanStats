//
//  Game+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 15.04.24.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var title: String?
    @NSManaged public var rolls: NSOrderedSet?

}

// MARK: Generated accessors for rolls
extension Game {

    @objc(insertObject:inRollsAtIndex:)
    @NSManaged public func insertIntoRolls(_ value: DiceRoll, at idx: Int)

    @objc(removeObjectFromRollsAtIndex:)
    @NSManaged public func removeFromRolls(at idx: Int)

    @objc(insertRolls:atIndexes:)
    @NSManaged public func insertIntoRolls(_ values: [DiceRoll], at indexes: NSIndexSet)

    @objc(removeRollsAtIndexes:)
    @NSManaged public func removeFromRolls(at indexes: NSIndexSet)

    @objc(replaceObjectInRollsAtIndex:withObject:)
    @NSManaged public func replaceRolls(at idx: Int, with value: DiceRoll)

    @objc(replaceRollsAtIndexes:withRolls:)
    @NSManaged public func replaceRolls(at indexes: NSIndexSet, with values: [DiceRoll])

    @objc(addRollsObject:)
    @NSManaged public func addToRolls(_ value: DiceRoll)

    @objc(removeRollsObject:)
    @NSManaged public func removeFromRolls(_ value: DiceRoll)

    @objc(addRolls:)
    @NSManaged public func addToRolls(_ values: NSOrderedSet)

    @objc(removeRolls:)
    @NSManaged public func removeFromRolls(_ values: NSOrderedSet)

}

extension Game : Identifiable {

}
