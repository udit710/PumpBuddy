//
//  JsonModel.swift
//  PumpBuddy
//
//  Created by udit on 13/10/23.
//

import Foundation
import SwiftUI
import CoreData

class JsonModel: ObservableObject{
    
    @Published var data: [ExerciseModel] = []
    @Environment(\.managedObjectContext) var moc

    
    func showData(data: [ExerciseModel], context: NSManagedObjectContext) -> [Exercise]{
        
        var exercises: [Exercise] = []
        
        data.forEach{ (d) in
            let entity = Exercise(context: context)
            entity.name = d.name
            entity.id = UUID()
            entity.muscles = d.muscle
            entity.type = d.type
            entity.instructions = d.instructions
            entity.isFavourite = false
            
            exercises.append(entity)
            
        }
        
        return exercises
    }

    func getApiKey() -> String {
        var key = ""

        if let plistPath = Bundle.main.path(forResource: "Api_Key", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: plistPath) as? [String: Any] {
            if let apiKey = dict["Key"] as? String {
                key = apiKey
            }
        }

        return key
    }

    
    func fetchData(dataNeeded: String, dataFor: String, context: NSManagedObjectContext) async throws -> [ExerciseModel] {
        let for_ = dataFor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/exercises?\(dataNeeded)=" + (for_ ?? ""))!
        var request = URLRequest(url: url)
        let key = getApiKey()
        request.addValue(key, forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    print("Error from API")
                    return []
                }
            }
            
            let objs = try JSONDecoder().decode([ExerciseModel].self, from: data)
            if !objs.isEmpty {
                print(objs[0].name)
            }
            return objs
        } catch {
            print(error.localizedDescription)
            return []
        }
    }


}
