//
//  PresetWorkout+CoreDataProperties.swift
//  PumpBuddy
//
//  Created by udit on 15/10/23.
//
//

import Foundation
import CoreData


extension PresetWorkout {

    /// Request to fetch **Preset Workout** Data from CoreData
    /// - Returns: Preset Workout data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PresetWorkout> {
        return NSFetchRequest<PresetWorkout>(entityName: "PresetWorkout")
    }

    /// Any notes for the Workout
    @NSManaged public var describe: String?
    
    /// Unique ID of the Preset Workout
    @NSManaged public var id: UUID?
    
    /// Variable to know if workout is complete
    @NSManaged public var isFavourite: Bool
    
    /// Name of the preset workout
    @NSManaged public var name: String?
    
    /// Array of ``ExercisePerformed`` objects
    /// Similar to ``Workout/exercises``
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension PresetWorkout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExercisePerformed)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExercisePerformed)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension PresetWorkout : Identifiable {

}
