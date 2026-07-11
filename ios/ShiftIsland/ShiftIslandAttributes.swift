//
//  ShiftIslandAttributes.swift
//  Runner
//
//  Created by 潜力熊 on 2026/7/10.
//
import ActivityKit
import Foundation


struct ShiftIslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
