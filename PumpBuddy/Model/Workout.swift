////
////  Workout.swift
////  PumpBuddy
////
////  Created by udit on 22/08/23.
////
//
//import Foundation
//import CoreData
//
//public class Workout: NSManagedObject, Identifiable {
//
//    //Unique identifier for workout
//    @NSManaged public var id: UUID
//    //Workout name
//    @NSManaged public var name: String
//    //Date when workout was done
//    @NSManaged public var date: NSDate
//    //Duration of workout
//    @NSManaged public var duration: Int
//    //Array of exercises - calling from exercise struct
//    @NSManaged public var exercises: [Exercise]
//    //Optional description of the exercise
//    @NSManaged public var describe: String
//    //Optional Boolean to favourite the workout
//    @NSManaged public var isFavourite: Bool
//
////    init(name: String = "", date: Date = Date(), duration: Int = 0, exercise: [Exercise] = [], description: String = "", isFavourite: Bool? = false) {
////        self.name = name
////        self.date = date
////        self.duration = duration
////        self.exercise = exercise
////        self.description = description
////        self.isFavourite = isFavourite
////    }
//}
