//
//  WorkoutWidget.swift
//  WorkoutWidget
//
//  Created by udit on 18/10/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

enum units: String,CustomStringConvertible, CaseIterable, Encodable, Decodable{
    case kg = "kg"
    case lbs = "lbs"
    
    var description: String {
        return self.rawValue
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "kg":
            self = .kg
        case "lbs":
            self = .lbs
        default:
            return nil
        }
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
}

struct WorkoutWidgetEntryView : View {
    var entry: Provider.Entry
    let encodedCurrWeight = UserDefaults(suiteName: "group.com.Udit.PumpBuddy")?.object(forKey: "currentWeight") as? Data
    let encodedGoalWeight = UserDefaults(suiteName: "group.com.Udit.PumpBuddy")?.object(forKey: "goalWeight") as? Data
    let encodedUnits = UserDefaults(suiteName: "group.com.Udit.PumpBuddy")?.object(forKey: "defaultUnits") as? Data

        
    var body: some View {
        VStack{


            if let currWeight = encodedCurrWeight, let goalWeight = encodedGoalWeight, let unitWeight = encodedUnits {
                if let currDecoded = try? JSONDecoder().decode(Double.self, from: currWeight),
                   let goalDecoded = try? JSONDecoder().decode(Double.self, from: goalWeight),
                   let unitDecoded = try? JSONDecoder().decode(units.self, from: unitWeight){
                 let curr = String(format: "%.2f", currDecoded)
                    let goal = String(format: "%.2f", goalDecoded)
                    let unit = unitDecoded
                    // You successfully retrieved your car object!
                    VStack{
                        HStack{
                            Image(systemName: "dumbbell")
                            Text("Current weight: \(curr)\(unit.description)")
                            Image(systemName: "dumbbell")
                        }
                        Divider()
                                    if goalDecoded < currDecoded {
                                        let difference = String(format: "%.2f", currDecoded - goalDecoded)
                                        Text("You need to lose \(difference)\(unit.description) to achieve your goal weight of \(goal)\(unit.description)")
                                    } else if goalDecoded > currDecoded {
                                        let difference = String(format: "%.2f", goalDecoded - currDecoded)
                                        Text("You need to gain \(difference)\(unit.description) to achieve your goal weight of \(goal)\(unit.description)")
                                    } else {
                                        Text("Bravo! You are at your goal weight of \(goal)\(unit.description)")
                                    }
                    }
                    .padding()
                }
            }
        }
    }
}

struct WorkoutWidget: Widget {
    let kind: String = "WorkoutWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WorkoutWidgetEntryView(entry: entry)
                
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct WorkoutWidget_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
