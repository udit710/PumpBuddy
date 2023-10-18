//
//  SearchExercises.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view allows user to search and add workouts
struct SearchExercises: View {
    
    /// Environment variable for CoreData operations
    @Environment(\.managedObjectContext) var moc
    
    /// Environment variable to get background mode
    @Environment(\.colorScheme) var colorScheme

    /// An array of exercises to parse **JSON** data received from **API** call
    @State var tempEx: [ExerciseModel] = []

    /// A ``JsonModel`` object to fetch API data
    @State var jsonObj = JsonModel()

    /// Text entered in search bar
    @State var searchText = ""
    
    /// An array of parsed ``Exercise`` objects
    @State var exercises: [Exercise] = []
    
    /// A **Binding** array of ``ExercisePerformed`` objects to add to workout
    @Binding var exercisesAdded : [ExercisePerformed]
    
    /// A variable to filter the type of search for exercises
    /// In this context, search results can be based on **Muscle Groups**, ** Type** or **Difficulty** of exercise
    @State var dataNeeded: String = ""
    
    /// The parameter based on ``dataNeeded``
    /// Example, for Muscle, ``dataFor`` can be *Biceps*
    @State var dataFor: String = ""
    
    /// The options that can be used for ``dataNeeded``
    let dataReq = [
        "muscle",
        "type",
        "difficulty"
    ]
    
    /// Types of difficulties
    let difficulty = [
        "beginner",
        "intermediate",
        "expert"
    ]
    
    /// Types of exercise types
    let types = [
        "cardio",
        "olympic_weightlifting",
        "plyometrics",
        "powerlifting",
        "strength",
        "stretching",
        "strongman"
    ]
    
    /// Types of Muscle Groups
    let muscleGroups = [
        "abdominals",
        "abductors",
        "adductors",
        "biceps",
        "calves",
        "chest",
        "forearms",
        "glutes",
        "hamstrings",
        "lats",
        "lower_back",
        "middle_back",
        "neck",
        "quadriceps",
        "traps",
        "triceps"
    ]

    /// State variable to check if data is loaded
    @State var isDataLoaded: Bool = false

    /// A filtered list for matching search results
    var filteredExercises: [Exercise]{
        guard !searchText.isEmpty else { return exercises}
        return exercises.filter{$0.name!.localizedCaseInsensitiveContains(searchText)}
    }

    var body: some View {
        VStack{
            
            if exercises.isEmpty{
                ProcessView(text: dataFor.isEmpty ? "Select \(dataNeeded)" : "Loading...")
            } else {
                List(filteredExercises){ex in
                    ExerciseCard(ex: ex, exercisesAdded: $exercisesAdded, appendExercise: appendExercise, deleteExercise: deleteExercise)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Exercises")
            }
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Menu{
                    Picker("Search By", selection: $dataNeeded){
                        Text("Search By")
                        ForEach(dataReq, id: \.self){
                            Text($0.localizedCapitalized)
                        }
                    }
                    .background(Color("AppColor"))
                    .cornerRadius(20)
                        if dataNeeded == "muscle"{
                            Picker("Muscle", selection: $dataFor){
                                ForEach(muscleGroups, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        }else if dataNeeded == "type"{
                            Picker("Type", selection: $dataFor){
                                ForEach(types, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        } else if dataNeeded == "difficulty" {
                            Picker("Difficulty", selection: $dataFor){
                                ForEach(difficulty, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        }
            } label: {
                Label("more", systemImage: "ellipsis.circle")
            }
        }
        .onAppear{
            isDataLoaded = true
        }
        .onChange(of: dataFor) { _ in
            
            if !dataFor.isEmpty{
                Task{
                    do{
                        tempEx = try await jsonObj.fetchData(dataNeeded: dataNeeded, dataFor: dataFor, context: moc)
                        exercises = jsonObj.showData(data: tempEx, context: moc)
                    } catch {
                        print("Error while fetching data")
                    }
                }
            }
        }
    }
    
    /// Function to add exercise to workout as an ``ExercisePerformed`` variable
    /// - Parameter ex: An ``Exercise`` variable that is to be added to the workout
    func appendExercise(ex: Exercise){
        let newEx = ExercisePerformed(context: moc)
        newEx.id = UUID()
        newEx.exercise = ex
        let thisSet: Set = Set(context: moc)
        thisSet.weight = 0
        thisSet.reps = 0
        newEx.sets = [thisSet]
        exercisesAdded.append(newEx)
    }
    
    
    /// Function to remove an added exercise on unselection in view
    /// - Parameter ex: exercise that is to be removed
    func deleteExercise(ex: Exercise){
        exercisesAdded.removeAll{ exercise in
            return exercise.exercise == ex
        }
    }
}

struct SearchExercises_Previews: PreviewProvider {
    static var previews: some View {
        SearchExercises(exercisesAdded: .constant([]), dataFor: "")
    }
}


/// Exercise card Displaying brief information about the exercise
struct ExerciseCard: View {
    
    /// Exercise variable
    var ex: Exercise
    
    /// Binding array of exercises added
    @Binding var exercisesAdded : [ExercisePerformed]
    
    /// Temporary array of ``Exercise`` objects to be converted to ``ExercisePerformed``
    var tempExercises : [ExercisePerformed] = []
    
    /// Refer to ``SearchExercises/appendExercise(ex:)``
    var appendExercise: (Exercise) -> Void
    
    /// Refer to ``SearchExercises/deleteExercise(ex:)``
    var deleteExercise: (Exercise) -> Void
    
    /// State variable to know if exercise is clicked on
    /// For addition to ``tempExercises``
    @State var clicked: Bool = false
    
    /// State variable to display exercise information in detail
    @State var popUp = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(ex.name ?? "exercise name")
                        .bold()
                        
                    Spacer()
                    Image(systemName: clicked ? "checkmark.circle.fill" : "checkmark.circle")
                        .onTapGesture {
                            clicked.toggle()
                            if clicked {
                                appendExercise(ex)
                            } else if !clicked{
                                deleteExercise(ex)
                            }
                        }
                }
                Spacer()
                
                HStack {
                    Text("\(ex.muscles?.localizedCapitalized ?? "none")")
                        .opacity(0.7)
                    Spacer()
                    Button{
                        popUp = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $popUp){
                        ExerciseDetailsView(exercise: ex)
                    }
                }
            }
            
            .padding()
            .background(clicked ? Color("Pink") : Color("AppColor"))
            .cornerRadius(15)
            .padding(clicked ? 5 : 0)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 10, leading: 10,bottom: 10, trailing: 10))
        
        
    }
    
    
}


/// View to be displayed while loading the exercises
struct ProcessView: View{
    var text: String
    var body: some View{
        Text(text)
    }
}
