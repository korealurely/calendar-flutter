//
//  ShiftIslandLiveActivity.swift
//  ShiftIsland
//
//  Created by 潜力熊 on 2026/7/10.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct ShiftIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShiftIslandAttributes.self) {
            context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }.activityBackgroundTint(Color.cyan).activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: {
            context in
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
            }.widgetURL(URL(string: "http://www.apple.com")).keylineTint(Color.red)
        }
    }
}

extension ShiftIslandAttributes {
    fileprivate static var preview: ShiftIslandAttributes {
        ShiftIslandAttributes(name: "World")
    }
}

extension ShiftIslandAttributes.ContentState {
    fileprivate static var smiley: ShiftIslandAttributes.ContentState {
        ShiftIslandAttributes.ContentState(emoji: "😀")
    }

    fileprivate static var starEyes: ShiftIslandAttributes.ContentState {
        ShiftIslandAttributes.ContentState(emoji: "🤩")
    }
}

#Preview("Notification", as: .content, using: ShiftIslandAttributes.preview) {
    ShiftIslandLiveActivity()
} contentStates: {
    ShiftIslandAttributes.ContentState.smiley
    ShiftIslandAttributes.ContentState.starEyes
}
