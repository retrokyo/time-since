//
//  TimeSinceWidget.swift
//  TimeSinceWidget
//
//  Created by Reeves Froning on 2024/06/21.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    let modelContainer: ModelContainer
    
    func placeholder(in contex: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [])
    }
    
    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let items = try? modelContainer.mainContext.fetch(FetchDescriptor<TimerItem>())
        let entry = SimpleEntry(date: Date(), items: items ?? [])
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let items = try? modelContainer.mainContext.fetch(FetchDescriptor<TimerItem>())
        let entry = SimpleEntry(date: Date(), items: items ?? [])
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [TimerItem]
}

struct TimerWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            ForEach(entry.items) { item in
                Text("Last time since \(item.subject) \(item.action)")
                Text(item.lastOccurrence, style: .relative)
            }
        }
    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(modelContainer: sharedModelContainer)) { entry in
            TimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Last Time Since")
        .description("Display your selected timers.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        TimerItem.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer \(error)")
    }
}()

#Preview(as: .systemSmall) {
    TimerWidget()
} timeline: {
    SimpleEntry(date: .now, items: [
        TimerItem(id: UUID(), subject: "you", action: "slept", lastOccurrence: Date().addingTimeInterval(-3600))
    ])
}
