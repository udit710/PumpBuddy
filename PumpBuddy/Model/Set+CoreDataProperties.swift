//
//  Set+CoreDataProperties.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//
//

import Foundation
import CoreData


extension Set {
    
    /// Request to fetch **Set** Data from CoreData
    /// - Returns: Set data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    /// Unique ID of the Set
    @NSManaged public var id: UUID?
    
    /// Weight at which the set was performed
    @NSManaged public var weight: Double
    
    /// Number of repititions performed
    @NSManaged public var reps: Int64
    
    /// Variable to check if the set is complete
    @NSManaged public var isDone: Bool
    
    /// ``ExercisePerformed`` object to manage relationship
    @NSManaged public var exercisePerformed: ExercisePerformed?

}

extension Set : Identifiable {

}
