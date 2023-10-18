//
//  JsonModel.swift
//  PumpBuddy
//
//  Created by udit on 13/10/23.
//

import Foundation
import SwiftUI
import CoreData

/// A model class for handling JSON data and Core Data operations.
class JsonModel: ObservableObject{
    
    /// Published property for storing an array of ``ExerciseModel`` objects.
    @Published var data: [ExerciseModel] = []
    
    /// The managed object context used for Core Data operations.
    @Environment(\.managedObjectContext) var moc

    /// Transforms an array of ``ExerciseModel`` into Core Data ``Exercise`` entities.
      ///
      /// - Parameters:
      ///   - data: An array of ExerciseModel objects to be transformed.
      ///   - context: The managed object context for Core Data operations.
      /// - Returns: An array of Exercise entities.
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
    
    /// Retrieves the API key from a property list file.
    ///
    /// - Returns: The API key as a string.
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
    
    
    /// Fetches data from an external API asynchronously.
    ///
    /// - Parameters:
    ///   - dataNeeded: The type of data needed (e.g., "equipment" or "muscles").
    ///   - dataFor: The specific data to fetch (e.g., a muscle name).
    ///   - context: The managed object context for Core Data operations.
    /// - Returns: An array of ExerciseModel objects fetched from the API.
    /// - Throws: An error if the API request fails.
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
