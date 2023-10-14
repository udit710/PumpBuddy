//
//  WorkoutTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI


struct WorkoutTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: PresetWorkout.entity(), sortDescriptors: []) var works: FetchedResults<PresetWorkout>
    
    func deleteWorkout(at offsets: IndexSet){
        for index in offsets {
            let workout = works[index]
            moc.delete(workout)
        }
        
        try? moc.save()
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
//                    Text("Generate Workout")
//                        .bold()
//                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
//                    NavigationLink{
//                        //Empty till GenerateWorkoutView created
//                    } label: {
//                        ZStack{
//                            Text("Use Pump AI!")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color("Pink"))
//                                .cornerRadius(20)
//                        }
//                    }
                    
                    Text("New Workout")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    NavigationLink{
                        CustomWorkoutView()
                    } label: {
                        ZStack{
                            Text("Start New Workout")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Pink"))
                                .cornerRadius(20)
                        }
                    }

                    Text("Custom Workout")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    NavigationLink{
                        CreatePresetWorkout()
                    } label: {
                        ZStack{
                            Text("Create Preset Workout")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Pink"))
                                .cornerRadius(20)
                        }
                    }
                    
                    HStack{
                        Text("My Preset Workouts")
                            .bold()
                            .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                        Spacer()
//                        EditButton()
                    }
                    
//                    List{
                        ForEach(works){workout in
                            if let setOfExercises = workout.exercises {
                                let arrayOfExercises = Array(setOfExercises) as? [ExercisePerformed]
                                
                                // Now you can use arrayOfExercises as an array of ExercisePerformed objects
                                HStack{
                                    WorkoutBox(title: workout.name ?? "Workout", notes: workout.describe ?? "", excercises: arrayOfExercises ?? [])
    //                                Image(systemName: "x.circle")
    //                                    .onTapGesture {
    //                                        deleteWorkout(at: index)
    //                                    }
                                }
                            }
                        }
//                        .onDelete(perform: deleteWorkout)
//                    }
//                    .frame( maxWidth: .infinity,minHeight: minRowHeight * 20)
//                    .scrollContentBackground(.hidden)

//                    WorkoutBox(title: "Chest", excercises: ["Bench Press", "DB Fly", "Incline Bench"]){
//                        BoxButton(label: "Start Workout"){
//
//                        }
//                    }
//
//                    WorkoutBox(title: "Legs", excercises: ["Squats", "Leg Extension"]){
//                        BoxButton(label: "Start Workout"){
//
//                        }
//                    }
                }
                
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                Spacer()
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color("AppColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    struct WorkoutTabView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutTabView()
        }
    }
    
    //Header text for each section
    struct SectionHeader: View {
        var text: String
        
        var body: some View {
            Text(text)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
    
    //Button Structure for the page
    struct BoxButton: View{
        var label:String
        var action: () -> Void
        
        var body: some View {
            Button (action:action){
                Text(label.isEmpty ? "Workout" : label)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Pink"))
                    .cornerRadius(20) //taken from https://www.appcoda.com/swiftui-buttons/ and adapted for our code
            }
        }
    }
    
    //Custom layout box for displaying user created workouts
    struct WorkoutBox: View{
        var title: String
        var notes: String
        var excercises: [ExercisePerformed]
        
        var body: some View{
            NavigationStack{
                VStack(alignment: .leading, spacing: 5){
                    Text(title)
                        .font(.headline)
                    
                    
                    ForEach(excercises) {e in
                        Text("\(e.exercise?.name ?? "Exercise")")
                    }
                    
                    NavigationLink("Start Workout"){
                        CustomWorkoutView(workoutTitle: title, workoutNotes: notes, exe: excercises )
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Pink"))
                    .cornerRadius(20) //taken from https://www.appcoda.com/swiftui-buttons/ and adapted for our code
                    
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
        
    }
    
}
