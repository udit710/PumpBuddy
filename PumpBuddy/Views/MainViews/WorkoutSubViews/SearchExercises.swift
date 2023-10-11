//
//  SearchExercises.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view allows user to search and add workouts
struct SearchExercises: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme


    @State private var searchText = ""
    @FetchRequest(entity: Exercise.entity(), sortDescriptors: []) var exercises: FetchedResults<Exercise>
    
    @Binding var exercisesAdded : [ExercisePerformed]
//    @State var thisWorkout : Workout = Workout()

    var filteredExercises: [Exercise]{
        guard !searchText.isEmpty else { return Array(exercises)}
        return exercises.filter{$0.name!.localizedCaseInsensitiveContains(searchText)}
    }
    
    func addToWorkout(thisWorkout: Workout){
        thisWorkout.id = UUID()
        thisWorkout.name = "na"
        thisWorkout.date = Date()
        thisWorkout.duration = 10
        thisWorkout.exercises = NSSet(array: exercisesAdded)
    }

    var body: some View {
        NavigationStack{
                List(filteredExercises){ex in
                    ExerciseCard(ex: ex, exercisesAdded: $exercisesAdded, appendExercise: appendExercise)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Exercises")
            Button("Add"){
                let exercise = Exercise(context: moc)
                exercise.id=UUID()
                exercise.name = "Bench Press"
                exercise.muscles = "Chest"
                exercise.type = "strength"
                exercise.isFavourite = false
                
//                let thisWorkout = Workout(context: moc)
//                thisWorkout.id = UUID()
//                thisWorkout.name = "na"
//                thisWorkout.date = Date()
//                thisWorkout.duration = 10
//                thisWorkout.exercises = NSSet(array: exercisesAdded)
                
                let exp = ExercisePerformed(context: moc)
                exp.id = UUID()
                
//                addToWorkout(thisWorkout: thisWorkout)
                
//                exp.workout = thisWorkout
                
//                exercise.exercisePerformed = [exp]
                
                try? moc.save()
                
            }
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar{
//            ToolbarItem(placement: .navigationBarTrailing){
//                Button(action: {
//                    try? moc.save()
//                }) {
//                    Text("Add Workout")
//                        .frame(width: 100, height: 25)
//                        .background(colorScheme == .dark ? .white : .black)
//                        .cornerRadius(10)
//                        .foregroundColor(colorScheme == .dark ? .black : .white)
//                        .font(.system(size: 13))
//                        .bold()
//                        .padding(.leading, 5.0)
//                }
//            }
//        }
    }
    
    func appendExercise(ex: Exercise){
        let newEx = ExercisePerformed(context: moc)
        newEx.id = UUID()
        newEx.exercise = ex
        newEx.sets = []
//        newEx.workout =
        exercisesAdded.append(newEx)
    }
}

struct SearchExercises_Previews: PreviewProvider {
    static var previews: some View {
        SearchExercises(exercisesAdded: .constant([]))
    }
}

struct ExerciseCard: View {
    var ex: Exercise
    @Binding var exercisesAdded : [ExercisePerformed]
//    @Binding var thisWorkout : Workout
    var tempExercises : [ExercisePerformed] = []
    var appendExercise: (Exercise) -> Void

    @State var clicked: Bool = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(ex.name ?? "exercise name")
                        .font(.largeTitle)
                    Spacer()

                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Image(systemName: clicked ? "checkmark.circle.fill" : "checkmark.circle")
                        }
                        Text("(\(ex.muscles ?? "none"))")
                            .bold()
                    }
                }
                Spacer()
                HStack {
                    Text(ex.instructions ?? "")
                    Spacer()
                }
            }
            .onTapGesture {
                clicked = true
                appendExercise(ex)
            }
            .padding()
            .background(clicked ? Color("Pink") : Color("AppColor"))
            .cornerRadius(15)
            .padding(clicked ? 5 : 0)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 10, leading: 10,bottom: 10, trailing: 10))
        
        
    }
    
    
}
