//
//  ShiftIslandLiveActivity.swift
//  ShiftIsland
//
//  Created by 潜力熊 on 2026/7/10.
//

import ActivityKit
import WidgetKit
import SwiftUI

// ==========================================
// 🏝️ 2️⃣ 灵动岛与锁屏卡片核心组件
// ==========================================
struct ShiftIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShiftIslandAttributes.self) { context in
            // ==========================================
            // 🔒 锁屏卡片 UI (显示在锁屏或顶部通知横幅)
            // ==========================================
            HStack(spacing: 16) {
                // 左侧班次颜色胶囊徽章
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(flutterColorString: context.state.colorHex))
                    .frame(width: 6, height: 45)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.shiftName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("班次时间：\(context.state.startTime.toHHmm()) ~ \(context.state.endTime.toHHmm())")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 右侧倒计时：系统底层全自动走表，0功耗
                VStack(alignment: .trailing, spacing: 4) {
                    Text("距离下班")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(timerInterval: context.state.startTime...context.state.endTime, countsDown: true)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(flutterColorString: context.state.colorHex))
                }
            }
            .padding()
            .activityBackgroundTint(Color(white: 0.12)) // 深色半透的高级感背景
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // ==========================================
                // 🟢 长按展开后的完整大岛 UI
                // ==========================================
                
                // 展开状态左侧：大班次名称 + 状态图标
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(flutterColorString: context.state.colorHex))
                            .frame(width: 10, height: 10)
                        Text(context.state.shiftName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1) // 防止长文本把灵动岛撑变形
                    }
                    .padding(.leading, 8)
                    .padding(.top, 10)
                }
                
                // 展开状态右侧：自动倒计时数字
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(timerInterval: context.state.startTime...context.state.endTime, countsDown: true)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(flutterColorString: context.state.colorHex))
                            .lineLimit(1)
                        Text("距离下班")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                    .padding(.top, 10)
                }
                
                // 展开状态底部：优雅的上下班时间进度条线
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        // 自动同步进度的 ProgressView，不耗 App 一分钱电
                        ProgressView(timerInterval: context.state.startTime...context.state.endTime, countsDown: false)
                            .tint(Color(flutterColorString: context.state.colorHex))
                            .background(Color(white: 0.2))
                            .scaleEffect(x: 1, y: 1.5, anchor: .center) // 进度条稍微加粗一点
                        
                        HStack {
                            Text(context.state.startTime.toHHmm())
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                            Spacer()
                            if context.state.shiftName.contains("加班") {
                                Text("🔥 辛苦了老哥")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.orange)
                            } else {
                                Text("奋斗中")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(context.state.endTime.toHHmm())
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                }
                
            } compactLeading: {
                // ==========================================
                // 🤏 紧凑状态左侧 (日常挂在顶部的简短文字)
                // ==========================================
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(flutterColorString: context.state.colorHex))
                        .frame(width: 8, height: 8)
                    Text(context.state.shiftName.prefix(2)) // 限制前两个字，防止爆框
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(flutterColorString: context.state.colorHex))
                }
                .padding(.leading, 4)
                
            } compactTrailing: {
                // ==========================================
                // ⏱️ 紧凑状态右侧 (日常挂在顶部的倒计时)
                // ==========================================
                Text(timerInterval: context.state.startTime...context.state.endTime, countsDown: true)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.trailing, 4)
                
            } minimal: {
                // ==========================================
                // 🔴 独立最小化状态 (多App抢岛时缩成的一个小圈圈)
                // ==========================================
                Circle()
                    .fill(Color(flutterColorString: context.state.colorHex))
                    .frame(width: 14, height: 14)
            }
            .widgetURL(URL(string: "dreamcalendar://island_click")) // 点击小岛通过 Scheme 唤醒 Dart 路由
            .keylineTint(Color(flutterColorString: context.state.colorHex)) // 灵动岛边缘发光圈跟随班次颜色
        }
    }
}

// ==========================================
// ⏰ 3️⃣ 扩展：时间格式化工具
// ==========================================
extension Date {
    func toHHmm() -> String {
        let formatter = DateFormatter()
        let ChineseLocale = Locale(identifier: "zh_CN")
        formatter.locale = ChineseLocale
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

// ==========================================
// 🎨 4️⃣ 扩展：智能解析 Flutter 传过来的颜色字符串
// ==========================================
extension Color {
    init(flutterColorString colorString: String) {
        // 🟢 情况 A：如果是纯十进制数字字符串（即 Dart 的 color.value.toString()，如 "4294943027"）
        if let decimalValue = UInt64(colorString) {
            // Flutter 的 Color.value 内部排布是 ARGB 格式：
            // 最高的 8 位是 Alpha，然后是 Red，Green，最后 8 位是 Blue
            let a = Double((decimalValue >> 24) & 0xFF) / 255.0
            let r = Double((decimalValue >> 16) & 0xFF) / 255.0
            let g = Double((decimalValue >> 8) & 0xFF) / 255.0
            let b = Double(decimalValue & 0xFF) / 255.0
            
            self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
            return
        }
        
        // 🟡 情况 B：保留十六进制备用解析（如以 "#FF5733" 或 "FF5733" 传入）
        let hex = colorString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF) // ARGB 格式
        default: (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
