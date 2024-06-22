//
//  TimeSinceWidgetLiveActivity.swift
//  TimeSinceWidget
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/21.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimeSinceWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimeSinceWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeSinceWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimeSinceWidgetAttributes {
    fileprivate static var preview: TimeSinceWidgetAttributes {
        TimeSinceWidgetAttributes(name: "World")
    }
}

extension TimeSinceWidgetAttributes.ContentState {
    fileprivate static var smiley: TimeSinceWidgetAttributes.ContentState {
        TimeSinceWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimeSinceWidgetAttributes.ContentState {
         TimeSinceWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimeSinceWidgetAttributes.preview) {
   TimeSinceWidgetLiveActivity()
} contentStates: {
    TimeSinceWidgetAttributes.ContentState.smiley
    TimeSinceWidgetAttributes.ContentState.starEyes
}
