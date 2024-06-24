//
//  ItemRow.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI

struct ItemRow: View {
    let item: TimerItem
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Last time since \(item.subject) \(item.action)")
                .font(themeManager.font(for: .title))
                .foregroundColor(themeManager.color(for: .text))
            Text(item.lastOccurrence, style: .relative)
                .font(themeManager.font(for: .title2))
                .foregroundColor(themeManager.color(for: .accent))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .background(themeManager.color(for: .background).opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    ItemRow_PreviewContainer()
}

struct ItemRow_PreviewContainer: View {
    var body: some View {
        Group {
            ForEach(AppTheme.allCases) { theme in
                ItemRow(item: TimerItem(id: UUID(), subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600), order: 0))
                    .environmentObject(ThemeManager(initialTheme: theme))
                    .previewLayout(.sizeThatFits)
                    .padding()
                    .background(Color(.systemBackground))
                    .previewDisplayName("\(theme.name) Theme")
            }
        }
    }
}
