# Flutter Calendar (班表日历)

一个基于 Flutter 开发的专业班表管理与日历应用。旨在帮助用户高效地管理倒班、排班以及个人行程，支持多种自定义配置与本地数据持久化。

## ✨ 主要功能

- **智能班表管理**：轻松创建、修改和查看复杂的班表计划。
- **排班模式预设**：支持定义循环排班模式，一键生成长期的班次预览。
- **极致日历视图**：丝滑的月份视图切换，清晰展示每日工作与生活。
- **本地化存储**：采用高性能的 **Isar** 数据库，确保数据安全且响应迅速。
- **数据统计分析**：内置 **fl_chart**，直观展示工作时长、班次分布等统计信息。
- **硬件连接支持**：支持 **Bluetooth (BLE)** 与 **MQTT** 协议，具备与物联网设备交互的潜力。
- **个性化设置**：内置取色器（flutter_colorpicker），支持自定义班次颜色与应用主题。

## 🛠️ 技术栈

- **框架**：[Flutter](https://flutter.dev/)
- **状态管理**：[Riverpod 2.x](https://riverpod.dev/) (使用代码生成器 `riverpod_generator`)
- **数据库**：[Isar](https://isar.dev/) (高性能 NoSQL 数据库)
- **图表**：[fl_chart](https://pub.dev/packages/fl_chart)
- **网络/通信**：[mqtt_client](https://pub.dev/packages/mqtt_client), [flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus)
- **工具库**：[intl](https://pub.dev/packages/intl), [permission_handler](https://pub.dev/packages/permission_handler)

## 🚀 快速开始

### 环境要求

- Flutter SDK: `^3.12.0`
- Dart SDK: `^3.0.0`

### 安装与运行

1. **克隆仓库**
   ```bash
   git clone https://github.com/your-username/flutter_calendar.git
   cd flutter_calendar
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **代码生成**
   本工程使用了 `build_runner` 进行 Riverpod 和 Isar 的代码生成，运行前请执行：
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **运行应用**
   ```bash
   flutter run
   ```

## 📂 项目结构

```text
lib/
├── data/          # 数据模型与常量定义
├── provider/      # Riverpod 状态管理逻辑
├── repository/    # 数据库访问与数据处理层
├── view/          # 通用 UI 组件与自定义视图 (如 MonthGridView)
├── pages/         # 页面路由与主页面 UI (如 MyPage)
└── main.dart      # 应用入口
```

## 📄 许可证

本项目遵循 MIT 许可证。
