//
//  FloatingButton.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/24.
//

import SwiftUI
import SwiftData

struct FloatingButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingThemePicker = false
    
    var body: some View {
        Button(action: {
            showingThemePicker.toggle()
        }) {
            Image(systemName: "paintbrush.fill")
                .foregroundColor(themeManager.color(for: .text))
                .padding()
                .background(themeManager.color(for: .accent))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .shadow(radius: 4)
        }
        .actionSheet(isPresented: $showingThemePicker) {
            ActionSheet(
                title: Text("Select Theme"),
                buttons: AppTheme.allCases.map { theme in
                        .default(Text(theme.name)) {
                            themeManager.currentTheme = theme
                        }
                } + [.cancel()]
            )
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimerItem.self, configurations: config)
        let viewModel = TimerListViewModel.createPreview(modelContext: container.mainContext)
        
        return ContentView(modelContext: container.mainContext)
            .modelContainer(container)
            .environmentObject(viewModel)
            .environmentObject(ThemeManager())
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}
