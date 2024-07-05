//
//  Player+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 26.06.24.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?
    @NSManaged public var rolls: NSOrderedSet?

}

// MARK: Generated accessors for rolls
extension Player {

    @objc(insertObject:inRollsAtIndex:)
    @NSManaged public func insertIntoRolls(_ value: Roll, at idx: Int)

    @objc(removeObjectFromRollsAtIndex:)
    @NSManaged public func removeFromRolls(at idx: Int)

    @objc(insertRolls:atIndexes:)
    @NSManaged public func insertIntoRolls(_ values: [Roll], at indexes: NSIndexSet)

    @objc(removeRollsAtIndexes:)
    @NSManaged public func removeFromRolls(at indexes: NSIndexSet)

    @objc(replaceObjectInRollsAtIndex:withObject:)
    @NSManaged public func replaceRolls(at idx: Int, with value: Roll)

    @objc(replaceRollsAtIndexes:withRolls:)
    @NSManaged public func replaceRolls(at indexes: NSIndexSet, with values: [Roll])

    @objc(addRollsObject:)
    @NSManaged public func addToRolls(_ value: Roll)

    @objc(removeRollsObject:)
    @NSManaged public func removeFromRolls(_ value: Roll)

    @objc(addRolls:)
    @NSManaged public func addToRolls(_ values: NSOrderedSet)

    @objc(removeRolls:)
    @NSManaged public func removeFromRolls(_ values: NSOrderedSet)

}

extension Player : Identifiable {

}
