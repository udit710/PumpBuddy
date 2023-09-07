//
//  SignUpPage.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI

struct SignUpPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username: String = ""
    @AppStorage("loggendIn") var loggedIn: Bool = false
    @State private var isValid : Bool = false

    var body: some View {
            VStack {
                Form {
                    HStack{
                        TextField("Enter your username",text: $username)
                    }
                }
                Button("Continue"){
                    loggedIn = true
                }
                .frame(width: 120, height: 35)
                .background(colorScheme == .dark ? .white : .black)
                .cornerRadius(25)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .font(.system(size: 20))
                .bold()
                .disabled(username.count < 4)
                .opacity(username.count < 4 ? 0.5 : 1)
            }
    }
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPageView()
    }
}
