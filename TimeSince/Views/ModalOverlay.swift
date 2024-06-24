//
//  ModalOverlay.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI

struct ModalOverlay: View {
    @Binding var showingActionModal: Bool
    let selectedItem: TimerItem?
    let onReset: (TimerItem) -> Void
    let onDelete: (TimerItem) -> Void
    let onEdit: (TimerItem) -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if showingActionModal, let item = selectedItem {
                themeManager.color(for: .background).opacity(0.4)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        showingActionModal = false
                    }
                
                ItemActionModal(
                    item: item,
                    onReset: {
                        onReset(item)
                        showingActionModal = false
                    },
                    onDelete: {
                        onDelete(item)
                        showingActionModal = false
                    },
                    onEdit: {
                        onEdit(item)
                        showingActionModal = false
                    },
                    onDismiss: { showingActionModal = false }
                )
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showingActionModal)
    }
}

#Preview {
    ModalOverlay(
        showingActionModal: .constant(true),
        selectedItem: TimerItem(id: UUID(), subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600)),
        onReset: { _ in },
        onDelete: { _ in },
        onEdit: { _ in }
    )
    .environmentObject(ThemeManager())
}
