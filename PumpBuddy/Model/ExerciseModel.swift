//
//  ExerciseModel.swift
//  PumpBuddy
//
//  Created by udit on 13/10/23.
//

import Foundation

struct ExerciseModel: Decodable, Hashable {
    var name: String
    var type: String
    var muscle: String
    var equipment: String
    var difficulty: String
    var instructions: String
}
