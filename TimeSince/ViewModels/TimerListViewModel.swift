//
//  TimerListViewModel.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI
import SwiftData

@MainActor
class TimerListViewModel: ObservableObject {
    @Published var items: [TimerItem] = []
    private var context: ModelContext

    init(modelContext: ModelContext) {
        self.context = modelContext
        fetchItems()
    }

    func fetchItems() {
        let descriptor = FetchDescriptor<TimerItem>(sortBy: [SortDescriptor(\.order)])
        do {
            items = try context.fetch(descriptor)
            print("Fetched \(items.count) items")
            for (index, item) in items.enumerated() {
                print("Item \(index): \(item.subject), \(item.action), Order: \(item.order)")
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem(_ item: TimerItem) {
        item.order = items.count
        context.insert(item)
        print("Adding item: \(item.subject) \(item.action), Order: \(item.order)")
        saveContext()
        fetchItems()
    }

    func deleteItem(_ item: TimerItem) {
        context.delete(item)
        print("Deleting item: \(item.subject) \(item.action)")
        for (index, remainingItem) in items.enumerated() where remainingItem.id != item.id {
            remainingItem.order = index
            print("Updating order from item: \(remainingItem.subject) \(remainingItem.action), New Order: \(index)")
        }
        saveContext()
        fetchItems()
    }

    func resetTimer(for item: TimerItem) {
        item.lastOccurrence = Date()
        print("Resetting timer for item: \(item.subject) \(item.action)")
        saveContext()
        fetchItems()
    }
    
    func updateItem(_ updatedItem: TimerItem) {
        if let existingItem = items.first(where: { $0.id == updatedItem.id }) {
            existingItem.subject = updatedItem.subject
            existingItem.action = updatedItem.action
            existingItem.lastOccurrence = updatedItem.lastOccurrence
            print("Updating item: \(existingItem.subject) \(existingItem.action), Order: \(existingItem.order)")
            saveContext()
            fetchItems()
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        print("Moving item from \(source) to \(destination)")
        items.move(fromOffsets: source, toOffset: destination)

        for (index, item) in items.enumerated() {
            item.order = index
            print("Updated order for item: \(item.subject) \(item.action), New Order: \(index)")
        }
        
        saveContext()
        fetchItems()
    }

    private func saveContext() {
        do {
            try context.save()
            print("Content saved successfully")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    #if DEBUG
    static func createPreview(modelContext: ModelContext) -> TimerListViewModel {
        let viewModel = TimerListViewModel(modelContext: modelContext)
        
        let sampleItems = [
            TimerItem(subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600), order: 1),
            TimerItem(subject: "your mom", action: "called me", lastOccurrence: Date().addingTimeInterval(-86400), order: 0)
        ]
        
        for item in sampleItems {
            modelContext.insert(item)
        }
        
        viewModel.fetchItems()
        return viewModel
    }
    #endif
}
