//
//  IntroPage1View.swift
//  PumpBuddy
//
//  Created by udit on 07/08/23.
//

import SwiftUI

struct IntroPage1View: View {
    //To see selected page index and to see whether main content should be shown
    @State private var selected: Int = 0
    @State private var home: Bool = false
    
    //Function to go to next page or showing content
    func goNext() {
        withAnimation {
            //if on the last page show home page
            if selected == 2 {
                home = true
            }else{
                selected += 1 //or keep showing onboarding
            }
        }
    }
    
    var body: some View {
        if home { //if onboarding completed show main content
            SignUpPageView()
        }else{
            //Showcase onboarding pages using tabview
            TabView(selection: $selected) {
                OnBoardingPageView(imageName: "figure.strengthtraining.traditional", descriptive: "Are you ready to take your fitness to the next level?",doneButton: false,nextAction: goNext)
                    .tag(0)
                OnBoardingPageView(imageName: "figure.run", descriptive: "Something new\nJust for You",doneButton: false,nextAction: goNext)
                    .tag(1)
                OnBoardingPageView(imageName: "figure.mixed.cardio", descriptive: "Your Journey to Greatness Starts Here.",doneButton: true,nextAction: goNext)
                    .tag(2)
            }
            //Custom tabview modifier
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct IntroPage1View_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage1View()
    }
}

struct OnBoardingPageView: View {
    @Environment(\.colorScheme) var colorScheme
    var imageName: String // Name of the image to display
    var descriptive: String // Description text
    var doneButton: Bool // Indicates if it's a Continue button
    var nextAction: () -> Void // Action to go next page
    var body: some View {
        VStack {
            //Display image
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 60)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            //Display text
            Text(descriptive)
                .multilineTextAlignment(.center)
                .font(.system(size: 30))
            HStack{
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button{
                    nextAction()
                } label: {
                    //Display circle arrow button
                    if !doneButton{
                        ZStack{
                            Circle()
                                .fill(colorScheme == .dark ? .white : .black)
                                .frame(width: 65)
                                .padding()
                            Image(systemName: "arrow.forward")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 25)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        }
                    } else{
                        //Display continue in a rectangle box
                        Text("Continue")
                            .frame(width: 120, height: 55)
                            .background(colorScheme == .dark ? .white : .black)
                            .cornerRadius(25)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .font(.system(size: 20))
                            .bold()
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}
