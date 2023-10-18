//
//  Workout+CoreDataProperties.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//
//

import Foundation
import CoreData


extension Workout {
    
    /// Request to fetch **Workout** Data from CoreData
    /// - Returns: Workout data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    /// Unique ID of the Workout
    @NSManaged public var id: UUID?
    
    /// Title of the workout
    @NSManaged public var name: String?
    
    /// Date for when the workout was done
    @NSManaged public var date: Date?
    
    /// Duration for the workout
    @NSManaged public var duration: Int64
    
    /// Any notes of the workout
    @NSManaged public var describe: String?
    
    /// Variable to check if workout is complete
    @NSManaged public var isFavourite: Bool
    
    /// Array of ``ExercisePerformed`` objects to store the exercises preformed during the workout
    @NSManaged public var exercises: NSSet?
    
    /// The default weight units from when the workout was done
    @NSManaged public var units: String?

}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExercisePerformed)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExercisePerformed)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension Workout : Identifiable {

}
