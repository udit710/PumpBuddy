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

    @State private var searchText = ""
    @State var exercises: [Exercise] = []
//    @FetchRequest(entity: Exercise.entity(), sortDescriptors: []) var exercises: FetchedResults<Exercise>
    
    @Binding var exercisesAdded : [ExercisePerformed]
    @State var dataNeeded: String = "muscle"
    @State var dataFor: String = "biceps"
    @State var isDataLoaded: Bool = false

    var filteredExercises: [Exercise]{
        guard !searchText.isEmpty else { return Array(exercises)}
        return exercises.filter{$0.name!.localizedCaseInsensitiveContains(searchText)}
    }

    var body: some View {
        VStack{
//            if !exercises.isEmpty{
                List(filteredExercises){ex in
                    ExerciseCard(ex: ex, exercisesAdded: $exercisesAdded, appendExercise: appendExercise)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Exercises")
//            }
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            tempEx = jsonObj.fetchData(dataNeeded: dataNeeded, dataFor: dataFor, context: moc)
            exercises = jsonObj.showData(data: tempEx, context: moc)
            isDataLoaded = true
        }
        .onChange(of: exercises) { _ in
            // This will set isDataLoaded to true whenever exercises change
            isDataLoaded.toggle()
        }
    }
    
    func appendExercise(ex: Exercise){
        let newEx = ExercisePerformed(context: moc)
        newEx.id = UUID()
        newEx.exercise = ex
        newEx.sets = []
        exercisesAdded.append(newEx)
    }
}

struct SearchExercises_Previews: PreviewProvider {
    static var previews: some View {
        SearchExercises(exercisesAdded: .constant([]))
    }
}

struct ExerciseCard: View {
    var ex: Exercise
    @Binding var exercisesAdded : [ExercisePerformed]
    var tempExercises : [ExercisePerformed] = []
    var appendExercise: (Exercise) -> Void

    @State var clicked: Bool = false
    @State var popUp = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(ex.name ?? "exercise name")
                        .font(.largeTitle)
                    Spacer()

                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()

                            Button{
                                popUp = true
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .popover(isPresented: $popUp){
                                ExerciseDetailsView(exercise: ex)
                            }
                            
                            Spacer()
                            Image(systemName: clicked ? "checkmark.circle.fill" : "checkmark.circle")
                                .onTapGesture {
                                    clicked = true
                                    appendExercise(ex)
                                }
                        }
                        
                        Text("(\(ex.muscles ?? "none"))")
                            .bold()
                    }
                }
                Spacer()
                HStack {
                    Text(ex.type ?? "")
                    Spacer()
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
