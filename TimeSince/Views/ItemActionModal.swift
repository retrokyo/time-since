//
//  ItemActionSheet.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI

struct ItemActionModal: View {
    let item: TimerItem
    let onReset: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    let onDismiss: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Last time since \(item.subject) \(item.action)")
                .font(themeManager.font(for: .headline))
                .foregroundStyle(themeManager.color(for: .text))
            
            Text(item.lastOccurrence, style: .relative)
                .font(themeManager.font(for: .subheadline))
                .foregroundStyle(themeManager.color(for: .accent))
            
            HStack(spacing: 20) {
                ActionButton(title: "Reset", icon: "arrow.clockwise", color: .green) {
                    onReset()
                    onDismiss()
                }
                
                ActionButton(title: "Edit", icon: "pencil", color: .blue) {
                    onEdit()
                    onDismiss()
                }
                
                ActionButton(title: "Delete", icon: "trash", color: .red) {
                    onDelete()
                    onDismiss()
                }
            }
        }
        .padding()
        .background(themeManager.color(for: .buttonBackground))
        .cornerRadius(10)
        .shadow(color: .black, radius: 5, x: 5, y: 5)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 25))
                Text(title)
                    .font(themeManager.font(for: .caption))
            }
            .foregroundStyle(color)
        }
    }
}

#Preview {
    ItemActionModal(
        item: TimerItem(id: UUID(), subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600), order: 0),
        onReset: {},
        onDelete: {},
        onEdit: {},
        onDismiss: {}
    )
    .environmentObject(ThemeManager())
}
