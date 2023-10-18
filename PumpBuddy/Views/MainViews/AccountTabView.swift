//
//  AccountTabView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI
import UIKit
import WidgetKit
import Photos


struct WeightUpdate: Codable, Hashable{
    let weight: Double
    let date: Date
    let units: String
    
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            return dateFormatter.string(from: date)
        }
}

func saveToPlist(weightUpdates: [WeightUpdate]){

    // Define a file URL for the plist
    let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("weightUpdates.plist")

    // Encode and save the data to the plist file
    do {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(weightUpdates)
        try data.write(to: plistURL)
    } catch {
        print("Error saving data to plist: \(error)")
    }
    
}

func loadPlist() -> [WeightUpdate]{
    let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("weightUpdates.plist")

    var weightUpdates: [WeightUpdate] = []
    if let data = try? Data(contentsOf: plistURL) {
        let decoder = PropertyListDecoder()
        if let loadedUpdates = try? decoder.decode([WeightUpdate].self, from: data) {
            weightUpdates = loadedUpdates
        }
    }
    return weightUpdates
}

func appendToPlist(newWeightUpdate: WeightUpdate) {
    // Load the existing data from the plist
    var weightUpdates = loadPlist()
    
    // Append the new data
    weightUpdates.append(newWeightUpdate)
    
    // Save the updated array back to the plist
    saveToPlist(weightUpdates: weightUpdates)
}


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
    @AppStorage("defaultUnits") var selectedUnit: units = .kg
    
    @State private var weightUpdates: [WeightUpdate] = []

    @State private var selectedImage: UIImage? // To store the selected image
    @State private var isImagePickerPresented: Bool = false
    @State var isEditWeightsSheetPresented: Bool = false
    @State private var revealPwd: Bool = false
    @State private var isChangeOn: Bool = false
    @State private var newCurrentWeight: String = ""
    @State private var newGoalWeight: String = ""
    @AppStorage("imageName") private var selectedImageName: String?
//    @State private var selectedUnit: units = .kg


    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if let savedImage = retrieveImage(imageName: selectedImageName ?? "") {
                        Image(uiImage: savedImage)
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
                                ImagePicker(selectedImage: $selectedImage, selectedImageName: $selectedImageName ) {
                                    isImagePickerPresented = false
                                }
                            }
                            .padding(.bottom)
                    }
                    else{
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
                                ImagePicker(selectedImage: $selectedImage, selectedImageName: $selectedImageName ) {
                                    isImagePickerPresented = false
                                }
                            }
                            .padding(.bottom)
                    }

                    Text("Hello, \(username)!")
                        .font(.title)
//                        .foregroundColor(.black)

                    Text("Email: \(email)")
