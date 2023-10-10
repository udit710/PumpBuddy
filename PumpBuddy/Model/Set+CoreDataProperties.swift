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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var weight: Double
    @NSManaged public var reps: Int64
    @NSManaged public var exercisePerformed: ExercisePerformed?

}

extension Set : Identifiable {

}
