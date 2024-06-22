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
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TimerListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.color(for: .background).ignoresSafeArea()
                
                List {
                    ForEach(viewModel.items) { item in
                        ItemRow(item: item)
                            .onTapGesture {
                                selectedItem = item
                                showingActionModal = true
                            }
                    }
                    .listRowBackground(themeManager.color(for: .buttonBackground))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Last Time Since")
                        .font(themeManager.font(for: .title2))
                        .foregroundColor(themeManager.color(for: .text))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditItemView(onSave: viewModel.addItem)) {
                        Image(systemName: "plus")
                            .foregroundColor(themeManager.color(for: .accent))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("App Theme", selection: $themeManager.currentTheme) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.name).tag(theme)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Theme")
                            Image(systemName: "chevron.down")
                                .foregroundColor(themeManager.color(for: .accent))
                                .font(.caption)
                        }
                        .font(themeManager.font(for: .body))
                    }
                }
            }
        }
        .foregroundColor(themeManager.color(for: .text))
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
        .environment(\.font, themeManager.font(for: .body))
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
