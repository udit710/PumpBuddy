//
//  ExerciseDetailsView.swift
//  PumpBuddy
//
//  Created by udit on 11/10/23.
//

import SwiftUI

/// A View to display the exercise details in depth
/// *Displays: Name, muscle group, type and instructions*
struct ExerciseDetailsView: View {

    /// An ``Exercise``object fetched from the **API**
    var exercise : Exercise = Exercise()
    var body: some View {
        VStack{
            if let name = exercise.name {
                HStack{
                    Text("\(name.localizedCapitalized)")
                        .bold()
                        .font(.system(size: 20))
                }
                Divider().opacity(0)
            } else {
                Text("Name: None")
                Divider()
            }
            if let muscle = exercise.muscles {
                HStack{
                    Text("Muscle: \(muscle.localizedCapitalized)")
                        .bold()
                    Spacer()
                }
                Divider()
            } else {
                Text("Muscle: None")
                Divider()
            }
            
            if let type = exercise.type {
                HStack{
                    Text("Type: \(type.localizedCapitalized)")
                        .bold()
                    Spacer()
                }
                Divider()
            } else {
                Text("Type: None")
                Divider()
            }
            
            if let instructions = exercise.instructions {
                HStack{
                    Text("Instructions:").bold() + Text(" \(instructions)")
                        .font(.system(size: 15))
                    Spacer()
                }
                Divider()
            } else {
                Text("Instructions: None")
                Divider()
            }
            
            
            Divider()
            Spacer()
        }
        .padding()
        
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsView(exercise: Exercise())
    }
}
