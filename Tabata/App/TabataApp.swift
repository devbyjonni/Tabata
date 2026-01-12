//
//  TabataApp.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import SwiftUI
import SwiftData

@main
struct TabataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TabataConfiguration.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Print the database path
             print("Database Path: \(modelConfiguration.url)")
            
            let context = ModelContext(container)
            let count = try context.fetchCount(FetchDescriptor<TabataConfiguration>())
            print("Total Configurations: \(count)")
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            StartView()
        }
        .modelContainer(sharedModelContainer)
    }
}
