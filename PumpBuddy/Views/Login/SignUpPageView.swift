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
    @AppStorage("email") var email: String = ""
    @AppStorage("password") var password: String = ""
    @AppStorage("confirmedPassword") var confirmedPassword: String = ""
    @AppStorage("currentWeight") var currentWeight: Int = 150 // Default value, change as needed
    @AppStorage("goalWeight") var goalWeight: Int = 150 // Default value, change as needed
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @State private var isValid: Bool = false
    @State private var showInvalidInputAlert = false

    @State private var currentWeightOptions: [Int] = Array(40...300)
    @State private var goalWeightOptions: [Int] = Array(40...300)

    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section(header: Text("Sign Up")) {
                    InputField(placeholder: "Username", text: $username, keyboardType: .default)
                    InputField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    SecureInputField(placeholder: "Password", text: $password)
                    SecureInputField(placeholder: "Confirm Password", text: $confirmedPassword)
                    
                    //Adapted from https://codewithchris.com/swiftui-picker-2023/
                    Picker(selection: $currentWeight, label: Text("Current Weight (kgs)")) {
                        ForEach(currentWeightOptions, id: \.self) { weight in
                            Text("\(weight)")
                        }
                    }

                    //Adapted from https://codewithchris.com/swiftui-picker-2023/
                    Picker(selection: $goalWeight, label: Text("Goal Weight (kgs)")) {
                        ForEach(goalWeightOptions, id: \.self) { weight in
                            Text("\(weight)")
                        }
                    }
                }
            }

            Button("Continue") {
                if isValid {
                    loggedIn = true
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(currentWeight, forKey: "currentWeight")
                    UserDefaults.standard.set(goalWeight, forKey: "goalWeight")
                } else {
                    showInvalidInputAlert = true
                }
            }
            .buttonStyle(RoundedButtonStyle(isEnabled: isValid))
            .padding(.vertical)
        }
        .padding()
        .alert(isPresented: $showInvalidInputAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please fill in all fields and ensure they meet the required criteria."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}




struct InputField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .onChange(of: text) { _ in
                // Perform input validation logic here
            }
    }
}

struct SecureInputField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .onChange(of: text) { _ in
                // Perform input validation logic here
            }
    }
}

struct NumericInputField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.numberPad)
            .onChange(of: text) { _ in
                // Perform input validation logic here
            }
    }
}

struct RoundedButtonStyle: ButtonStyle {
    var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isEnabled ? Color("AppColor") : Color.gray)
            .cornerRadius(25)
            .opacity(isEnabled ? 1 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPageView()
    }
}
