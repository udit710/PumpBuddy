//
//  WeekView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//
import SwiftUI
import CoreData


struct DayDate: Identifiable {
    var id: String { day }
    let day: String
    
    var formattedDate: String {
        return day
    }
}

struct WeekView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedDay: String?
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("This week's activity")
                    .padding([.leading, .bottom], 8.0)
                    .font(.custom("Arial", size: 25))
                    .bold()
                
                let weekDays = getDaysInWeek()
                
                HStack {
                    ForEach(weekDays) { dayInfo in
                        let day = dayInfo.day
                        let workoutForDay = fetchWorkoutForDay(day)
                        
                        if workoutForDay != nil {
                            NavigationLink(
                                destination: WorkoutDetailView(workout: workoutForDay!),
                                isActive: Binding(
                                    get: { selectedDay == day },
                                    set: { _ in selectedDay = nil }
                                ) // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
                            ) {
                                CircleView(day: day, done: true, isSelected: selectedDay == day)
                                    .onTapGesture {
                                        selectedDay = day
                                    } // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
                            }
                        } else {
                            CircleView(day: day, done: false, isSelected: selectedDay == day)
                                .opacity(0.5) // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
                        }
                    }
                }
                .foregroundColor(colorScheme == .light ? .white : .black)
            }
            .padding(.vertical, 16.0)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(20)
        }
    }
    
    private func getDaysInWeek() -> [DayDate] {
        return ["M", "T", "W", "T", "F", "S", "S"].map { DayDate(day: $0) }
    }
    
    private func fetchWorkoutForDay(_ day: String) -> Workout? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        return workouts.first { workout in
            guard let workoutDate = workout.date else {
                return false
            }
            let workoutDay = dateFormatter.string(from: workoutDate)
            return workoutDay == day
        }
    }
}

struct CircleView: View {
    @Environment(\.colorScheme) var colorScheme
    var day: String
    var done: Bool
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(day)
                .font(.subheadline)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .frame(maxWidth: 40)
                    .foregroundColor(isSelected ? .blue : (done ? .black : .white))
                
                if done {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
    
    struct WorkoutDetailView: View {
        var workout: Workout
        
        var body: some View {
            VStack {
                Text("Workouts for \(workout.date!, style: .date)")
                    .font(.title)
                
                Text("Workout: \(workout.name ?? "")")
                Text("Duration: \(workout.duration) minutes")
                Text("Description: \(workout.describe ?? "")")
            }
        }
    }
    

