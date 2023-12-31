//
//  CustomWorkoutView.swift
//  PumpBuddy
//
//  Created by Chaitanya Bhide on 23/8/2023.
//
import SwiftUI

/// Page to log a wokout that is currently in session
struct CustomWorkoutView: View {
    ///Environment variable to get background mode
    @Environment(\.colorScheme) var colorScheme

    ///Environment variable for CoreData
    @Environment(\.managedObjectContext) var moc
    
    ///Fetch ``Workout`` data from CoreData
    @FetchRequest(entity: Workout.entity(), sortDescriptors: []) var works: FetchedResults<Workout>
    
    ///Title of the workout
    @State var workoutTitle: String = ""
    
    /// Any Notes for the workout
    @State var workoutNotes: String = ""
    
    ///Start time of the workout
    @State private var startTime: Date?
    
    ///End time of the workout
    @State private var endTime: Date?
    
    ///Duration of the workout
    @State private var timeInterval: Double?
    
    ///Variable to make the workout favourite
    @State private var isFavourite: Bool = false
    
    /// Timer to update duration on view
    /// Adapted from ``// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui``
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    ///State variable to check if workout is added
    @State var isWorkoutAdded = false
    
    /// Alert variables for different scenarios
    @State private var alert1 = false
    @State private var alert2 = false
    @State private var alert3 = false
    @State private var alert4 = false
    
    ///State variable to enable re-ordering of exercises
    @State private var reOrder = false

    ///Variable to store default units set by user
    @AppStorage("defaultUnits") var selectedUnit: units = .kg
    
    /// Array to temporarily store ``ExercisePerformed`` type variables
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
                                .padding()
                            Spacer()
                            Image(systemName: !isFavourite ? "heart" : "heart.fill")
                                .onTapGesture {
                                    isFavourite.toggle()
                                }
                        }
                    }
                    if exe.count > 0{
                        HStack{
                            Text("Exercises")
                                .bold()
                            Spacer()
                            Image(systemName: "arrow.up.arrow.down")
                                .onTapGesture{
                                    reOrder.toggle()
                                }
                        }
                        .padding(.horizontal)
                        Divider()
                            ForEach(Array($exe.enumerated()), id: \.element.id) { index, e in
                                VStack {
                                    if e.id != nil {
                                        HStack{
                                            Spacer()
                                            Image(systemName: "x.circle")
                                                .onTapGesture {
                                                    deleteExercise(e)
                                                }
                                                .foregroundColor(.red)
                                        }
                                        ShowExercise(exercise: e)
                                    }
                                }
                                .padding(.horizontal)
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
                            if !(isWorkoutAdded || !exe.allSatisfy { $0.isDone } || exe.count == 0 || workoutTitle.isEmpty){
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
                                newWorkout.units = selectedUnit.description
                                
                                try? moc.save()
                                isWorkoutAdded = true
                            } else if isWorkoutAdded{
                                alert1 = true
                            }else if !exe.allSatisfy({ $0.isDone }){
                                alert2 = true
                            }else if exe.count == 0{
                                alert3 = true
                            }else if workoutTitle.isEmpty{
                                alert4 = true
                            }
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
                        .alert("Workout already added!", isPresented: $alert1){
                            Button("OK", role: .cancel) {}
                        }.alert("One or more exercises are left", isPresented: $alert2){
                            Text("Click the Done button next to exercise name to add exercise")
                            Button("OK", role: .cancel) {}
                        }.alert("No exercises added!", isPresented: $alert3){
                            Text("Click on the Add Exercises button")
                            Button("OK", role: .cancel) {}
                        }.alert("Workout title empty!", isPresented: $alert4){
                            Button("OK", role: .cancel) {}
                        }
                    }
                }
                .toolbarBackground(
                    Color("AppColor"),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }

        }
        .popover(isPresented: $reOrder){
            ReOrderExercise(exe: $exe)
        }
    }
    
    
    struct CustomWorkoutView_Previews: PreviewProvider {
        static var previews: some View {
            CustomWorkoutView()
        }
    }
    
    /// Function to remove an added exercise from workout
    func deleteExercise(_ exercise: Binding<ExercisePerformed>) {
        if let index = exe.firstIndex(where: { $0.id == exercise.id }) {
            exe.remove(at: index)
        }
    }
    
    
}

/// View to re-order the exercises
struct ReOrderExercise: View {
    /// Binding Array of exercises performed
    @Binding var exe: [ExercisePerformed]
    
