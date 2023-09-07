//
//  ExplorePageView.swift
//  PumpBuddy
//
//  Created by udit on 26/08/23.
//

import SwiftUI

//This view is a scroll view for exploring new workouts
struct ExplorePageView: View {
    var works = workoutSampleData
    @State var i: Int = 0
    var body: some View {
        VStack {
            List(workoutSampleData, id: \.ID){ workout in
                ExploreCard(title: workout.name,description: workout.description ?? "")
                
                
            }
        }
        .navigationTitle("Explore Workouts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color("AppColor"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct ExplorePageView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePageView()
    }
}

struct ExploreCard: View{
    var title : String
    var description : String
    var imageSet: [String] = ["Running-explore", "Weights-explore", "HIIT-explore"]
    var body: some View{
        VStack(alignment: .leading) {
            Image(imageSet.randomElement() ?? "Running-Explore")
                .resizable()
            .scaledToFit()
            Text(title)
                .font(.largeTitle)
                .bold()
            Text(description)
        }
        
    }
}
