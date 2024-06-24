//
//  ContentView.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
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
    @State private var showingAddItemView = false
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditing = false
    
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
                                if !isEditing {
                                    selectedItem = item
                                    showingActionModal = true
                                }
                            }
                    }
                    .onMove(perform: viewModel.moveItem)
                    .listRowBackground(Color.clear)
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingButton()
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Last Time Since")
                        .font(themeManager.font(for: .title2))
                        .foregroundStyle(themeManager.color(for: .text))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done": "Edit")
                    }
                    .foregroundStyle(themeManager.color(for: .accent))
                }
            }
            .foregroundStyle(themeManager.color(for: .text))
        }
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
        .sheet(isPresented: $showingAddItemView) {
            AddEditItemView(itemCount: viewModel.items.count, onSave: { newItem in
                viewModel.addItem(newItem)
                showingAddItemView = false
            })
            .environmentObject(themeManager)
        }
        .sheet(item: $itemToEdit) { item in
            AddEditItemView(item: item, itemCount: viewModel.items.count, onSave: { updatedItem in
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
