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
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Workout.entity(), sortDescriptors: []) var works: FetchedResults<Workout>
    
    @State var workoutTitle: String = ""
    @State var selectedMuscle = "chest"
    @State var isWorkoutAdded = false
    @State var exe : [ExercisePerformed] = []
    
    
    var body: some View {
        
        
        
        NavigationStack{
            ScrollView{
                VStack {
                    Divider()

                    TextField("Workout Name", text: $workoutTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    Text("\(works.count)")
                    if exe.count > 1{
                        ForEach($exe){e in
                            ShowExercise(exercise: e)
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

                .navigationTitle("Custom Workouts")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            let newWorkout = Workout(context: moc)
                            newWorkout.name = workoutTitle
                            newWorkout.exercises = NSSet(array: exe)
                            newWorkout.id = UUID()
                            newWorkout.duration = 10
                            newWorkout.date = Date()
                            newWorkout.isFavourite = false
                            newWorkout.describe = ""

                            try? moc.save()
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

struct ShowExercise: View{
    @Binding var exercise : ExercisePerformed
    @Environment(\.managedObjectContext) var moc

    @State var sets : [Set] = []

    var body: some View{
        VStack(alignment: .leading) {
            HStack{
                Text("exercise")
                    .font(.largeTitle)
                    .bold()
                Text("muscle")
                Spacer()
                Button("+"){
                    let newSet = Set(context: moc)
                    sets.append(newSet)
                }
                Spacer()
                Button("Done"){
                    let setsArray: NSSet = NSSet(array: sets)
                    exercise.sets = setsArray
                    
                    try? moc.save()
                }
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(10)
            
//            List {
            if sets.count > 0{
                ForEach((0...sets.count-1), id:\.self){i in
                    Section{
                        AddSetView(set: sets[i],index: i)
                    }
                }
            }
//            }
            
        }
        
    }
}

struct AddSetView: View{
    var set : Set
    var index: Int
    @State var weight : Double = 0
    
    let weightFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1 // Adjust as needed
            return formatter
        }()
    
    var body: some View{
        
        HStack {
            Text("Set No \(1)")
            Spacer()
            TextField("weight",value: $weight, formatter: weightFormatter )
        }
    }
}
