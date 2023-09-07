//
//  LoadPageView.swift
//  PumpBuddy
//
//  Created by udit on 11/08/23.
//

import SwiftUI

struct LoadPageView: View {
    @Environment(\.colorScheme) var colorScheme
    //Tracks whether to show intro
    @State private var isAnimating: Bool = false
    @State private var introTime: Bool = false
    //Access the username and loggedin storeed properties
    @AppStorage("username") var username: String = ""
    @AppStorage("loggendIn") var loggedIn: Bool = false
    
    var body: some View {
        ZStack {
            if introTime{
                //If user is not logged in app will show intropage
                if !loggedIn {
                    IntroPage1View()
                } else {
                    //Otherwise show homepage
                    HomePageView()
                }
            }else{
                //Show centre logo
                VStack {
                        Image(colorScheme == .dark ? "PumpBuddy-dark" : "PumpBuddy-light")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 190)
                        Text("PumpBuddy")
                            .bold()
                            .font(.title)
                    }
                    .onAppear{
                        withAnimation{
                            isAnimating = true
                        }
                    }
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
            }
        }
        //Wait for 2 seconds and then show screen
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                withAnimation{
                    self.introTime = true
                }
            }
        }
    }
}

struct LoadPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadPageView()
    }
}
