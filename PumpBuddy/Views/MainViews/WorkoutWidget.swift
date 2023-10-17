//
//  WorkoutWidget.swift
//  PumpBuddy
//
//  Created by Chaitanya Bhide on 17/10/2023.
//


//Refrencing https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension/ and https://designcode.io/swiftui-handbook-create-a-widget. Adapted to try and fit our code


import SwiftUI
import WidgetKit
import CoreData


struct WorkoutWidget: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .date)
                .font(.headline)
                .padding()

            CircleViewWidget(day: entry.day, done: entry.workoutDone)
        }
    }
}

                 
                 

struct CircleViewWidget: View {
    var day: String
    var done: Bool

    var body: some View {
        VStack {
            Text(day)
                .font(.subheadline)
                .fontWeight(.bold)

            ZStack {
                Circle()
                    .frame(maxWidth: 40)
                    .foregroundColor(done ? .black : .white)

                if done {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct WorkoutWidget_Previews: PreviewProvider {
    static var previews: some View {
        let previewDate = Date()
        return WorkoutWidget(entry: Provider.Entry(date: previewDate, day: "Mon", workoutDone: true))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), day: "M", workoutDone: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), day: "M", workoutDone: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let startDate = Calendar.current.startOfDay(for: currentDate)
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!

        let workouts = fetchWorkoutsBetweenDates(startDate, and: endDate)
        let timelineEntries = workouts.map { workout in
            SimpleEntry(date: workout.date ?? startDate, day: dayString(from: workout.date), workoutDone: true)
        }

        let timeline = Timeline(entries: timelineEntries, policy: .atEnd)
        completion(timeline)
    }

    private func fetchWorkoutsBetweenDates(_ startDate: Date, and endDate: Date) -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        let context = PersistenceController.shared.container.viewContext

        request.predicate = NSPredicate(format: "date != nil AND date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching workouts: \(error.localizedDescription)")
            return []
        }
    }

    private func dayString(from date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let day: String
    let workoutDone: Bool
}
