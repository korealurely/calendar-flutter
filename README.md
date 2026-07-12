# Flutter Calendar & Health (班表与健康助手)

一个集成了专业**班表管理**与**智能健康监控**的 Flutter 应用。专为倒班人群设计，不仅能轻松管理复杂的排班计划，还能实现与系统日历同步及 iOS 灵动岛显示，同时通过蓝牙连接智能体脂秤，提供一站式的健康分析。

## 🌟 核心功能

### 1. 班表管理 (Shift Management)
- **高度自定义班次**：自由配置班次名称、颜色、工作时长（起始/结束时间）及备注。
- **循环排班模式 (Shift Pattern)**：
  - **周期性排班**：支持“四班三倒”、“两班倒”等自定义序列，一键生成长期排班表。
  - **固定周模式**：按周设定重复班次（如固定周一至周五白班，周末休息）。
  - **一键批量生成**：支持指定日期区间，根据预设模式自动填充日历，大幅减少手动录入。
- **极致日历视图**：支持月份平滑切换，日历格直观显示班次信息、颜色标识及当日健康测量状态。

### 2. 系统深度集成 (Native Integration) 🔥
- **系统日历同步**：支持一键将应用内所有班次计划同步至 iOS/Android 系统日历，支持日程提醒，防止遗忘工作安排。
- **iOS 灵动岛与实时活动 (Live Activities)**：深度适配 iOS，支持在**灵动岛 (Dynamic Island)** 和锁屏界面实时显示当前班次信息、剩余工作时间等，无需解锁手机即可掌握进度。
- **Pigeon 通信**：采用高性能的 Pigeon 插件化方案实现 Dart 与 Native 的类型安全通信，确保同步过程稳定可靠。

### 3. 智能健康监控 (Health Tracking)
- **蓝牙设备接入 (BLE)**：深度适配 **小米/华米体脂秤 2 (MIBFS)**，应用自动扫描并解析广播数据。
- **自动化测量流程**：支持“踩秤即测”，自动同步体重、阻抗（体脂数据）及测量时间，内置 Reactive 数据清洗机制，确保只记录锁定后的稳定数据。
- **多维度历史记录**：自动计算当日平均、最高及最低体重，支持查看完整的测量时间线。

### 4. 数据统计与物联网 (IoT & Stats)
- **多维统计图表**：基于 **fl_chart** 展示班次占比饼图、体重趋势曲线及工时统计柱状图。
- **MQTT 实时推送**：支持将体重/阻抗数据通过 MQTT 协议实时推送到个人服务器或 Home Assistant，完美接入智能家居生态。
- **个性化体验**：全界面适配 **Dark Mode (深色模式)**，支持多国语言国际化 (L10n)。

## 📸 界面预览

|                    首页预览                    |                 首页预览 (夜间)                  |                    排班管理                    |
|:------------------------------------------:|:------------------------------------------:|:------------------------------------------:|
| <img src="screenshot/p8.jpeg" width="250"> | <img src="screenshot/p9.jpeg" width="250"> | <img src="screenshot/p6.jpeg" width="250"> |

|                    模式设置                    |                    排班生成                    |                    数据统计                    |
|:------------------------------------------:|:------------------------------------------:|:------------------------------------------:|
| <img src="screenshot/p3.jpeg" width="250"> | <img src="screenshot/p5.jpeg" width="250"> | <img src="screenshot/p4.jpeg" width="250"> |

|                    班次编辑                    |                   颜色自定义                    |                   多语言支持                    |
|:------------------------------------------:|:------------------------------------------:|:------------------------------------------:|
| <img src="screenshot/p2.jpeg" width="250"> | <img src="screenshot/p7.jpeg" width="250"> | <img src="screenshot/p1.jpeg" width="250"> |

## 🛠️ 技术栈

- **核心框架**：[Flutter](https://flutter.dev/) (Riverpod 2.x + Generator)
- **Native 通信**：[Pigeon](https://pub.dev/packages/pigeon) (实现 Calendar API & Live Activity API)
- **数据库**：[Isar](https://isar.dev/) (高性能 NoSQL 本地存储)
- **连接协议**：[flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus) (BLE), [mqtt_client](https://pub.dev/packages/mqtt_client)
- **数据可视化**：[fl_chart](https://pub.dev/packages/fl_chart)

## 🚀 快速开始

1. **环境准备**：Flutter SDK `^3.12.0`，已配置 iOS/Android 原生开发环境。
2. **安装依赖**：运行 `flutter pub get`。
3. **代码生成**：**必须**运行 `flutter pub run build_runner build --delete-conflicting-outputs` 以生成 Isar 和 Riverpod 的配套代码。
4. **运行**：连接真机（测试 BLE 和 Live Activity 功能必须使用真机），执行 `flutter run`。

## 📄 许可证

本项目遵循 MIT 许可证。
