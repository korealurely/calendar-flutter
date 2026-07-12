import UIKit
import Flutter
import EventKit // 🎯 引入苹果官方日历框架
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate, CalendarHostApi, LiveActivityHostApi{ // 🚀 1. 遵循 Pigeon 生成的 CalendarHostApi 协议
    
    var currentActivity : Any? = nil
    
    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            
            // 1. 绑定系统日历通道
            CalendarHostApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: self)
            
            // 🚨 2. 【核心修复】把灵动岛的通道也绑上！
            // 提示：根据你 Pigeon 的具体生成命名，也有可能是 LiveActivityHostApi.setUp(...)
            // 你先写 LiveActivityHostApiSetup.setUp 试试，如果编译器报错，就换成 LiveActivityHostApi.setUp
            LiveActivityHostApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: self)
            
            GeneratedPluginRegistrant.register(with: self)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    
    /**
     * 🚀 3. 实现 Pigeon 接口方法
     * 入参 `shifts` 已经是解析好的强类型 `[PigeonShift]` 数组，字段干净安全
     */
    func syncShiftsToSystem(shifts: [PigeonShift], completion: @escaping (Result<Bool, Error>) -> Void) {
        //startIsland()
        // 开启 Swift 并发 Task 异步处理，不卡死主线程
        Task {
            let success = await self.insertEventsToIOSCalendar(shifts: shifts)
            // 🚀 4. 通过 Result 强类型回调将结果传回 Dart
            completion(.success(success))
        }
    }
    
    /**
     * 🛠️ 精准解决当天深夜班次（例如 18:00 - 00:00）的兼容写入方法
     */
    private func insertEventsToIOSCalendar(shifts: [PigeonShift]) async -> Bool {
        if shifts.isEmpty { return true }
        
        let eventStore = EKEventStore()
        var isGranted = false
        
        do {
            if #available(iOS 17.0, *) {
                isGranted = try await eventStore.requestFullAccessToEvents()
            } else {
                isGranted = try await eventStore.requestAccess(to: .event)
            }
        } catch {
            return false
        }
        
        guard isGranted else { return false }
        guard let defaultCalendar = eventStore.defaultCalendarForNewEvents else { return false }
        
        var minTimeMs: Double = Date().timeIntervalSince1970 * 1000
        var maxTimeMs: Double = Date().timeIntervalSince1970 * 1000
        
        var parsedShifts: [(title: String, start: Date, end: Date, desc: String)] = []
        let sysCalendar = Calendar.current
        
        for (index, shift) in shifts.enumerated() {
            // 💡 重点：由于 Pigeon 帮我们完成了强类型对齐，这里可以直接取值，省去了繁琐的 Dict 强转和零值判断
            let title = shift.title
            let startMs = Double(shift.startTimeMills)
            let endMs = Double(shift.endTimeMills)
            
            if index == 0 {
                minTimeMs = startMs
                maxTimeMs = endMs
            } else {
                if startMs < minTimeMs { minTimeMs = startMs }
                if endMs > maxTimeMs { maxTimeMs = endMs }
            }
            
            let startDate = Date(timeIntervalSince1970: startMs / 1000.0)
            var endDate = Date(timeIntervalSince1970: endMs / 1000.0)
            
            // 🎯【核心保留】针对 18:00 - 00:00 这种结束时间卡在午夜的班次微调
            let endComponents = sysCalendar.dateComponents([.hour, .minute], from: endDate)
            
            if endComponents.hour == 0 && endComponents.minute == 0 {
                if endDate <= startDate {
                    endDate = startDate.addingTimeInterval((24 - Double(sysCalendar.component(.hour, from: startDate))) * 3600 - 1)
                } else {
                    endDate = endDate.addingTimeInterval(-1)
                }
            }
            
            // 兜底校验
            if endDate <= startDate {
                endDate = startDate.addingTimeInterval(6 * 3600)
            }
            
            parsedShifts.append((
                title: title,
                start: startDate,
                end: endDate,
                desc: shift.description
            ))
        }
        
        // 精准去重范围
        let searchStart = Date(timeIntervalSince1970: (minTimeMs / 1000.0) - 86400)
        let searchEnd = Date(timeIntervalSince1970: (maxTimeMs / 1000.0) + 86400)
        
        let predicate = eventStore.predicateForEvents(withStart: searchStart, end: searchEnd, calendars: [defaultCalendar])
        let existingEvents = eventStore.events(matching: predicate)
        
        for event in existingEvents {
            if let notes = event.notes, notes.contains("dream_calendar@joe.com") {
                try? eventStore.remove(event, span: .thisEvent, commit: false)
            }
        }
        
        // 批量安全插入
        for shift in parsedShifts {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.title = shift.title
            newEvent.startDate = shift.start
            newEvent.endDate = shift.end
            newEvent.notes = shift.desc + "\n[Origin: dream_calendar@joe.com]"
            newEvent.calendar = defaultCalendar
            
            try? eventStore.save(newEvent, span: .thisEvent, commit: false)
        }
        
        // 原子落盘提交
        do {
            try eventStore.commit()
            return true
        } catch {
            return false
        }
    }
    
    func startOrUpdateIsland(data: PigeonShiftIslandData) throws {
        print("📥 iOS 原生收到 Flutter 排班数据: \(data.shiftName), 颜色: \(data.colorHex)")
        if #available(iOS 16.2, *){
            Task(priority: .userInitiated){
                let attributes = ShiftIslandAttributes(id:String(Date().timeIntervalSince1970))
                let start = Date(timeIntervalSince1970: Double(data.startTimeMills) / 1000.0)
                var end = Date(timeIntervalSince1970: Double(data.endTimeMills) / 1000.0)
                let sysCalendar = Calendar.current
                
                // 🎯【核心保留】针对 18:00 - 00:00 这种结束时间卡在午夜的班次微调
                let endComponents = sysCalendar.dateComponents([.hour, .minute], from: end)
                
                if endComponents.hour == 0 && endComponents.minute == 0 {
                    if end <= start {
                        end = start.addingTimeInterval((24 - Double(sysCalendar.component(.hour, from: start))) * 3600 - 1)
                    } else {
                        end = end.addingTimeInterval(-1)
                    }
                }
                
                // 兜底校验
                if end <= start {
                    end = start.addingTimeInterval(6 * 3600)
                }
                
                
                let initialState = ShiftIslandAttributes.ContentState(
                    shiftName: data.shiftName,
                    startTime: start,
                    endTime: end,
                    colorHex: data.colorHex
                )
                let content = ActivityContent(state:initialState,staleDate: nil)
                
                do{
                    if let activeActivity = self.currentActivity as? Activity<ShiftIslandAttributes>{
                        await activeActivity.end(dismissalPolicy: .immediate)
                    }
                    
                    let activity = try Activity<ShiftIslandAttributes>.request(
                        attributes: attributes,
                        content: content,
                        pushType: nil
                    )
                    
                    await MainActor.run{
                        self.currentActivity = activity
                        print("🎉 灵动岛在后台成功绽放！")
                    }
                }catch {
                    print("❌ 灵动岛点火失败: \(error.localizedDescription)")
                }
            }
        }else{
            print("📱 当前系统低于 iOS 16.2，为了用户体验，静默忽略灵动岛")
        }
    }
    
    func stopIsland() throws {
        print("📴 收到 Flutter 熄火指令")
        if #available(iOS 16.2, *){
            Task{
                if let activeActivity = self.currentActivity as? Activity<ShiftIslandAttributes>{
                    await activeActivity.end(dismissalPolicy: .immediate)
                    
                    await MainActor.run{
                        self.currentActivity = nil
                        print("✅ 灵动岛已成功安全撤退")
                    }
                }
            }
        }
    }
 
}