    var body: some View{
        NavigationStack{
            List{
                ForEach(exe){e in
                    Text(e.exercise?.name ?? "Exercise")
                }
                .onMove{ (indexSet, index) in
                    self.exe.move(fromOffsets: indexSet, toOffset: index)
                }
            }
            .navigationTitle("Exercises")
            .toolbar{
                EditButton()
            }
        }
        
    }
}


/// View to display each exercise
struct ShowExercise: View{
    /// ``ExercisePerformed`` variable
    @Binding var exercise : ExercisePerformed
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    /// Header for weight field
    @State var weightHeader = ""
    /// Header for reps field
    @State var repsHeader = ""
    
    ///State var to show ``ExerciseDetailsView``
    @State var popUp = false
    
    /// Variable to edit ``ExercisePerformed/sets``
    @State var edit: Bool = false
    
    /// Variables to show alerts for different situations
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    
    /// Array to store sets performed
    @State var sets : [Set] = []

    /// Refer to ``CustomWorkoutView/selectedUnit``
    @AppStorage("defaultUnits") var selectedUnit: units = .kg

    var body: some View{
        VStack(alignment: .leading) {
            HStack{
                Text(exercise.exercise?.name ?? "Exercise")
                    .bold()
                
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
                Button(exercise.isDone ? "Added!" : "Done") {
                    if sets.count == 0 {
                        showAlert1 = true
                    } else if !(sets.allSatisfy({ $0.isDone })) {
                        showAlert2 = true
                    } else if exercise.isDone {
                        showAlert3 = true
                    }
                    else{
                        let setsArray: NSSet = NSSet(array: sets)
                        exercise.sets = setsArray
                        
                        try? moc.save()
                        
                        exercise.isDone = true
                    }
                    
                }
                .alert("No sets added!", isPresented: $showAlert1){
                    Button("OK", role: .cancel) {}
                }
                .alert("All sets are not complete yet!", isPresented: $showAlert2){
                    Button("OK", role: .cancel) {}
                }
                .alert("Exercise already added!", isPresented: $showAlert3){
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .cornerRadius(10)
            
            Section{
                HStack{
                    Text("#")
                    Divider()
                    TextField("Weight (\(selectedUnit.description))", text: $weightHeader)
                        .disabled(true)
                    Divider()
                    TextField("Reps", text: $repsHeader)
                        .disabled(true)
                    Button{
                        edit.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(colorScheme == .dark ? .white : .black)
                )
            }
                        if sets.count > 0{

                            ForEach((0...sets.count-1), id:\.self){i in
                                Section{
                                    HStack{
                                        AddSetView(set: $sets[i],index: i, edit: $edit)
                                        if edit{
                                            Button{
                                                deleteSet(at: i)
                                            } label: {
                                                Image(systemName: "minus.circle")
                                                    .foregroundColor(.red)
                                            }
                                        } else {
                                            Button{
                                                sets[i].isDone.toggle()
                                                    hideKeyboard()
                                            } label: {
                                                Image(systemName: sets[i].isDone ? "checkmark.circle.fill" : "checkmark.circle")
                                            }
                                            .disabled(sets[i].reps == 0)
                                        }
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(colorScheme == .dark ? .white : .black)
                                    )
                                }
                                .background(sets[i].isDone ? .green.opacity(50) : .gray.opacity(0))
                                .cornerRadius(20)
                            }
            
        }
        
        HStack {
            Spacer()
            Button("Add Set"){
                let newSet = Set(context: moc)
                sets.append(newSet)
                
//                try? moc.save()
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
                .onAppear{
                    sets = (exercise.sets?.allObjects as? [Set]) ?? []
                }
            }
        
            func deleteSet(at index: Int) {
                sets.remove(at: index)
            }
        
    }


/// View for each ``Set``
struct AddSetView: View{
    
    /// ``Set`` Variable
    @Binding var set : Set
    
    /// Index of the set
    var index: Int
    
    /// Variable to edit set
    @Binding var edit: Bool

    /// Formatter to format the weight entered by user
    let weightFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1 // Adjust as needed
            return formatter
        }()
    
    /// Formatter to format the number of reps entered by user
    let repsFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            return formatter
        }()

    var body: some View{

        VStack{
            HStack {
                Text("\(index+1).")
                    .bold()
                Divider()
                TextField("weight",value: $set.weight, formatter: weightFormatter )
                    .keyboardType(.decimalPad)
                    .disabled(edit)
                    .bold()
                Divider()
                TextField("reps",value: $set.reps, formatter: repsFormatter )
                    .keyboardType(.decimalPad)
                    .disabled(edit)
                    .bold()
            }
        }
    }
}


#if canImport(UIKit)
extension View {
    /// Function to disable keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
