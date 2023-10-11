//
//  ExercisePerformed+CoreDataProperties.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//
//

import Foundation
import CoreData


extension ExercisePerformed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExercisePerformed> {
        return NSFetchRequest<ExercisePerformed>(entityName: "ExercisePerformed")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var exercise: Exercise?
    @NSManaged public var workout: Workout?
    @NSManaged public var sets: NSSet?
    
//    public var setsArray: [Set] {
//        let array = sets as? Set<Set> ?? []
//        
//        return array
//    }

}

// MARK: Generated accessors for sets
extension ExercisePerformed {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: Set)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: Set)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension ExercisePerformed : Identifiable {

}
