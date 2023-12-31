//
//  CreatePresetWorkout.swift
//  PumpBuddy
//
//  Created by udit on 15/10/23.
//

import SwiftUI

struct CreatePresetWorkout: View {
    /// Environment variable for CoreData operations
    @Environment(\.managedObjectContext) var moc
    
    /// Environment variable to get background mode
    @Environment(\.colorScheme) var colorScheme
    
    /// Fetch ``PresetWorkout`` data from CoreData
    @FetchRequest(entity: PresetWorkout.entity(), sortDescriptors: []) var works: FetchedResults<PresetWorkout>
    
    ///Title of the workout
    @State var workoutTitle: String = ""
    
    ///Any notes for the workout
    @State var workoutNotes: String = ""
    
    /// If workout is favourite
    @State private var isFavourite: Bool = false
    
    /// If preset workout is saved
    @State var isWorkoutAdded = false
    
    /// Alert if workout is already saved
    @State private var showAlert = false
    
    /// State var to re-order exercises
    @State private var reOrder = false

    
    
    /// Array to temporarily store ``ExercisePerformed`` objects
    @State var exe : [ExercisePerformed] = []
    
    
    var body: some View {
        
        
        
        NavigationStack{
            ScrollView{
                VStack {
                    Divider()
                    VStack{
                        TextField("Workout Name", text: $workoutTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        Divider()
                        TextField("Notes", text: $workoutNotes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        Divider()
                    }
                    Divider()
                    if exe.count > 0{
                        HStack{
                            Text("Exercises")
                                .bold()
                            Spacer()
                            Image(systemName: "arrow.up.arrow.down")
                                .onTapGesture{
                                    reOrder.toggle()
                                }
                        }
                        .padding(.horizontal)
                            ForEach(Array($exe.enumerated()), id: \.element.id) { index, e in
                                HStack {
                                    if e.id != nil {
                                        VStack{
                                            HStack{
                                                Spacer()
                                                Image(systemName: "x.circle")
                                                    .onTapGesture {
                                                        deleteExercise(e)
                                                    }
                                                    .foregroundColor(.red)
                                            }
                                            SavedExercise(exercise: e)
                                            Divider()
                                        }
                                    }
                                }
                            }
                    }

                    Spacer()
                    Spacer()
                    NavigationLink{
                        SearchExercises(exercisesAdded: $exe)
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
                
                .navigationTitle("Workout")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            //                            if isWorkoutAdded{
                            //                                Alert(title: Text("Already Added!"))
                            //                            } else if exe.isEmpty{
                            //                                Alert(title: Text("Kindly add exercises!"))
                            //                            } else if workoutTitle.isEmpty{
                            //                                Alert(title: Text("Workout title missing"))
                            //                            } else{
                            //                                let newWorkout = PresetWorkout(context: moc)
                            //                                newWorkout.name = workoutTitle
                            //                                newWorkout.exercises = NSSet(array: exe)
                            //                                newWorkout.id = UUID()
                            //                                newWorkout.isFavourite = isFavourite
                            //                                newWorkout.describe = workoutNotes
                            //
                            //                                try? moc.save()
                            //                                isWorkoutAdded = true
                            //                            }
                            if isWorkoutAdded {
                                showAlert = true
                            } else if exe.isEmpty {
                                showAlert = true
                            } else if workoutTitle.isEmpty {
                                showAlert = true
                            } else {
                                let newWorkout = PresetWorkout(context: moc)
                                newWorkout.name = workoutTitle
                                newWorkout.exercises = NSSet(array: exe)
                                newWorkout.id = UUID()
                                newWorkout.isFavourite = isFavourite
                                newWorkout.describe = workoutNotes
                                
                                try? moc.save()
                                isWorkoutAdded = true
                            }
                        }) {
                            Text("Create Workout")
                                .frame(width: 100, height: 25)
                                .background(colorScheme == .dark ? .white : .black)
                                .cornerRadius(10)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .font(.system(size: 13))
                                .bold()
                                .padding(.leading, 5.0)
                        }
                        .disabled(isWorkoutAdded)
                    }
                }
                .alert(isPresented: $showAlert) {
                            switch true {
                            case isWorkoutAdded:
                                return Alert(title: Text("Already Added!"))
                            case exe.isEmpty:
                                return Alert(title: Text("Kindly add exercises!"))
                            case workoutTitle.isEmpty:
                                return Alert(title: Text("Workout title missing"))
                            default:
                                return Alert(title: Text("Workout Added!"))
                            }
                        }
                .toolbarBackground(
                    Color("AppColor"),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
        .popover(isPresented: $reOrder){
            ReOrderExercise(exe: $exe)
        }
    }
    
    
    struct CreatePresetWorkout_Previews: PreviewProvider {
        static var previews: some View {
            CreatePresetWorkout()
        }
    }
    
    
    /// Function to remove exercise from ``exe``
    /// - Parameter exercise: ``ExercisePerformed`` Object that is to be removed
    func deleteExercise(_ exercise: Binding<ExercisePerformed>) {
        if let index = exe.firstIndex(where: { $0.id == exercise.id }) {
            exe.remove(at: index)
        }
    }

    
}


/// View to display added exercise
struct SavedExercise: View{
    
    /// Binding Exercise to be displayed
    @Binding var exercise : ExercisePerformed
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    /// State variable to display exercise details
    @State var popUp = false
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack{
                Text(exercise.exercise?.name ?? "Exercise")
                    .bold()
                
                VStack{
                    Button{
                        popUp = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $popUp){
                        ExerciseDetailsView(exercise: exercise.exercise ?? Exercise())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(10)
        }
        
    }
}

