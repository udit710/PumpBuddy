//
//  WorkoutHistoryView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//


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

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
   }
}

struct WorkoutCardView: View {
    var workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date: \(workout.date!, style: .date)")
                .font(.headline)
            Text("Name: \(workout.name ?? "")")
            Text("Duration: \(workout.duration < 1 ? 1 : workout.duration) minutes")
            Text("Description: \(workout.describe ?? "")")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 8)
    }
}



