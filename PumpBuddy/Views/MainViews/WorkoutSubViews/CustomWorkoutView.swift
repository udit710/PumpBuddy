//
//  CustomWorkoutView.swift
//  PumpBuddy
//
//  Created by Chaitanya Bhide on 23/8/2023.
//
import SwiftUI

//View to add a workout
struct CustomWorkoutView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var workoutTitle = ""
    @State private var selectedMuscle = chest.name.description
    @State private var exerciseSelected: [MuscleGroup] = []
    @State private var isWorkoutAdded = false
        
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack {
                    Divider()
                    
                    TextField("Workout Name", text: $workoutTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    NavigationLink{
                        SearchExercises()
                    }label: {
                        HStack {
                            Text("Add Exercise")
                            .frame(width: 100, height: 25)
                            .background(Color("Pink"))
                            .cornerRadius(10)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .font(.system(size: 13))
                            .bold()
                            .padding(.leading)
                        }
                        
                    }
                    
                    if isWorkoutAdded {
                        Text("Workout Added!")
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    }
                }
                
                .navigationTitle("Custom Workouts")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            isWorkoutAdded = true
                        }) {
                            Text("Add Workout")
                                .frame(width: 100, height: 25)
                                .background(colorScheme == .dark ? .white : .black)
                                .cornerRadius(10)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .font(.system(size: 13))
                                .bold()
                                .padding(.leading, 5.0)
                        }
                    }
                }
                .toolbarBackground(
                    Color("AppColor"),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }

    
    struct CustomWorkoutView_Previews: PreviewProvider {
        static var previews: some View {
            CustomWorkoutView()
        }
    }
    
}
