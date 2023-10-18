//
//  Exercise+CoreDataProperties.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//
//

import Foundation
import CoreData


extension Exercise {

    /// Request to fetch **Exercise** Data from CoreData
    /// - Returns: Exercise data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    /// Unique ID of the Exercise
    @NSManaged public var id: UUID?
    
    /// Name of the exercise
    @NSManaged public var name: String?
    
    /// Instructions on how to perform the exercise
    @NSManaged public var instructions: String?
    
    /// Exercise type
    /// - Example: Cardio, Strength Training, Stretching
    @NSManaged public var type: String?
    
    /// Muscle group trageted by the exercise
    @NSManaged public var muscles: String?
    
    /// Variable to know if exercise is favourite
    @NSManaged public var isFavourite: Bool
    
    /// Refer to ``ExercisePerformed``
    @NSManaged public var exercisePerformed: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Exercise"
    }
    
    public var wrappedInstructions: String {
        instructions ?? ""
    }
    
    public var wrappedType: String {
        type ?? "Unknown Type"
    }
    
    public var wrappedMuscles: String {
        muscles ?? "Other"
    }
    
    public var wrappedFav: Bool {
        isFavourite
    }
    
//    public var exerciseArray: [ExercisePerformed] {
//        let set = exercisePerformed as? Set<ExercisePerformed> ?? []
//        
//        return set
//    }

}

// MARK: Generated accessors for exercisePerformed
extension Exercise {

    @objc(addExercisePerformedObject:)
    @NSManaged public func addToExercisePerformed(_ value: ExercisePerformed)

    @objc(removeExercisePerformedObject:)
    @NSManaged public func removeFromExercisePerformed(_ value: ExercisePerformed)

    @objc(addExercisePerformed:)
    @NSManaged public func addToExercisePerformed(_ values: NSSet)

    @objc(removeExercisePerformed:)
    @NSManaged public func removeFromExercisePerformed(_ values: NSSet)

}

extension Exercise : Identifiable {

}
