//
//  AddEditItemView.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import SwiftUI
import SwiftData

struct AddEditItemView: View {
    @State private var subject: String
    @State private var action: String
    @State private var showingError = false
    @State private var errorMessage = ""
    var item: TimerItem?
    var onSave: (TimerItem) -> Void
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(item: TimerItem? = nil, onSave: @escaping (TimerItem) -> Void) {
        self.item = item
        self.onSave = onSave
        _subject = State(initialValue: item?.subject ?? "")
        _action = State(initialValue: item?.action ?? "")
    }
    
    var body: some View {
        ZStack {
            themeManager.color(for: .background).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.color(for: .accent))
                    .font(themeManager.font(for: .body))
                    
                    Spacer()
                    
                    Text(item == nil ? "Add Item": "Edit Item")
                        .font(themeManager.font(for: .headline))
                        .foregroundColor(themeManager.color(for: .text))
                    
                    Spacer()
                    
                    Button("Save") {
                        if validateInput() {
                            let newItem = TimerItem(
                                id: item?.id ?? UUID(),
                                subject: subject,
                                action: action,
                                lastOccurrence: item?.lastOccurrence ?? Date()
                            )
                            onSave(newItem)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(themeManager.color(for: .accent))
                    .font(themeManager.font(for: .headline))
                }
                .padding()
                .background(themeManager.color(for: .background))
                
                Form {
                    Section {
                        TextField("Subject (e.g., you, your mom)", text: $subject)
                            .foregroundColor(themeManager.color(for: .text))
                            .font(themeManager.font(for: .body))
                        TextField("Action (e.g., ate)", text: $action)
                            .foregroundColor(themeManager.color(for: .text))
                            .font(themeManager.font(for: .body))
                    }
                    .listRowBackground(themeManager.color(for: .buttonBackground))
                }
                .scrollContentBackground(.hidden)
            }
        }
        
        .alert(isPresented: $showingError) {
            Alert(title: Text("Input Invalid"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateInput() -> Bool {
        if subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Subject cannot be empty"
            showingError = true
            return false
        }
        
        if action.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Action cannot be empty"
            showingError = true
            return false
        }
        
        return true
    }
}

#Preview("Add Item") {
    NavigationView {
        AddEditItemView(onSave: {_ in})
            .environmentObject(ThemeManager())
    }
}

struct AddEditItem_Previews: PreviewProvider {
    static var previews: some View {
        AddEditItemView(onSave: { _ in })
            .environmentObject(ThemeManager())
    }
}
