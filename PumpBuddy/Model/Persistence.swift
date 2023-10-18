//
//  Persistence.swift
//  PumpBuddy
//
//  Created by udit on 10/10/23.
//

import Foundation
import CoreData

/// A utility class for managing Core Data persistence.
struct PersistenceController{
/// The shared instance of the PersistenceController.
    static let shared = PersistenceController()
    /// The Core Data container for managing data storage and retrieval.
    let container : NSPersistentContainer

    /// A preview instance of the PersistenceController, typically used for development and testing.
    static var preview : PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        return controller
    }()
    
    /// Initializes a new PersistenceController.
    ///
    /// - Parameter inMemory: A boolean indicating whether to use an in-memory Core Data store.
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
