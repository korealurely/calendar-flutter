# Flutter Calendar & Health (班表与健康助手)

一个集成了专业**班表管理**与**智能体重监控**的 Flutter 应用。它不仅能帮助倒班人群管理复杂的排班计划，还能通过蓝牙连接智能体脂秤，实现一站式的健康管理。

## 🌟 核心功能

### 1. 班表管理 (Shift Management)
- **高度自定义**：支持自定义班次名称、颜色、工作时长及备注。
- **循环排班模式**：灵活配置“四班三倒”、“两班倒”等复杂循环模式，一键生成长期排班表。
- **日历可视化**：在日历视图中直观展示每日班次，支持快速修改与备注查看。
- **工时统计**：自动计算月度工时与班次分布，通过图表直观展示工作强度。

### 2. 智能健康监控 (Health Tracking)
- **蓝牙设备接入 (BLE)**：深度适配 **小米/华米体脂秤 2 (MIBFS)**。
- **自动化测量**：应用自动扫描并解析蓝牙广播，无需手动记录，踩秤即测，自动同步体重与阻抗数据。
- **数据流清洗**：内置基于 Stream 的 Reactive 数据清洗机制，确保只记录锁定后的稳定有效测量数据。
- **健康统计分析**：基于 **fl_chart** 展示体重变化曲线，帮助用户掌握身体状态。

### 3. 物联网连接 (IoT Connectivity)
- **MQTT 协议支持**：支持将测量数据实时推送到自定义的 MQTT Broker，方便接入个人家庭自动化系统（如 Home Assistant）。

## 🛠️ 技术栈

- **核心框架**：[Flutter](https://flutter.dev/) (Channel Stable)
- **状态管理**：[Riverpod 2.0](https://riverpod.dev/) (结合 `riverpod_generator`)
- **本地数据库**：[Isar](https://isar.dev/) (高性能 NoSQL，支持多表关联与流式监听)
- **蓝牙通信**：[flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus)
- **网络通信**：[mqtt_client](https://pub.dev/packages/mqtt_client)
- **数据可视化**：[fl_chart](https://pub.dev/packages/fl_chart)

## 📂 项目结构

```text
lib/
├── data/          # 数据模型 (ShiftConfig, CalendarWeight, StatItem)
├── repository/    # 核心逻辑 (BleManager, MqttManager, WeightRepository)
├── provider/      # Riverpod 状态提供者 (ViewModel 层)
├── view/          # 自定义 UI 组件 (日历格、统计图表等)
├── pages/         # 功能页面 (日历页、体重页、排班设置页)
└── utils/         # 工具类 (日期处理 DateUtil、颜色转换等)
```

## 🚀 快速开始

### 1. 环境依赖
- Flutter SDK: `^3.12.0`
- Dart SDK: `^3.0.0`
- 已配置好 Android/iOS 开发环境

### 2. 初始化项目
```bash
# 克隆仓库
git clone https://gitee.com/lurely/calendar-flutter.git
cd flutter_calendar

# 获取依赖包
flutter pub get

# 运行代码生成 (Isar & Riverpod 必要步骤)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 运行应用
```bash
flutter run
```

## 🔐 权限说明
- **蓝牙/定位**：Android 端扫描蓝牙设备需要开启定位权限（Android 12 以下）或蓝牙扫描权限（Android 12 及以上）。
- **存储**：用于 Isar 数据库的本地持久化。

## 📄 许可证

本项目遵循 MIT 许可证。
