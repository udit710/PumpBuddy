//
//  ExerciseModel.swift
//  PumpBuddy
//
//  Created by udit on 13/10/23.
//

import Foundation

/// An object used to parse data fetched from **API** calls into ``Exercise`` objects
struct ExerciseModel: Decodable, Hashable {
    
    /// Name of exercise
    var name: String
    
    /// Type of exercise
    var type: String
    
    /// Muscle group covered by exercise
    var muscle: String
    
    /// Equipment needed for exercise
    var equipment: String
    
    /// Difficulty level of the exercise
    var difficulty: String
    
    /// Instructions for the exercise
    var instructions: String
}
