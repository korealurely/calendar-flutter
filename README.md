# Flutter Calendar & Health (班表与健康助手)

一个集成了专业**班表管理**与**智能健康监控**的 Flutter 应用。专为倒班人群设计，不仅能轻松管理复杂的排班计划，还能通过蓝牙连接智能体脂秤，实现一站式的身体数据追踪与健康分析。

## 🌟 核心功能

### 1. 班表管理 (Shift Management)
- **高度自定义班次**：自由配置班次名称、颜色、工作时长（起始/结束时间）及备注。
- **循环排班模式 (Shift Pattern)**：
  - **周期性排班**：支持“四班三倒”、“两班倒”等自定义序列，一键生成长期排班表。
  - **固定周模式**：按周设定重复班次（如固定周一至周五白班，周末休息）。
  - **一键批量生成**：支持指定日期区间，根据预设模式自动填充日历，大幅减少手动录入工作量。
- **极致日历视图**：支持月份平滑切换，日历格直观显示班次信息（名称、颜色标识）及当日健康测量状态。
- **动态编辑**：点击日历格即可快速修改、删除单日班次或配置闹钟。

### 2. 智能健康监控 (Health Tracking)
- **蓝牙设备接入 (BLE)**：深度适配 **小米/华米体脂秤 2 (MIBFS)**。
- **自动化测量流程**：应用自动扫描并解析蓝牙广播，无需手动记录。支持“踩秤即测”，自动同步体重、阻抗（体脂相关数据）及测量时间。
- **Reactive 数据清洗**：内置基于 Dart Stream 的数据清洗机制，智能识别测量锁定状态，仅记录稳定有效的测量数据，排除波动干扰。
- **多维度历史记录**：按日记录多次测量数据，自动计算当日平均、最高及最低体重。

### 3. 数据可视化统计 (Statistics & Charts)
- **班次分布分析**：通过**环形饼图**展示当月各班次占比，掌握工作强度分布。
- **体重趋势曲线**：基于 **fl_chart** 展示月度体重变化波动，直观感知健康趋势。
- **工时统计柱状图**：精确统计并展示每日工作时长分布，量化个人辛劳程度。

### 4. 物联网与扩展 (IoT & Integration)
- **MQTT 数据同步**：支持将实时测得的体重/阻抗数据通过 MQTT 协议推送到个人服务器或家庭自动化中心（如 Home Assistant）。
- **深色模式支持**：全界面适配 Dark Mode，在夜间使用时更加护眼且具有高质感。
- **国际化 (L10n)**：完善的多语言支持，内置多国语言包。

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

- **核心框架**：[Flutter](https://flutter.dev/) (Channel Stable)
- **状态管理**：[Riverpod 2.0](https://riverpod.dev/) (结合 `riverpod_generator` 提升开发体验与类型安全)
- **本地数据库**：[Isar](https://isar.dev/) (超高性能 NoSQL，支持多表关联、索引与流式监听)
- **蓝牙通信**：[flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus)
- **网络通信**：[mqtt_client](https://pub.dev/packages/mqtt_client)
- **数据可视化**：[fl_chart](https://pub.dev/packages/fl_chart)
- **动画增强**：`implicitly_animated_reorderable_list_2` 实现丝滑的列表增删效果。

## 📂 项目结构

```text
lib/
├── data/          # 数据模型定义 (ShiftConfig, CalendarWeight, WorkTimeStat 等)
├── repository/    # 数据访问层 (BleManager, MqttManager, IsarRepository)
├── provider/      # Riverpod 状态提供者 (ViewModel 与业务逻辑中心)
├── view/          # 自定义 UI 组件 (日历 MonthGridView、各类 ChartCard 等)
├── pages/         # 顶层功能页面 (CalendarPage, ChartPage, ShiftPatternPage 等)
├── utils/         # 实用工具类 (日期处理 DateUtil, 颜色转换等)
└── l10n/          # 国际化翻译文件
```

## 🚀 快速开始

### 1. 环境准备
- Flutter SDK: `^3.12.0`
- Dart SDK: `^3.0.0`
- 已配置 Android/iOS 物理机或模拟器（蓝牙功能需真机测试）

### 2. 初始化项目
```bash
# 获取依赖
flutter pub get

# 运行代码生成器 (Isar 实体类与 Riverpod 脚本必要步骤)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 蓝牙权限
- **Android**: 需在设置中开启位置信息与蓝牙权限。
- **iOS**: 需在 `Info.plist` 中声明蓝牙使用描述。

## 📄 许可证

本项目遵循 MIT 许可证。
