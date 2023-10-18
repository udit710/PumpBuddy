//
//  AccountTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI
import UIKit
import WidgetKit

struct AccountTabView: View {
    @FetchRequest(
        //adapted from https://stackoverflow.com/questions/26883270/swift-sort-array-by-sort-descriptors
        //used to sort ascending
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    var workouts: FetchedResults<Workout>
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("currentWeight") var currentWeight: String = ""
    @AppStorage("goalWeight") var goalWeight: String = ""
    @AppStorage("password") var password: String = ""
    @AppStorage("confirmedPassword") var confirmedPassword: String = ""
    @State private var selectedImage: UIImage? // To store the selected image
    @State private var isImagePickerPresented: Bool = false
    @State var isEditWeightsSheetPresented: Bool = false
    @State private var revealPwd: Bool = false
    @State private var isChangeOn: Bool = false
    @State private var newCurrentWeight: String = ""
    @State private var newGoalWeight: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: WorkoutHistoryView()) {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("AppColor"))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding()
                    }
                    .padding(.leading)
                    Spacer()
                }

                VStack {
                    Image(uiImage: selectedImage ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage) {
                                isImagePickerPresented = false
                            }
                        }
                        .padding(.bottom)

                    Text("Hello, \(username)!")
                        .font(.title)
                        .foregroundColor(.black)

                    Text("Email: \(email)")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.bottom)

                    Text("Current Weight: \(currentWeight)")
                        .foregroundColor(.black)
                        .font(.headline)

                    Text("Goal Weight: \(goalWeight)")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.bottom)

                    Spacer()
                    
                    Button(action: {
                        isEditWeightsSheetPresented.toggle()
                    }) {
                        Text("Edit Weight Entries")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("AppColor"))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.bottom)
                    }
                    .sheet(isPresented: $isEditWeightsSheetPresented) {
                        EditWeightsSheet(
                            isSheetPresented: $isEditWeightsSheetPresented,
                            currentWeight: $currentWeight,
                            goalWeight: $goalWeight
                        )
                    }
                    .popover(isPresented: $isChangeOn){
                        VStack{
                            Form{
                                HStack{
                                    Text("New Password: ")
                                    SecureInputField(placeholder: "Password", text: $password)
                                }
                                
                                HStack{
                                    Text("Confirm New Password: ")
                                    SecureInputField(placeholder: "Confirm", text: $confirmedPassword)
                                }
                            }
                        }
                    }

                    Spacer()

                    Section(header: Text("Workout History")) {
                        Divider()
                        if workouts.isEmpty{
                            Text("Oops... Looks like you do not have any workouts yet! Go to the Workout tab to add workouts.")
                                .padding()
                                .background(Color("Pink"))
                                .cornerRadius(20)
                            
                        }
                        List {
                            ForEach(workouts, id: \.id) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutCardView(workout: workout)
                                }
                                .listRowBackground(Color.white)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationBarTitle("Account Info")
            .toolbarBackground(
                Color("AppColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    Button{
                        isChangeOn.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
        .onChange(of: isEditWeightsSheetPresented == false) { newValue in
                    if newValue {
                        let _curr_weight = try! JSONEncoder().encode(Int(currentWeight))
                        UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_curr_weight, forKey: "currentWeight")
                        let _goal_weight = try! JSONEncoder().encode(Int(goalWeight))
                        UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_goal_weight, forKey: "goalWeight")
                        WidgetCenter.shared.reloadTimelines(ofKind: "WorkoutWidget")
                        WidgetCenter.shared.reloadAllTimelines()
                        print("Widget")
                    }
                }
    }
    
}


struct EditWeightsSheet: View {
    @Binding var isSheetPresented: Bool
    @Binding var currentWeight: String
    @Binding var goalWeight: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Weights")) {
                    HStack{
                        Text("Current Weight:")
                        Spacer()
                        TextField("Current Weight", text: $currentWeight)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack{
                        Text("Goal Weight:")
                        Spacer()
                        TextField("Goal Weight", text: $goalWeight)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationBarTitle("Edit Weights")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isSheetPresented = false
                },
                trailing: Button("Save") {
                    UserDefaults.standard.set(currentWeight, forKey: "currentWeight")
                    UserDefaults.standard.set(goalWeight, forKey: "goalWeight")
                    
                    isSheetPresented = false
                }
            )
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onDismiss: () -> Void // Callback to dismiss the sheet

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = selectedImage
            } else if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }

            parent.onDismiss()
        }
    }
}




struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
    }
}
