//
//  ContentView.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/21.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TimerItem]
    @StateObject private var viewModel: TimerListViewModel
    @State private var selectedItem: TimerItem?
    @State private var showingActionModal = false
    @State private var itemToEdit: TimerItem?
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TimerListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme90s.background.ignoresSafeArea()
                
                List {
                    ForEach(viewModel.items) { item in
                        ItemRow(item: item)
                            .onTapGesture {
                                selectedItem = item
                                showingActionModal = true
                            }
                    }
                    .listRowBackground(Theme90s.buttonBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Last Time Since")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditItemView(onSave: viewModel.addItem)) {
                        Image(systemName: "plus")
                            .foregroundColor(Theme90s.accent)
                    }
                }
            }
        }
        .foregroundColor(Theme90s.text)
        .font(.custom(Theme90s.font, size: 24))
        .overlay(
            ModalOverlay(
                showingActionModal: $showingActionModal,
                selectedItem: selectedItem,
                onReset: {
                    item in viewModel.resetTimer(for: item)
                },
                onDelete: {
                    item in viewModel.deleteItem(item)
                },
                onEdit: {
                    item in itemToEdit = item
                }
            )
        )
        .sheet(item: $itemToEdit) { item in
            AddEditItemView(item: item, onSave: { updatedItem in
                if viewModel.items.contains(where: { $0.id == updatedItem.id }) {
                    viewModel.updateItem(updatedItem)
                } else {
                    viewModel.addItem(updatedItem)
                }
                itemToEdit = nil
            })
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
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
}
