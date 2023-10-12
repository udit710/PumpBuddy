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

    func fetchData(dataNeeded: String, dataFor: String, context: NSManagedObjectContext) -> [ExerciseModel]{
        let for_ = dataFor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/exercises?\(dataNeeded)="+for_!)!
        var request = URLRequest(url: url)
        request.addValue("0M/NVQZMsyAELTdiajCn1w==WPU2UGrGFcKcKLXm", forHTTPHeaderField: "X-Api-Key")
        let session = URLSession.shared.dataTask(with: request) {(data, response, _) in
            guard let jsonData = data else { return }
            
            let res = response as! HTTPURLResponse
            
//            print(dat)
            
            if res.statusCode == 404{
                print("Error from API")
                return
            }
            
            
            do{
                let objs = try JSONDecoder().decode([ExerciseModel].self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.data = objs
                    
                }
                if !objs.isEmpty{
                    print(objs[0].name)
                }
            } catch{
                print(error.localizedDescription)
            }
        }
        session.resume()
        
        return self.data
//        session.resume()
    }
}