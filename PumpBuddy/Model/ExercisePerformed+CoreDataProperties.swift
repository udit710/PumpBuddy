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

    /// Request to fetch **ExercisePerformed** Data from CoreData
    /// - Returns: ExercisePerformed data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExercisePerformed> {
        return NSFetchRequest<ExercisePerformed>(entityName: "ExercisePerformed")
    }

    /// Unique ID of the Exercise Performed
    @NSManaged public var id: UUID?
    
    /// The ``Exercise`` object fetched from the **API** call
    @NSManaged public var exercise: Exercise?
    
    /// The ``Workout`` where this exercise is performed
    @NSManaged public var workout: Workout?
    
    /// Variable to check if this ``ExercisePerformed`` is complete
    @NSManaged public var isDone: Bool
    
    /// An array of sets having ``Set`` data about the exercise performed
    @NSManaged public var sets: NSSet?

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
