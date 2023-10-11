//
//  ExplorePageView.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view is a scroll view for exploring new workouts
struct ExplorePageView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Workout.entity(), sortDescriptors: [])var workoutSampleData: FetchedResults<Workout>
    @State var i: Int = 0
    var body: some View {
        VStack {
            if workoutSampleData.count == 0 {
                List{
                    ExploreCard(title: "Running", description: "Take a 2km jog.", setCount: 0, imageSet: ["Running-explore"])
                }
            }else{
                List(workoutSampleData.reversed()){ workout in
                    //                let exe = workout.exercises?.allObjects as? [ExercisePerformed]
                    //                ExploreCard(title: workout.name ?? "Workout", description: exe?[0].exercise?.name ?? "none")
                    if let exe = workout.exercises?.allObjects as? [ExercisePerformed], !exe.isEmpty {
                        if let ss = exe[0].sets?.allObjects as? [Set],
                           !ss.isEmpty{
                            ExploreCard(title: workout.name ?? "Workout", description: exe[0].exercise?.name ?? "none", setCount: Int(ss[0].weight))
                        }else{
                            ExploreCard(title: workout.name ?? "Workout", description: exe[0].exercise?.name ?? "none", setCount: exe[0].sets?.count ?? 0)
                        }
                    } else {
                        ExploreCard(title: workout.name ?? "Workout", description: "No exercises", setCount: 0)
                    }
                }
            }

            Button("Add"){
                let workout = Workout(context: moc)
                workout.id = UUID()
                workout.name = "Leg Day"
                workout.describe = "Intense squat session"
                workout.date = Date()
                workout.duration = 50
                workout.isFavourite = false
                
                let exercise = Exercise(context: moc)
                exercise.name = "Squat"
                exercise.id = UUID()
                exercise.type = "weight"
                exercise.muscles = "legs"
                exercise.isFavourite = false
                
                let thisEx = ExercisePerformed(context: moc)
                thisEx.id = UUID()
                thisEx.exercise = exercise
                
//                let set1 = Set(context: moc)
//                set1.weight = 20
//                set1.id = UUID()
//
//                thisEx.sets = [set1]
                
                workout.exercises = [thisEx]
                
                try? moc.save()
            
            }
        }
        .navigationTitle("Explore Workouts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color("AppColor"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct ExplorePageView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePageView()
    }
}

struct ExploreCard: View{
    var title : String
    var description : String
    var setCount: Int
    var imageSet: [String] = ["Running-explore", "Weights-explore", "HIIT-explore"]
    var body: some View{
        VStack(alignment: .leading) {
            Image(imageSet.randomElement() ?? "Running-Explore")
                .resizable()
            .scaledToFit()
            Text(title)
                .font(.largeTitle)
                .bold()
            Text(description)
            Text("Sets: \(setCount)")
        }
        
    }
}
