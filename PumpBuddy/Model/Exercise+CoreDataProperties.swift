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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var instructions: String?
    @NSManaged public var type: String?
    @NSManaged public var muscles: String?
    @NSManaged public var isFavourite: Bool
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
