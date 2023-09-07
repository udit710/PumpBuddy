//
//  MuscleGroup.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import Foundation

//Define an enumeration for muscle with some possible values
enum muscle: String, CaseIterable {
    case chest,back, quads, legs, shoulders, biceps, triceps, core, hamstrings, calf
    
    var description: String {
        return self.rawValue
    }
}

struct MuscleGroup{
    //Unique identifier for musclegroup
    var ID = UUID()
    //Name of muscle group
    var name: muscle
    //Exercises associated with the muscle group - calling from exercise struct
    var exercises: [Exercise]
    
    init(ID: UUID = UUID(), name: muscle, exercises: [Exercise]) {
        self.ID = ID
        self.name = name
        self.exercises = exercises
    }
}
