//
//  WorkoutTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI


struct WorkoutTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    Text("Generate Workout")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    NavigationLink{
                        //Empty till GenerateWorkoutView created
                    } label: {
                        ZStack{
                            Text("Use Pump AI!")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Pink"))
                                .cornerRadius(20)
                        }
                    }
                    
                    Text("Create Workout")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    NavigationLink{
                        CustomWorkoutView()
                    } label: {
                        ZStack{
                            Text("Create Custom Workout")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Pink"))
                                .cornerRadius(20)
                        }
                    }

                    Text("Start Workout")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    NavigationLink{
                        //Empty till StartWorkoutView page created
                    } label: {
                        ZStack{
                            Text("Begin New Workout")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Pink"))
                                .cornerRadius(20)
                        }
                    }
                    
                    Text("My Workouts")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                    WorkoutBox(title: "Chest", excercises: ["Bench Press", "DB Fly", "Incline Bench"]){
                        BoxButton(label: "Start Workout"){
                            
                        }
                    }
                    
                    WorkoutBox(title: "Legs", excercises: ["Squats", "Leg Extension"]){
                        BoxButton(label: "Start Workout"){
                            
                        }
                    }
                }
                
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                Spacer()
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color("AppColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    struct WorkoutTabView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutTabView()
        }
    }
    
    //Header text for each section
    struct SectionHeader: View {
        var text: String
        
        var body: some View {
            Text(text)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
    
    //Button Structure for the page
    struct BoxButton: View{
        var label:String
        var action: () -> Void
        
        var body: some View {
            Button (action:action){
                Text(label)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Pink"))
                    .cornerRadius(20) //taken from https://www.appcoda.com/swiftui-buttons/ and adapted for our code
            }
        }
    }
    
    //Custom layout box for displaying user created workouts
    struct WorkoutBox<Content: View>: View{
        var title: String
        var excercises: [String]
        var content: () -> Content
        
        var body: some View{
            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .font(.headline)
                
                
                ForEach(excercises, id: \.self) {excerise in Text(excerise)
                }
                content()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        
    }
    
}
