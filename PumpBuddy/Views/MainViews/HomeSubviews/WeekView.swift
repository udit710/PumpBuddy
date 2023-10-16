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
//        NavigationView {
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
//                            NavigationLink(
//                                destination: WorkoutDetailView(workout: workoutForDay!),
//                                isActive: Binding(
//                                    get: { selectedDay == day },
//                                    set: { _ in selectedDay = nil }
//                                ) // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
//                            ) {
                                CircleView(day: day, done: true, isSelected: selectedDay == day)
//                                    .onTapGesture {
//                                        selectedDay = day
//                                    } // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
//                            }
                        } else {
                            CircleView(day: day, done: false, isSelected: selectedDay == day)
//                                .opacity(0.5) // adapted from https://sarunw.com/posts/swiftui-button-disable/ and also used ChatGPT to help modify
                        }
                    }
                }
                .foregroundColor(colorScheme == .light ? .white : .black)
            }
            .padding(.vertical, 16.0)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(20)
//        }
    }
    
    private func getDaysInWeek() -> [DayDate] {
        return ["M", "Tu", "W", "Th", "F", "Sa", "Su"].map { DayDate(day: $0) }
    }
    
    
    private func fetchWorkoutForDay(_ day: String) -> Workout? {
        return workouts.first { workout in
            guard let date = workout.date else {
                return false
            }
            
            //In reference and adapted from https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
            let workoutDay = Calendar.current.component(.weekday, from: date)
            let selectedDayNumber = getDayNumber(day: day)
            //In reference and adapted from https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
            return workoutDay == selectedDayNumber
        }
    }

    private func getDayNumber(day: String) -> Int {
        switch day {
        case "M": return 2
        case "Tu": return 3
        case "W": return 4
        case "Th": return 5
        case "F": return 6
        case "Sa": return 7
        case "Su": return 1
        default: return 0
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
    


    
