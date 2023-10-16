//
//  SearchExercises.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view allows user to search and add workouts
struct SearchExercises: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme

    @State var tempEx: [ExerciseModel] = []

    @State var jsonObj = JsonModel()

    @State var searchText = ""
    @State var exercises: [Exercise] = []
//    @FetchRequest(entity: Exercise.entity(), sortDescriptors: []) var exercises: FetchedResults<Exercise>
    
    @Binding var exercisesAdded : [ExercisePerformed]
    @State var dataNeeded: String = ""
    @State var dataFor: String = ""
    let dataReq = [
        "muscle",
        "type",
        "difficulty"
    ]
    let difficulty = [
        "beginner",
        "intermediate",
        "expert"
    ]
    let types = [
        "cardio",
        "olympic_weightlifting",
        "plyometrics",
        "powerlifting",
        "strength",
        "stretching",
        "strongman"
    ]
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
    
    @State var DATAHERE: String = "Not here"

    @State var isDataLoaded: Bool = false

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
//                ToolbarItem(placement: .navigationBarLeading){
                    Picker("Search By", selection: $dataNeeded){
                        Text("Search By")
                        ForEach(dataReq, id: \.self){
                            Text($0.localizedCapitalized)
                        }
                    }
                    .background(Color("AppColor"))
                    .cornerRadius(20)
//                }
//                ToolbarItem(placement: .navigationBarTrailing){
//                    Menu {
                        if dataNeeded == "muscle"{
                            Picker("Muscle", selection: $dataFor){
    //                            Text("Select")
                                ForEach(muscleGroups, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        }else if dataNeeded == "type"{
                            Picker("Type", selection: $dataFor){
    //                            Text("Select")
                                ForEach(types, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        } else if dataNeeded == "difficulty" {
                            Picker("Difficulty", selection: $dataFor){
    //                            Text("Select")
                                ForEach(difficulty, id: \.self){
                                    Text($0.localizedCapitalized)
                                }
                            }
                            .background(.red)
                            .cornerRadius(20)
                        }
                //                    } label: {
                //                        Label("Select \(dataNeeded)", systemImage: "list.bullet")
                //                    }
                //                }
            } label: {
                Label("more", systemImage: "ellipsis.circle")
            }
        }
        .onAppear{
            //            tempEx = jsonObj.fetchData(dataNeeded: dataNeeded, dataFor: dataFor, context: moc)
            //            exercises = jsonObj.showData(data: tempEx, context: moc)
            isDataLoaded = true
        }
        .onChange(of: dataFor) { _ in
            // This will set isDataLoaded to true whenever exercises change
            
            if !dataFor.isEmpty{
                Task{
                    do{
                        tempEx = try await jsonObj.fetchData(dataNeeded: dataNeeded, dataFor: dataFor, context: moc)
                        exercises = jsonObj.showData(data: tempEx, context: moc)
                        DATAHERE = "Data is here"
                    } catch {
                        print("Error while fetching data")
                    }
                }
            }
        }
    }
    
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


struct ExerciseCard: View {
    var ex: Exercise
    @Binding var exercisesAdded : [ExercisePerformed]
    var tempExercises : [ExercisePerformed] = []
    var appendExercise: (Exercise) -> Void
    var deleteExercise: (Exercise) -> Void
    
    @State var clicked: Bool = false
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


struct ProcessView: View{
    var text: String
    var body: some View{
        Text(text)
    }
}
