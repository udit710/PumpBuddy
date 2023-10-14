//
//  CreatePresetWorkout.swift
//  PumpBuddy
//
//  Created by udit on 15/10/23.
//

import SwiftUI

struct CreatePresetWorkout: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: PresetWorkout.entity(), sortDescriptors: []) var works: FetchedResults<PresetWorkout>
    
    @State var workoutTitle: String = ""
    @State var workoutNotes: String = ""
    
    @State private var isFavourite: Bool = false
    
    @State var isWorkoutAdded = false
    @State private var showAlert = false

    
    
    // Array to temporarily store exercises performed
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
                        
                        HStack{
                            Spacer()
                            Image(systemName: !isFavourite ? "heart" : "heart.fill")
                                .onTapGesture {
                                    isFavourite.toggle()
                                }
                        }
                    }
                    if exe.count > 0{
                            ForEach(Array($exe.enumerated()), id: \.element.id) { index, e in
                                HStack {
                                    if e.id != nil {
                                        SavedExercise(exercise: e)
                                        Image(systemName: "x.circle")
                                            .onTapGesture {
                                                deleteExercise(e)
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
//                        .onTapGesture {
//                            if isWorkoutAdded{
//                                Alert(title: Text("Already Added!"))
//                            } else if exe.isEmpty{
//                                Alert(title: Text("Kindly add exercises!"))
//                            } else if workoutTitle.isEmpty{
//                                Alert(title: Text("Workout title missing"))
//                            }
//                        }
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
    }
    
    
    struct CreatePresetWorkout_Previews: PreviewProvider {
        static var previews: some View {
            CreatePresetWorkout()
        }
    }
    
    func deleteExercise(_ exercise: Binding<ExercisePerformed>) {
        if let index = exe.firstIndex(where: { $0.id == exercise.id }) {
            exe.remove(at: index)
        }
    }

    
}

struct SavedExercise: View{
    @Binding var exercise : ExercisePerformed
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State var popUp = false



    @State var sets : [Set] = []

    var body: some View{
        VStack(alignment: .leading) {
            HStack{
                Text(exercise.exercise?.name ?? "Exercise")
                    .font(.largeTitle)
                    .bold()
                
                Text("Weight")
                
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

