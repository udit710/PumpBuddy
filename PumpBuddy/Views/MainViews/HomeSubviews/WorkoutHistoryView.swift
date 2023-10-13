////
////  WorkoutHistoryView.swift
////  PumpBuddy
////
////  Created by udit on 22/08/23.
////
//
//import SwiftUI
//
//struct WorkoutHistoryView: View {
//    @State private var workoutData = workoutSampleData
//    
//    var body: some View {
//        // View to show a history of all workouts done by user
//        NavigationView{
//                if !workoutData.isEmpty{
//                    List(workoutData, id:\.ID) { ww in
//                        HStack {
//                            workoutCard(workoutData: ww)
//                        }
//                        .listRowSeparator(.hidden)
//                        .listRowInsets(.init(top: 10, leading: 10,bottom: 10, trailing: 10))
//                        .padding(.bottom, 10)
//                    }
//                    .listStyle(.plain)
//                    
//                    
//                }else
//                {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Chest")
//                            .bold()
//                            .font(.headline)
//                        Text("Date: 12/05/2023")
//                        Text("Duration: 55 minutes")
//                        Text("Exercises performed: DB Fly, Bench Press, Incline Bnech Press, Dips, Cable Cross Overs, DB Bench Press  ")
//                        Text("Muscle Group: Chest")
//                        Text("Description: Targeting upper chest, Doing less reps and going for a higher intensity and weight")
//                    }
//                    .padding(10)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.top, 40)
//                    .padding(.horizontal, 15)
//                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Legs")
//                            .bold()
//                            .font(.headline)
//                        Text("Date: 14/05/2023")
//                        Text("Duration: 1 hour")
//                        Text("Exercises performed: Squats, Goblet Squats, Leg Extensions, Walking Lunges, Hack Squat")
//                        Text("Muscle Group: Legs")
//                        Text("Description: Hitting all areas of the leg while going for a lot of reps and trying to push to failure for every set")
//                    }
//                    .padding(10)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.top, 40)
//                    .padding(.horizontal, 15)
//                }
//            }
//            .navigationTitle("Workout History")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(
//                Color("AppColor"),
//                for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//            
//
//    }
//}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
   }
}
//
////Each workout card
//struct workoutCard: View{
//    @State var workoutData : Workout
//    var body: some View{
//        
//        HStack(){
//            VStack(alignment: .leading)
//            {
//                Text(workoutData.name)
//                Spacer()
//                Spacer()
//                Text(workoutData.date, format: .dateTime.day().month().year())
//            }
//            Spacer()
//            VStack(alignment: .leading){
//                Text("\(workoutData.duration.description)m")
//                    .multilineTextAlignment(.leading)
//                ForEach(workoutData.exercise, id: \.ID){ w in
//                    Text(w.name.description)
//                }
//            }
//        }
//        .frame(width: 350)
//        .padding(10)
//        .background(Color("Pink"))
//        .cornerRadius(10)
//    }
//}


import SwiftUI
import CoreData

struct WorkoutHistoryView: View {
    @FetchRequest(
        //adapted from https://stackoverflow.com/questions/26883270/swift-sort-array-by-sort-descriptors
        //used to sort ascending
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Add Workout")) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.horizontal)

                List {
                    ForEach(workouts, id: \.id) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutCardView(workout: workout)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Workout History")
            .padding(.top, -50)
            .toolbarBackground(
                Color("AppColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WorkoutCardView: View {
    var workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date: \(workout.date!, style: .date)")
                .font(.headline)
            Text("Name: \(workout.name ?? "")")
            Text("Duration: \(workout.duration) minutes")
            Text("Description: \(workout.describe ?? "")")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 8)
    }
}



