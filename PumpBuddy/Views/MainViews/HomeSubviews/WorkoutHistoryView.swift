//
//  WorkoutHistoryView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//


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

    var body: some View {
        NavigationView {
            VStack {
//                NavigationLink(destination: Text("Add Workout")) {
//                    Image(systemName: "plus")
//                        .foregroundColor(.white)
//                        .padding()
//                }
//                .padding(.horizontal)

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

    var body: some View {
        VStack{
            ForEach(sets.indices, id: \.self) { index in
                if let weight = sets[index].weight, let reps = sets[index].reps {
                    VStack {
                        HStack {
                            Text("\(index + 1)")
                            Divider()
                            Text(String(format: "%.2f", weight))
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
}

struct WorkoutDetailView: View {
    var workout: Workout
    @State var popUp = false


    
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
                            ForEach(exerciseArray.reversed(), id: \.self) { exercise in
                                VStack{
                                    HStack{
                                        ExerciseDetailView(exercise: exercise)
                                    }
//                                    .padding(.horizontal)
                                    if let sets = exercise.sets?.allObjects as? [Set] {
                                        SetDetailView(sets: sets.reversed())
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

