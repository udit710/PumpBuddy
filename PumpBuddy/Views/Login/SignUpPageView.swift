//
//  SignUpPage.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//
import SwiftUI

enum units: String,CustomStringConvertible, CaseIterable, Encodable{
    case kg = "kg"
    case lbs = "lbs"
    
    var description: String {
        return self.rawValue
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "kg":
            self = .kg
        case "lbs":
            self = .lbs
        default:
            return nil
        }
    }
}

func convertWeight(weight: Double, unit: String) -> (Double,String) {
    var newWeight : Double = 0
    var newUnit : String = "kg"
    if unit == "lbs"{
        newWeight = Double(weight) / 2.20
        newUnit = "kg"
    } else if unit == "kg"{
        newWeight = Double(weight) * 2.20
        newUnit = "lbs"
    }
    return (Double(newWeight), newUnit)
}

struct SignUpPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("password") var password: String = ""
    @AppStorage("confirmedPassword") var confirmedPassword: String = ""
    @AppStorage("currentWeight") var finalCurrentWeight: String = ""
    @AppStorage("goalWeight") var finalGoalWeight: String = ""
    @AppStorage("defaultUnits") var defaultUnits: units =  units.kg
    
    @State private var currentWeight: Int = 150
    @State private var goalWeight: Int = 150

    @State private var showInvalidInputAlert = false
    @State private var isNavigatingToHome = false
    @State private var isValid: Bool = false

    @State private var currentWeightOptions: [Int] = Array(40...300)
    @State private var goalWeightOptions: [Int] = Array(40...300)

    @State private var weightUpdates: [WeightUpdate] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section(header: Text("Sign Up")) {
                    InputField(placeholder: "Username", text: $username, keyboardType: .default)
                    InputField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    SecureInputField(placeholder: "Password", text: $password)
                    SecureInputField(placeholder: "Confirm Password", text: $confirmedPassword)

                    Picker(selection: $currentWeight, label: Text("Current Weight (\(defaultUnits.description))")) {
                        ForEach(currentWeightOptions, id: \.self) { weight in
                            Text("\(weight)")
                        }
                    }

                    Picker(selection: $goalWeight, label: Text("Goal Weight (\(defaultUnits.description))")) {
                        ForEach(goalWeightOptions, id: \.self) { weight in
                            Text("\(weight)")
                        }
                    }
                    
                    Picker(selection: $defaultUnits, label:Text("Select units")){
                        ForEach(units.allCases, id: \.self){unit in
                            Text("\(unit.description)")
                        }
                    }
                }
            }

            Button("Continue") {
                if isValidInput() {
                    finalGoalWeight = String(goalWeight)
                    finalCurrentWeight = String(currentWeight)
                    let _user_name = try! JSONEncoder().encode(username)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_user_name, forKey: "username")
                    let _email = try! JSONEncoder().encode(email)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_email, forKey: "email")
                    let _curr_weight = try! JSONEncoder().encode(finalCurrentWeight)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_curr_weight, forKey: "currentWeight")
                    let _goal_weight = try! JSONEncoder().encode(finalGoalWeight)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_goal_weight, forKey: "goalWeight")
                    let _password = try! JSONEncoder().encode(password)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_password, forKey: "password")
                    let _units = try! JSONEncoder().encode(defaultUnits)
                    UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_units, forKey: "defaultUnits")

                    // Set the loggedIn flag
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    weightUpdates.append(WeightUpdate(weight: Double(currentWeight), date: Date(), units: defaultUnits.description))
                    
                    saveToPlist(weightUpdates: weightUpdates)

                    // Navigate to the home page
                    isNavigatingToHome = true
                } else {
                    showInvalidInputAlert = true
                }
            }
            .buttonStyle(RoundedButtonStyle(isEnabled: isValid))
            .foregroundColor(.white)
            .background(isValid ? Color.green : Color.gray)
            .cornerRadius(25)
            .opacity(isValid ? 1 : 0.5)
            .padding(.vertical)
            .fullScreenCover(isPresented: $isNavigatingToHome, content: {
                HomePageView()
            })
        }
        .padding()
        .navigationBarHidden(true)
        .alert(isPresented: $showInvalidInputAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please fill in all fields and ensure they meet the required criteria."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func isValidInput() -> Bool {
        return !username.isEmpty && !email.isEmpty && password.count >= 6 && password == confirmedPassword
    }
}


struct InputField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
    }
}

struct SecureInputField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
    }
}

struct NumericInputField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.numberPad)
    }
}

struct RoundedButtonStyle: ButtonStyle {
    var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(isEnabled ? Color.green : Color.gray)
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
