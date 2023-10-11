//
//  PumpBuddyApp.swift
//  PumpBuddy
//
//  Created by udit on 07/08/23.
//

import SwiftUI

@main
struct PumpBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
