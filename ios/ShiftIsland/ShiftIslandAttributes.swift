//
//  ShiftIslandAttributes.swift
//  Runner
//
//  Created by 潜力熊 on 2026/7/10.
//
import ActivityKit
import Foundation


// ==========================================
// 📦 1️⃣ 定义实时属性与动态状态 (Live Activity 模型)
// ==========================================
struct ShiftIslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // 动态数据：班次名称（如：早班、正常班、加班）
        var shiftName: String
        // 动态数据：班次开始时间
        var startTime: Date
        // 动态数据：班次结束时间
        var endTime: Date
        // 动态数据：班次主题色（十六进制，如 "#FF5733"）
        var colorHex: String
    }
    
    // 静态数据：如果需要绑定固定的用户ID或排班计划ID可以放在这里，目前留空即可
    var id: String = UUID().uuidString
}
