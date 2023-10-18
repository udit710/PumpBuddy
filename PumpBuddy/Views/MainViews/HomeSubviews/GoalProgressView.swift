//
//  GoalProgressView.swift
//  PumpBuddy
//
//  Created by udit on 18/10/23.
//

import SwiftUI
import Charts

struct GoalProgressView: View {
    @State private var weightUpdates: [WeightUpdate] = []
    @AppStorage("defaultUnits") var selectedUnit: units = .kg
    @State private var selectedDate: Date?

    func updateEntries(weightUpdate: [WeightUpdate]) -> [WeightUpdate]{
        var newUpdates = weightUpdate
        for (index, var update) in newUpdates.enumerated() {
            if update.units != selectedUnit.description {
                let (x,y) = convertWeight(weight: update.weight, unit: update.units)
                update = WeightUpdate(weight: x, date: update.date, units: y)
                newUpdates[index] = update
            }
        }
        
        var idx = 0
        while idx < newUpdates.count - 1 {
            if newUpdates[idx].weight == newUpdates[idx + 1].weight {
                newUpdates.remove(at: idx) // Remove one of the duplicate values
            } else {
                idx += 1
            }
        }
        return newUpdates
    }
    
    var body: some View {
        VStack{
            if weightUpdates.isEmpty{
                Text("No entries yet...")
            }
            else{
                Chart{
                    
                    ForEach(weightUpdates, id: \.self){ element in
                        LineMark(
                            x: .value("Date", element.date),
                            y: .value("Weight", element.weight)
                        )
                        PointMark(
                            x: .value("Date", element.date),
                            y: .value("Weight", element.weight)
                        )
                    }
                }
                .chartXAxisLabel("Dates")
                .chartXAxis {
                    AxisMarks()
                }
                .chartYAxisLabel("Weight(in \(selectedUnit.description))")
                .chartYAxis {
                    if selectedUnit == .kg{
                        AxisMarks(values: .init(arrayLiteral: 50, 100, 150, 200, 250))
                    } else{
                        AxisMarks(values: .init(arrayLiteral: 50, 100, 150, 200, 250, 300, 350))

                    }
                }
                .padding(.horizontal)
                .frame(height: 200)
            }
        }
        .onAppear{
            weightUpdates = loadPlist()
            weightUpdates = updateEntries(weightUpdate: weightUpdates)
            saveToPlist(weightUpdates: weightUpdates)
        }
        .padding(.vertical)
        .border(.black)
        .padding(.horizontal)
    }
}

struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        GoalProgressView()
    }
}
