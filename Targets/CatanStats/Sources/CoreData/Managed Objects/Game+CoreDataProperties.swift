//
//  Game+CoreDataProperties.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.06.24.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var isCurrent: Bool
    @NSManaged public var title: String?
    @NSManaged public var currentPlayerIndex: Int16
    @NSManaged public var rolls: NSOrderedSet?
    @NSManaged public var players: NSOrderedSet?

}

// MARK: Generated accessors for rolls
extension Game {

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

// MARK: Generated accessors for players
extension Game {

    @objc(insertObject:inPlayersAtIndex:)
    @NSManaged public func insertIntoPlayers(_ value: Player, at idx: Int)

    @objc(removeObjectFromPlayersAtIndex:)
    @NSManaged public func removeFromPlayers(at idx: Int)

    @objc(insertPlayers:atIndexes:)
    @NSManaged public func insertIntoPlayers(_ values: [Player], at indexes: NSIndexSet)

    @objc(removePlayersAtIndexes:)
    @NSManaged public func removeFromPlayers(at indexes: NSIndexSet)

    @objc(replaceObjectInPlayersAtIndex:withObject:)
    @NSManaged public func replacePlayers(at idx: Int, with value: Player)

    @objc(replacePlayersAtIndexes:withPlayers:)
    @NSManaged public func replacePlayers(at indexes: NSIndexSet, with values: [Player])

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSOrderedSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSOrderedSet)

}

extension Game : Identifiable {

}
