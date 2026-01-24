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
            TabataSettings.self,
            CompletedWorkout.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .background(Color.slate900)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
