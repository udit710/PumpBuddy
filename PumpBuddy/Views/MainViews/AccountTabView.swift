//
//  AccountTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI
import UIKit

struct AccountTabView: View {
    @FetchRequest(
        //adapted from https://stackoverflow.com/questions/26883270/swift-sort-array-by-sort-descriptors
        //used to sort ascending
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("currentWeight") var currentWeight: String = ""
    @AppStorage("goalWeight") var goalWeight: String = ""
    @State private var selectedImage: UIImage? // To store the selected image
    @State private var isImagePickerPresented: Bool = false
    @State private var isEditWeightsSheetPresented: Bool = false
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
                        Text("Edit Weights")
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

                    Spacer()

                    Section(header: Text("Workout History")) {
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
                    TextField("Current Weight", text: $currentWeight)
                        .keyboardType(.numberPad)
                    
                    TextField("Goal Weight", text: $goalWeight)
                        .keyboardType(.numberPad)
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
