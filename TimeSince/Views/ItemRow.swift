//
//  ItemRow.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/21.
//

import SwiftUI

struct ItemRow: View {
    let item: TimerItem
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Last time since \(item.subject) \(item.action)")
                .font(themeManager.font(for: .body))
                .foregroundColor(themeManager.color(for: .text))
            Text(item.lastOccurrence, style: .relative)
                .font(themeManager.font(for: .caption))
                .foregroundColor(themeManager.color(for: .accent))
        }
        .padding()
        .background(themeManager.color(for: .background))
        .cornerRadius(8)
        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y:2)
    }
}

#Preview {
    let item = TimerItem(id: UUID(), subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600))
    return ItemRow(item: item)
        .padding()
        .environmentObject(ThemeManager())
}
