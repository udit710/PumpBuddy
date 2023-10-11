//
//  ExerciseDetailsView.swift
//  PumpBuddy
//
//  Created by udit on 11/10/23.
//

import SwiftUI

struct ExerciseDetailsView: View {
//    @NSManaged public var id: UUID?
//    @NSManaged public var name: String?
//    @NSManaged public var instructions: String?
//    @NSManaged public var type: String?
//    @NSManaged public var muscles: String?
//    @NSManaged public var isFavourite: Bool
//    @NSManaged public var exercisePerformed: NSSet?
    var exercise : Exercise = Exercise()
    var body: some View {
        VStack{
            if let name = exercise.name {
                Text(name)
            } else {
                Text("None")
            }
            if let instructions = exercise.instructions {
                Text(instructions)
            } else {
                Text("None")
            }
            
            if let type = exercise.type {
                Text(type)
            } else {
                Text("None")
            }
            
            if let muscle = exercise.muscles {
                Text(muscle)
            } else {
                Text("None")
            }
        }
        
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsView(exercise: Exercise())
    }
}
