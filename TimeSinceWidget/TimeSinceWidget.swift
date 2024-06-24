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
        SimpleEntry(date: Date(), items: [], theme: WidgetTheme.from(.system))
    }
    
    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let items = try? modelContainer.mainContext.fetch(FetchDescriptor<TimerItem>())
        let theme = getCurrentTheme()
        let entry = SimpleEntry(date: Date(), items: items ?? [], theme: theme)
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let items = try? modelContainer.mainContext.fetch(FetchDescriptor<TimerItem>())
        let theme = getCurrentTheme()
        let entry = SimpleEntry(date: Date(), items: items ?? [], theme: theme)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    func getCurrentTheme() -> WidgetTheme {
        if let savedTheme = UserDefaults.standard.string(forKey: "app_theme"),
           let appTheme = AppTheme(rawValue: savedTheme) {
            return WidgetTheme.from(appTheme)
        } else {
            return WidgetTheme.from(.system)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [TimerItem]
    let theme: WidgetTheme
}

struct TimerWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if let topItem = entry.items.first {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Time Since")
                        .font(entry.theme.mainFont)
                        .foregroundStyle(entry.theme.textColor)
                    Text("\(topItem.subject) \(topItem.action)")
                        .font(entry.theme.titleFont)
                        .foregroundStyle(entry.theme.accentColor)
                    Text(topItem.lastOccurrence, style: .relative)
                        .font(entry.theme.subtitleFont)
                        .foregroundStyle(entry.theme.secondaryTextcolor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            } else {
                Text("No timers available")
                    .font(entry.theme.mainFont)
                    .foregroundStyle(entry.theme.textColor)
            }
        }
        .containerBackground(for: .widget) {
            entry.theme.backgroundColor
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

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    SimpleEntry(date: .now, items: [
        TimerItem(id: UUID(), subject: "you", action: "slept", lastOccurrence: Date().addingTimeInterval(-3600), order: 0)
    ], theme: WidgetTheme.from(.system))
}
