//
//  SearchExercises.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view allows user to search and add workouts
struct SearchExercises: View {
    @State private var searchText = ""
    @State private var exercises = exerciseSampleData
    
    var filteredExercises: [Exercise]{
        guard !searchText.isEmpty else { return exercises}
        return exercises.filter{$0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    var body: some View {
        NavigationStack{
                List(filteredExercises, id:\.ID){ex in
                    ExerciseCard(ex: ex)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Exercises")
        }
        .navigationTitle("Exercises")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchExercises_Previews: PreviewProvider {
    static var previews: some View {
        SearchExercises()
    }
}

struct ExerciseCard: View {
    var ex: Exercise
    @State var clicked: Bool = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(ex.name)
                        .font(.largeTitle)
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Image(systemName: clicked ? "checkmark.circle.fill" : "checkmark.circle")
                        }
                        Text("(\(ex.muscleGroups[0].name.description.capitalized))")
                            .bold()
                    }
                }
                Spacer()
                HStack {
                    Text(ex.description ?? "")
                    Spacer()
                }
            }
            .onTapGesture {
                clicked.toggle()
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
