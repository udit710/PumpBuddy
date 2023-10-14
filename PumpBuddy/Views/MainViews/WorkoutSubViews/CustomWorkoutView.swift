//
//  CustomWorkoutView.swift
//  PumpBuddy
//
//  Created by Chaitanya Bhide on 23/8/2023.
//
import SwiftUI

//View to add a workout
struct CustomWorkoutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Workout.entity(), sortDescriptors: []) var works: FetchedResults<Workout>
    
    @State var workoutTitle: String = ""
    @State var workoutNotes: String = ""
    
    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var timeInterval: Double?
    
    @State private var isFavourite: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    
    @State var isWorkoutAdded = false
    
    
    // Array to temporarily store exercises performed
    @State var exe : [ExercisePerformed] = []
    
    
    var body: some View {
        
        
        
        NavigationStack{
            ScrollView{
                VStack {
                    Divider()

                    
                    VStack{
                        TextField("Workout Name", text: $workoutTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        Divider()
                        TextField("Notes", text: $workoutNotes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        Divider()
                        
                        HStack{
                            Text("Duration: \(Int(timeInterval ?? 0)/60) mins \(Int(timeInterval ?? 60)%60) secs")
                                .onReceive(timer){_ in
                                    if !isWorkoutAdded{
                                        self.endTime = Date()
                                        timeInterval = endTime?.timeIntervalSince(startTime ?? Date())
                                    }
                                }
                            Spacer()
                            Image(systemName: !isFavourite ? "heart" : "heart.fill")
                                .onTapGesture {
                                    isFavourite.toggle()
                                }
                        }
                    }
                    if exe.count > 0{
                        Text("Exercises")
                            .bold()
                            ForEach(Array($exe.enumerated()), id: \.element.id) { index, e in
                                HStack {
                                    if e.id != nil {
                                        ShowExercise(exercise: e)
                                        Image(systemName: "x.circle")
                                            .onTapGesture {
                                                deleteExercise(e)
                                            }
                                    }
                                }
                            }
                    }

                    Spacer()
                    Spacer()
                    NavigationLink{
                        SearchExercises(exercisesAdded: $exe)
                    }label: {
                        HStack {
                            Text("Add Exercise")
                                .frame(width: 100, height: 25)
                                .background(Color("Pink"))
                                .cornerRadius(10)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .font(.system(size: 13))
                                .bold()
                                .padding(.leading)
                        }

                    }

                    if isWorkoutAdded {
                        Text("Workout Added!")
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    }
                }

                .navigationTitle("Workout")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    if (self.startTime == nil){
                        self.startTime = Date()
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            self.endTime = Date()
                            let newWorkout = Workout(context: moc)
                            newWorkout.name = workoutTitle
                            let sortedSets = exe.filter { $0.sets?.count ?? 0 > 0 }
                            newWorkout.exercises = NSSet(array: sortedSets)
                            newWorkout.id = UUID()
                            newWorkout.duration = Int64(timeInterval ?? 0)/60
                            newWorkout.date = Date()
                            newWorkout.isFavourite = isFavourite
                            newWorkout.describe = workoutNotes

                            try? moc.save()
                            isWorkoutAdded = true
                        }) {
                            Text("Add Workout")
                                .frame(width: 100, height: 25)
                                .background(colorScheme == .dark ? .white : .black)
                                .cornerRadius(10)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .font(.system(size: 13))
                                .bold()
                                .padding(.leading, 5.0)
                        }
                        .disabled(isWorkoutAdded)
                    }
                }
                .toolbarBackground(
                    Color("AppColor"),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    
    struct CustomWorkoutView_Previews: PreviewProvider {
        static var previews: some View {
            CustomWorkoutView()
        }
    }
    
    func deleteExercise(_ exercise: Binding<ExercisePerformed>) {
        if let index = exe.firstIndex(where: { $0.id == exercise.id }) {
            exe.remove(at: index)
//            moc.delete(exe[index])
        }
    }
    
    func calculateDuration() -> String {
            if let appearanceTime = startTime, let saveTime = endTime {
                let duration = saveTime.timeIntervalSince(appearanceTime)
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            return "N/A"
        }

    
}

struct ShowExercise: View{
    @Binding var exercise : ExercisePerformed
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State var popUp = false



    @State var sets : [Set] = []

    var body: some View{
        VStack(alignment: .leading) {
            HStack{
                Text(exercise.exercise?.name ?? "Exercise")
                    .font(.largeTitle)
                    .bold()
                
                Text("Weight")
                
                VStack{
                    Button{
                        popUp = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $popUp){
                        ExerciseDetailsView(exercise: exercise.exercise ?? Exercise())
                    }
                    Spacer()
                }
                Spacer()
                Button("Done"){
                    let setsArray: NSSet = NSSet(array: sets)
                    exercise.sets = setsArray
                    
                    try? moc.save()
                }
                .disabled(sets.count == 0)
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(10)
            

            if sets.count > 0{
                ForEach((0...sets.count-1), id:\.self){i in
                    Section{
                        AddSetView(set: $sets[i],index: i)
                        Button("x"){
                            deleteExercise($sets[i])
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button("add set +"){
                    let newSet = Set(context: moc)
                    sets.append(newSet)
                }
                .frame(width: 100, height: 25)
                .background(Color("Pink"))
                .cornerRadius(10)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .font(.system(size: 13))
                .bold()
                .padding(.leading)
                Spacer()
            }
            
        }
        
    }
    
    func deleteExercise(_ exercise: Binding<Set>) {
        if let index = sets.firstIndex(where: { $0.id == exercise.id }) {
            sets.remove(at: index)
//            moc.delete(exe[index])
        }
    }
}

struct AddSetView: View{
    @Binding var set : Set
    var index: Int
    
    let weightFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1 // Adjust as needed
            return formatter
        }()
    
    var body: some View{
        
        HStack {
            Text("\(index+1).")
            Divider()
            Spacer()
            TextField("weight",value: $set.weight, formatter: weightFormatter ).keyboardType(.decimalPad)
                
        }
    }
}
