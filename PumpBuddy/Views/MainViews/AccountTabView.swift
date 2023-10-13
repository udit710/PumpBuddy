//
//  AccountTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI

struct AccountTabView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        NavigationLink(destination: WorkoutHistoryView()) {
                            //Adapted and taken from https://sarunw.com/posts/swiftui-button-size/ to make button
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("AppColor"))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding()
                        }
                        .padding(.horizontal)
                    }
                    .navigationBarTitle("Account Info")
                    .toolbarBackground(
                        Color("AppColor"),
                        for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
    }
}

