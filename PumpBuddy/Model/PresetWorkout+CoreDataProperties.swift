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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PresetWorkout> {
        return NSFetchRequest<PresetWorkout>(entityName: "PresetWorkout")
    }

    @NSManaged public var describe: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
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
