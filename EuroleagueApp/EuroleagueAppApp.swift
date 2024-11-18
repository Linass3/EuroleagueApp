//
//  EuroleagueAppApp.swift
//  EuroleagueApp
//
//  Created by Linas Venclavičius on 18/11/2024.
//

import SwiftUI

@main
struct EuroleagueAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
