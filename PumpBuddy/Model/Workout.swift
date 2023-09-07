//
//  Workout.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import Foundation

struct Workout{
    
    //Unique identifier for workout
    var ID = UUID()
    //Workout name
    var name: String
    //Date when workout was done
    var date: Date
    //Duration of workout
    var duration: Int
    //Array of exercises - calling from exercise struct
    var exercise: [Exercise]
    //Optional description of the exercise
    var description: String?
    //Array of muscle group - calling from musclegroup struct
    var muscles: [MuscleGroup]
    
    init(name: String = "", date: Date = Date(), duration: Int = 0, exercise: [Exercise] = [], muscles: [MuscleGroup] = [], description: String = "") {
        self.name = name
        self.date = date
        self.duration = duration
        self.exercise = exercise
        self.muscles = muscles
        self.description = description
    }
}
