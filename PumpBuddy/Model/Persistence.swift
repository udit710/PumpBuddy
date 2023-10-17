//
//  Persistence.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//

import Foundation
import CoreData

struct PersistenceController{
    
    static let shared = PersistenceController()
    
    let container : NSPersistentContainer
    
    static var preview : PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WorkoutData")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
                return
            }
            
        }
    }
    
}
