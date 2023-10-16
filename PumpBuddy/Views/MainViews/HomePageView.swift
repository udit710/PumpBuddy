//
//  HomePageView.swift
//  PumpBuddy
//
//  Created by udit on 14/08/23.
//

import SwiftUI

struct HomePageView: View {
        @Environment(\.colorScheme) var colorScheme
    //Access login status from app storage
        @AppStorage("loggendIn") var loggedIn: Bool = false
    //Show the 3 different views in tabs
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home",systemImage: "house")
                }
            WorkoutTabView()
                .tabItem{
                    Label("Workout",systemImage:"dumbbell")
                }
            AccountTabView()
                .tabItem{
                    Label("Account",systemImage:"person.circle.fill")
                }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


struct HomeView: View{
    @Environment(\.colorScheme) var colorScheme
    //Once again access app storage and check username and loggedin
    @AppStorage("username") var username: String?
    @AppStorage("loggendIn") var loggedIn: Bool = false
    var body: some View {
        NavigationStack{ //Custom navigationview
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Hi \(username ?? "")!")
                            .bold()
                            .padding([.top, .leading, .trailing])
                            .font(.title)
                        Spacer()
                    }
                    WeekView() //Display weekview
                        .padding(.horizontal)
                    HStack{
                        WorkoutsBriefView() //Display workoutsbriefview
                            .padding(.leading)
                            .frame(height: 200)
                            
                        NavigationLink{
                            WorkoutHistoryView()//Navigate to workouthistory page
                        }label:{
                            recentWorkouts()
                                .background(colorScheme == .dark ? .white : .black)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .cornerRadius(20)
                                .padding(.trailing)
                                .frame(minHeight: 200)
                        }
                    }
                    
                    HStack {
                        Text("Explore")
                            .font(.largeTitle)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        //Navigate to explorepageview
                        NavigationLink{
                            ExplorePageView()
                        }label: {
                            //Display link to exploremore with more
                            Text("more...")
                                .underline()
                                .padding(.trailing)
                        }
                        
                    }
                    
                    ExploreOverview()
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        
                        HStack {
                            Image("PumpBuddy-light")
                                .resizable()
                                .frame(width: 40,height: 40)
                                .scaleEffect(x: -1, y: 1)
                            Text("PumpBuddy")
                                .bold()
                                .font(.title)
                            Image("PumpBuddy-light")
                                .resizable()
                                .frame(width: 40,height: 40)
                        }
                        .padding(.bottom, 5.0)
                        
                    }
                }
                //custom navigation bar background
                .toolbarBackground(
                    Color("AppColor"),
                    for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}
