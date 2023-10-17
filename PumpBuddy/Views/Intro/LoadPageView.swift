//
//  LoadPageView.swift
//  PumpBuddy
//
//  Created by udit on 11/08/23.
//

import SwiftUI

struct LoadPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating: Bool = false
    @State private var introTime: Bool = false
    @AppStorage("username") var username: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                if introTime {
                    if !loggedIn {
                        IntroPage1View()
                            .navigationBarHidden(true)
                    } else {
                        HomePageView()
                    }
                } else {
                    VStack {
                        Image(colorScheme == .dark ? "PumpBuddy-dark" : "PumpBuddy-light")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 190)
                        Text("PumpBuddy")
                            .bold()
                            .font(.title)
                    }
                    .onAppear {
                        withAnimation {
                            isAnimating = true
                        }
                    }
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                }
            }
            // Wait for 2 seconds and then show the screen
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.introTime = true
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style
    }
}

struct LoadPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadPageView()
    }
}