//                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.bottom)

                    if let currentWeightDouble = Double(currentWeight), let goalWeightDouble = Double(goalWeight) {
                        let currentWeightFormatted = String(format: "%.2f", currentWeightDouble)
                        let goalWeightFormatted = String(format: "%.2f", goalWeightDouble)

                        Text("Current Weight: \(currentWeightFormatted)\(selectedUnit.description)")
//                            .foregroundColor(.black)
                            .font(.headline)

                        Text("Goal Weight: \(goalWeightFormatted)\(selectedUnit.description)")
//                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.bottom)
                    }


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
                            goalWeight: $goalWeight,
                            tempUnit: $selectedUnit
                        )
                    }

                    Spacer()

                    Section(header: Text("Workout History")) {
                        Divider()
                        if workouts.isEmpty{
                            HStack{
                                Text("Oops... Looks like you do not have any workouts yet! Go to the Workout tab to add workouts.")
                                    .padding()
                                    .background(Color("Pink"))
                                    .cornerRadius(20)
                            }
                            .padding()
                            
                        }
                        else{
                            List {
                                ForEach(workouts, id: \.id) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                        WorkoutCardView(workout: workout)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
            }
            .navigationBarTitle("Account Info")
            .toolbarBackground(
                Color("AppColor"),
                for: .navigationBar)
            .padding(.vertical)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    Button{
                        isChangeOn.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .popover(isPresented: $isChangeOn){
                        changePassword(password: $password, confirmedPassword: $confirmedPassword, isChangeOn: $isChangeOn)
                    }
                }
            }
        }
        .onChange(of: isEditWeightsSheetPresented == false) { newValue in
                    if newValue {
                        let _curr_weight = try! JSONEncoder().encode(Double(currentWeight))
                        UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_curr_weight, forKey: "currentWeight")
                        let _goal_weight = try! JSONEncoder().encode(Double(goalWeight))
                        UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_goal_weight, forKey: "goalWeight")
                        let _unit = try! JSONEncoder().encode(selectedUnit)
                        UserDefaults(suiteName: "group.com.Udit.PumpBuddy")!.set(_unit, forKey: "defaultUnits")
                        
                        let newWeightUpdate = WeightUpdate(weight: Double(currentWeight) ?? 0, date: Date(), units: selectedUnit.description)
                        appendToPlist(newWeightUpdate: newWeightUpdate)
                        
                        WidgetCenter.shared.reloadTimelines(ofKind: "WorkoutWidget")
                        WidgetCenter.shared.reloadAllTimelines()
                        
                    }
                }
        .onChange(of: selectedImage){img in
            if (img != nil){
                saveImage(imageName: selectedImageName ?? "img.png", image: selectedImage ?? UIImage(systemName: "person.fill")!)
            }
        }
        .onAppear{
            weightUpdates = loadPlist()
        }
    }
    
}

struct changePassword: View{
    @Binding var password: String
    @Binding var confirmedPassword: String
    @Binding var isChangeOn: Bool
    var body: some View{
        NavigationView{
            Form{
                HStack{
                    Button("Cancel") {
                        isChangeOn = false
                    }
                    Spacer()
                    Button("Save") {
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(confirmedPassword, forKey: "confirmedPassword")
                        
                        isChangeOn = false
                    }
                }
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
}

struct EditWeightsSheet: View {
    @Binding var isSheetPresented: Bool
    @Binding var currentWeight: String
    @Binding var goalWeight: String
    @Binding var tempUnit: units

    
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
                    
                    HStack{
                        Text("Change Units:")
                        Spacer()
                        Picker(selection: $tempUnit, label:Text("")){
                            ForEach(units.allCases, id: \.self){unit in
                                Text("\(unit.description)")
                            }
                        }
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
            .onChange(of: tempUnit){ newUnit in
                var tempWeight : Double = 0
                
                var defaultUnits = tempUnit == .kg ? "lbs" : "kg"
                let og = defaultUnits
                (tempWeight, defaultUnits) = convertWeight(weight: Double(currentWeight) ?? 0, unit: defaultUnits)
                currentWeight = String(tempWeight)
                var xtempWeight : Double = 0
                (xtempWeight, defaultUnits) = convertWeight(weight: Double(goalWeight) ?? 0, unit: og)
                goalWeight = String(xtempWeight)
                if let newUnit = units(stringValue: defaultUnits){
                    tempUnit = newUnit
                }
            }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedImageName: String?
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

            // Get the URL of the selected image
            if let imageUrl = info[.imageURL] as? URL {
                // Retrieve the name of the image from its URL
                let imageName = imageUrl.lastPathComponent
                parent.selectedImageName = imageName
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

func saveImage(imageName: String, image: UIImage){
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documents.appendingPathComponent("\(imageName)")
    if let data = image.pngData() {
        do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
            }
    }
}

func retrieveImage(imageName: String) -> UIImage? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let imageUrl = documentsDirectory.appendingPathComponent("\(imageName)")

    if FileManager.default.fileExists(atPath: imageUrl.path) {
        if let image = UIImage(contentsOfFile: imageUrl.path) {
            return image
        }
    }
    return nil
}
