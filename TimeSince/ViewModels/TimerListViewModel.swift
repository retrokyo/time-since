//
//  TimerListViewModel.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/21.
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
        let descriptor = FetchDescriptor<TimerItem>(sortBy: [SortDescriptor(\.lastOccurrence, order: .reverse)])
        do {
            items = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem(_ item: TimerItem) {
        context.insert(item)
        saveContext()
        fetchItems()
    }

    func deleteItem(_ item: TimerItem) {
        context.delete(item)
        saveContext()
        fetchItems()
    }

    func resetTimer(for item: TimerItem) {
        item.lastOccurrence = Date()
        saveContext()
        fetchItems()
    }
    
    func updateItem(_ updatedItem: TimerItem) {
        if let existingItem = items.first(where: { $0.id == updatedItem.id }) {
            existingItem.subject = updatedItem.subject
            existingItem.action = updatedItem.action
            existingItem.lastOccurrence = updatedItem.lastOccurrence
            saveContext()
            fetchItems()
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    #if DEBUG
    static func createPreview(modelContext: ModelContext) -> TimerListViewModel {
        let viewModel = TimerListViewModel(modelContext: modelContext)
        
        let sampleItems = [
            TimerItem(subject: "you", action: "ate", lastOccurrence: Date().addingTimeInterval(-3600)),
            TimerItem(subject: "your mom", action: "called me", lastOccurrence: Date().addingTimeInterval(-86400))
        ]
        
        for item in sampleItems {
            modelContext.insert(item)
        }
        
        viewModel.fetchItems()
        return viewModel
    }
    #endif
}
