//
//  TimeSinceApp.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI
import SwiftData

@main
struct TimeSince: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)
                .environmentObject(themeManager)
                .modifier(themeManager.applyTheme())
        }
        .modelContainer(sharedModelContainer)
    }
}

private let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        TimerItem.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer \(error)")
    }
}()
