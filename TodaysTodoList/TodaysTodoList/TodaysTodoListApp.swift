//
//  TodaysTodoListApp.swift
//  TodaysTodoList
//
//  Created by Morgana Galamba on 25/10/21.
//

import SwiftUI

@main
struct TodaysTodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
