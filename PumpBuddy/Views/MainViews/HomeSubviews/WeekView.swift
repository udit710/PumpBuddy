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
    @State private var shouldReloadView = false // New state variable for reloading
    @State private var currentDate = Date()
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
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
                    
                    // adapted from https://sarunw.com/posts/swiftui-button-disable/
                    if workoutForDay != nil {
                        CircleView(day: day, done: true, isSelected: selectedDay == day)
                    } else {
                        // adapted from https://sarunw.com/posts/swiftui-button-disable/
                        CircleView(day: day, done: false, isSelected: selectedDay == day)
                    }
                }
            }
            .foregroundColor(colorScheme == .light ? .white : .black)
        }
        .padding(.vertical, 16.0)
        .frame(maxWidth: .infinity)
        .background(Color("AppColor"))
        .cornerRadius(20)
        .onReceive(timer) { _ in
            let calendar = Calendar.current
            let currentDate = Date()

            if let nextMonday = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: 2), matchingPolicy: .nextTime, direction: .forward) {
                if calendar.isDate(currentDate, equalTo: nextMonday, toGranularity: .day) {
                    DispatchQueue.main.async {
                        shouldReloadView.toggle()
                    }
                }
            }
        }


        .onAppear {
        }
        .id(shouldReloadView)
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
    
struct WorkoutDetailView2: View {
    var workout: Workout

    var body: some View {
        Form {
            Section(header: Text("Workout Details")) {
                HStack {
                    Text("Date:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(workout.date!, style: .date)")
                }

                HStack {
                    Text("Name:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(workout.name ?? "")
                }

                HStack {
                    Text("Duration:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(workout.duration) minutes")
                }

                HStack {
                    Text("Description:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(workout.describe ?? "")
                }
            }
        }
        .navigationBarTitle("Workout Details", displayMode: .inline)
    }
}

    
