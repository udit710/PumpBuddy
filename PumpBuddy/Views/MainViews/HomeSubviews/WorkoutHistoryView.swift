//
//  WorkoutHistoryView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

//calender implementation integrated and adapted from https://medium.com/swift-productions/add-an-event-to-the-calendar-xcode-12-swift-5-3-35b8bf149859

import SwiftUI
import CoreData

struct WorkoutHistoryView: View {
    @FetchRequest(
        //adapted from https://stackoverflow.com/questions/26883270/swift-sort-array-by-sort-descriptors
        //used to sort ascending
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    private var workoutDates: [Date] {
        workouts.compactMap { $0.date }
    }

    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Add Workout")) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.horizontal)

                HStack {
                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }

                    Text("\(dateFormatter.string(from: selectedDate))")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                    ForEach(getMonthDates(), id: \.self) { date in
                        DateView(date: date, isSelected: date == selectedDate, hasWorkout: workoutDates.contains(date))
                            .onTapGesture {
                                // Handle date selection
                                selectedDate = date
                            }
                    }
                }

                Spacer()
            }
            .navigationTitle("Workout History")
            .padding(.top, -50)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func getMonthDates() -> [Date] {
        let range = Calendar.current.range(of: .day, in: .month, for: selectedDate)!
        let days = range.map { day in
            Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth())!
        }
        return days
    }

    // Helper function to get the start of the current month
    private func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
    }
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
   }
}

struct DateView: View {
    let date: Date
    let isSelected: Bool
    let hasWorkout: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .frame(width: 30, height: 30)
            .foregroundColor(isSelected ? .white : (hasWorkout ? .black : .primary))
            .background(isSelected ? Color("AppColor") : (hasWorkout ? Color.black : Color.clear))
            .clipShape(Circle())
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()

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




