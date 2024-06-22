//
//  ItemRow.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/21.
//

import SwiftUI

struct ItemRow: View {
    let item: TimerItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Last time since \(item.subject) \(item.action)")
            Text(item.lastOccurrence, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Theme90s.buttonBackground)
        .cornerRadius(8)
        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y:2)
    }
}

#Preview {
    let item = TimerItem(id: UUID(), subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600))
    return ItemRow(item: item).padding()
}
