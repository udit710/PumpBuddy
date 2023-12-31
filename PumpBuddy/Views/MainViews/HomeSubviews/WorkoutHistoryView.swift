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
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        //adapted from https://stackoverflow.com/questions/26883270/swift-sort-array-by-sort-descriptors
        //used to sort ascending
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default
)
    private var workouts: FetchedResults<Workout>
    
    func deleteWorkout(at offsets: IndexSet){
        for index in offsets {
            let workout = workouts[index]
            moc.delete(workout)
        }
        
        try? moc.save()
    }

    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack {

                List {
                    ForEach(workouts, id: \.id) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutCardView(workout: workout)
                        }
                    }
                    .onDelete(perform: deleteWorkout)
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
//        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 8)
    }
}

struct ExerciseDetailView: View {
    var exercise: ExercisePerformed
    @State private var popUp = false

    var body: some View {
        VStack{
            HStack {
                Text(exercise.exercise?.name ?? "")
                    .bold()
                    .font(.system(size: 20))
                Spacer()
                Text("(\(exercise.exercise?.muscles?.localizedCapitalized ?? ""))")
                Spacer()
                Button {
                    popUp = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .popover(isPresented: $popUp) {
                    ExerciseDetailsView(exercise: exercise.exercise ?? Exercise())
                }
            }
        }
        .padding()
        .background(Color("AppColor"))
        .cornerRadius(20)
    }
}

struct SetDetailView: View {
    var sets: [Set]
    @Environment(\.colorScheme) var colorScheme
    var units: String


    var body: some View {
        VStack{
            ForEach(sets.indices, id: \.self) { index in
                let weight = sets[index].weight
                let reps =
                sets[index].reps
                    VStack {
                        HStack {
                            Text("\(index + 1)")
                            Divider()
                            Text(String(format: "%.2f \(units)", weight))
                            Spacer()
                            Divider()
                            Text(String(reps))
                            Spacer()
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? .white : .black)
                    )
                }
            }
        }
    }


struct WorkoutDetailView: View {
    var workout: Workout
    @State var popUp = false
    @AppStorage("defaultUnits") var selectedUnit: units = .kg

    
    var body: some View {
        
        ScrollView{
            VStack{
//                Form {
                    Section {
                        Divider()
                        HStack {
                            Text("Date:")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(workout.date!, style: .date)")
                        }
                        .padding(.horizontal)
                        Divider()
                        HStack {
                            Text("Name:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(workout.name ?? "")
                        }
                        .padding(.horizontal)
                        Divider()
                        HStack {
                            Text("Duration:")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(workout.duration) minutes")
                        }
                        .padding(.horizontal)
                        Divider()
                        if workout.describe != "" {
                            HStack {
                                Text("Description:")
                                    .fontWeight(.bold)
                                Spacer()
                                Text(workout.describe ?? "")
                            }
                            .padding(.horizontal)
                            Divider()

                        }
                        Divider()
                    }
//                }.background(colorScheme == .dark ? .black : .white)
    //                ScrollView{
                        if let exerciseArray = workout.exercises?.allObjects as? [ExercisePerformed] {
                            ForEach(exerciseArray, id: \.self) { exercise in
                                VStack{
                                    HStack{
                                        ExerciseDetailView(exercise: exercise)
                                    }
//                                    .padding(.horizontal)
                                    if let sets = exercise.sets?.allObjects as? [Set] {
                                        SetDetailView(sets: sets, units: workout.units ?? "\(selectedUnit.description)")
                                    }
                                }
                                .padding(.horizontal)
                                .background(.opacity(0))
                            }
                        }
            }
        }
        .navigationBarTitle("Workout Details", displayMode: .inline)

    }
}


