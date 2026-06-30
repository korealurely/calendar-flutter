import 'package:flutter/material.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/data/shift_pattern.dart';
import 'package:flutter_calendar/provider/shift_pattern_provider.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/data/shift_config.dart';

// 🚀 完美的 Diff 动画库
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';

class ShiftPatternPage extends ConsumerWidget {
  const ShiftPatternPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternListSync = ref.watch(shiftPatternViewModelProvider);

    return Scaffold(
      // 现代感的高级淡灰背景
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          "周期模式管理",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F1F1F)),
        ),
        leading: IconButton(onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20,)),
        centerTitle: true,
        // 居中导航栏更具高级感
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        // 给 AppBar 底部加一条极淡的分割线，层次感拉满
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: const Color(0xFFE5E5E5), height: 0.5),
        ),
      ),
      body: patternListSync.when(
        data: (dbList) {
          if (dbList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_outlined, size: 48,
                      color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  const Text(
                    "暂无模式配置，点击下方按钮添加",
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  ),
                ],
              ),
            );
          }
          return ImplicitlyAnimatedList<ShiftPattern>(
            items: dbList,
            // 🎯 上下留白，底部强行留出 96 像素，完美避开 FloatingActionButton 遮挡！
            padding: const EdgeInsets.only(top: 14, bottom: 96),
            physics: const BouncingScrollPhysics(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            itemBuilder: (context, animation, pattern, index) {
              return SizeFadeTransition(
                sizeFraction: 0.8,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildPatternCard(
                    context, ref, pattern, isShadow: false),
              );
            },
            removeItemBuilder: (context, animation, pattern) {
              return SizeFadeTransition(
                sizeFraction: 0.8,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildPatternCard(context, ref, pattern, isShadow: true),
              );
            },
          );
        },
        error: (error, _) =>
            Center(
              child: Text("加载失败: $error",
                  style: const TextStyle(color: Colors.red)),
            ),
        loading: () =>
        const Center(child: CircularProgressIndicator(
            strokeWidth: 3, color: Colors.blue)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("老哥点击了添加班次周期模式");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                _buildAddElementBottomSheet(context, ref, null),
          );
        },
        backgroundColor: Colors.blue,
        elevation: 4,
        highlightElevation: 2,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text(
          "添加周期模式",
          style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5),
        ),
      ),
    );
  }

  /// 👑 2026年极致质感卡片布局重构
  Widget _buildPatternCard(BuildContext context,
      WidgetRef ref,
      ShiftPattern pattern, {
        bool isShadow = false,
      }) {
    // 根据模式类型，定义精致微标签的色系
    final bool isFixedWeekly = pattern.patternType == 0;
    final Color tagBgColor = isFixedWeekly
        ? const Color(0xFFFEEFEE)
        : const Color(0xFFE8F4FF);
    final Color tagTextColor = isFixedWeekly
        ? const Color(0xFFFA5151)
        : const Color(0xFF0052D9);
    final String tagText = isFixedWeekly ? "固定周" : "自定义";

    return Padding(
      key: ValueKey(pattern.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isShadow
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.04), width: 0.8),
            ),
            child: InkWell(
              onTap: () {
                print("老哥点击了模式卡片：${pattern.id}");
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      _buildAddElementBottomSheet(context, ref, pattern),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // 抛弃 ListTile，全面采用高自由度 Padding 布局
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 第一层：日期标题 + 模式类型微标签并排
                    Row(
                      children: [
                        // 1. 核心日期区间：用 Expanded + FittedBox 锁死单行，等比例无损缩放，誓死不换行！
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${pattern.startDate}  ~  ${pattern.endDate}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1F1F1F),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 2. 模式微型轻量标签（取代原本粗笨的方块）
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8,
                              vertical: 3),
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tagText,
                            style: TextStyle(color: tagTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    // 🌟 黄金分割线/间距
                    const SizedBox(height: 14),
                    Container(height: 0.8, color: const Color(0xFFF5F5F5)),
                    const SizedBox(height: 12),

                    // 🌟 第二层：时钟图标 + 班次流式标签仓
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3.5), // 像素级微调，完美对齐首行标签
                          child: Icon(Icons.schedule_outlined, size: 14,
                              color: Color(0xFF8C8C8C)),
                        ),
                        const SizedBox(width: 8),

                        // 3. 右侧流式胶囊群（自带无感知丝滑换行，拒绝一刀切省略号）
                        Expanded(
                          child: pattern.shiftConfigs.isEmpty
                              ? const Text(
                            "暂未配置具体班次",
                            style: TextStyle(
                                color: Color(0xFF8C8C8C), fontSize: 13),
                          )
                              : Wrap(
                            spacing: 6, // 胶囊左右间距
                            runSpacing: 6, // 换行后的上下间距
                            children: pattern.shiftConfigs.map((item) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FA),
                                  // 高级微灰底色
                                  borderRadius: BorderRadius.circular(6),
                                  // 🎯 终极修正：用 Border.all 把你的 BorderSide 属性完美包装起来！
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    // 极淡边框
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Color(0xFF434343),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddElementBottomSheet(BuildContext context, WidgetRef ref, ShiftPattern? pattern) {
    // 🎯 1. 用 ref.read 采取买断快照策略。因为老哥说打开弹窗期间配置表不会变，
    // 这样直接免去了外面页面 Rebuild 连带导致弹窗重构的后顾之忧。
    final configList = ref.read(shiftConfigViewModelProvider).value ?? <ShiftConfig>[];


    if (configList.isEmpty) {
      print("警告：数据库中暂无具体班次配置，Spinner可能为空");
    }

    // 🎯 2. 将状态和状态锁声明在 StatefulBuilder 外部作为闭包变量，方便内部持久访问
    int? selectedMode;
    DateTime? startDate;
    DateTime? endDate;
    Map<int, int?>? weeklySelection;
    List<int>? customShiftIds;
    bool isInitialized = false; // 🔑 生命周期的定海神针锁

    bool isErrorMsg = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {

        // 🎯 🚀 【核心手术】：挪到 builder 内部的第一行，并且用一把锁死死守住！
        if (!isInitialized) {
          selectedMode = pattern != null ? pattern.patternType : 0;
          startDate = pattern != null ? DateTime.parse(pattern.startDate) : DateTime.now();
          endDate = pattern != null ? DateTime.parse(pattern.endDate) : DateTime.now().add(const Duration(days: 7));

          // 初始化周固定循环字典
          if (pattern != null && pattern.patternType == 0) {
            weeklySelection = {
              1: pattern.shiftConfigIds[0],
              2: pattern.shiftConfigIds[1],
              3: pattern.shiftConfigIds[2],
              4: pattern.shiftConfigIds[3],
              5: pattern.shiftConfigIds[4],
              6: pattern.shiftConfigIds[5],
              7: pattern.shiftConfigIds[6],
            };
          } else {
            // 兜底：如果没传 pattern，默认拿数据库里的第一个班次填满周一到周日
            weeklySelection = {
              1: configList.isNotEmpty ? configList.first.id : null,
              2: configList.isNotEmpty ? configList.first.id : null,
              3: configList.isNotEmpty ? configList.first.id : null,
              4: configList.isNotEmpty ? configList.first.id : null,
              5: configList.isNotEmpty ? configList.first.id : null,
              6: configList.isNotEmpty ? configList.first.id : null,
              7: configList.isNotEmpty ? configList.first.id : null,
            };
          }

          // 初始化自定义追加队列
          customShiftIds = pattern != null && pattern.patternType == 1
              ? pattern.shiftConfigIds.toList()
              : [];


          isInitialized = true; // 🔑 首次跑完立马锁死！以后弹窗内随便调用 setModalState 也绝不复原！
        }

        // 3. 动态计算格式化后的日期文本（时刻盯着内存里的局部变量）
        final String formatStart = "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
        final String formatEnd = "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),

                // ==================== 第一行：模式选择切换 ====================
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 0, label: Text("周固定模式", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          ButtonSegment(value: 1, label: Text("自定义模式", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                        ],
                        selected: {selectedMode!},
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: Colors.blue,
                          selectedForegroundColor: Colors.white,
                          foregroundColor: const Color(0xFF606266),
                          side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onSelectionChanged: (newSelection) {
                          setModalState(() => selectedMode = newSelection.first);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ==================== 第二行：条件联动内容区 ====================
                if (selectedMode == 0) ...[
                  const Text("配置一周七天循环班次", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final weekDay = index + 1;
                        final List<String> weekTitles = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"];
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 8, bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(weekTitles[weekDay], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: DropdownButton<int>(
                                  value: weeklySelection![weekDay],
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                                  icon: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.blue),
                                  items: configList.map((config) { // 🚀 换成全局快照列表
                                    return DropdownMenuItem<int>(value: config.id, child: Text(config.name));
                                  }).toList(),
                                  onChanged: (val) {
                                    setModalState(() => weeklySelection![weekDay] = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  const Text("自由定义排班顺序（从左往右按顺序循环）", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...customShiftIds!.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final configId = entry.value;
                        final targetConfig = configList.where((e) => e.id == configId).firstOrNull; // 🚀 换成全局快照列表
                        return Chip(
                          label: Text(targetConfig?.name ?? "未知班次", style: const TextStyle(fontSize: 12)),
                          backgroundColor: const Color(0xFFE8F4FF),
                          labelStyle: const TextStyle(color: Colors.blue),
                          padding: EdgeInsets.zero,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          deleteIcon: const Icon(Icons.cancel, size: 14, color: Colors.blue),
                          onDeleted: () {
                            setModalState(() => customShiftIds!.removeAt(idx));
                          },
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(6)),
                        child: DropdownButton<int>(
                          hint: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 14, color: Colors.grey),
                              Text("追加", style: TextStyle(fontSize: 12, color: Colors.grey))
                            ],
                          ),
                          underline: const SizedBox(),
                          icon: const SizedBox(),
                          items: configList.map<DropdownMenuItem<int>>((config) { // 🚀 换成全局快照列表
                            return DropdownMenuItem<int>(value: config.id, child: Text(config.name, style: const TextStyle(fontSize: 13)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => customShiftIds!.add(val));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),

                // ==================== 第三行：固定日期区间选择 ====================
                const Text("生效日期范围", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picker = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: endDate ?? DateTime(2030));
                          if (picker != null) {
                            setModalState(() => startDate = picker);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatStart, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("至", style: TextStyle(color: Colors.grey))),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picker = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? startDate ?? DateTime.now(),
                              firstDate:startDate ?? DateTime(2020),
                              lastDate: DateTime(2030));
                          if (picker != null) {
                            setModalState(() => endDate = picker);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatEnd, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                if(isErrorMsg)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "⚠️ 请选择一个自定义排班！",
                      style: const TextStyle(color: Colors.redAccent,fontSize: 13,fontWeight: FontWeight.bold),
                    ),
                  ),
                // ==================== 第四行：取消、删除、确定生成按钮 ====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (pattern != null) ...[
                      OutlinedButton(
                        onPressed: () {
                          print("老哥点击了删除/重置按钮");
                          Navigator.pop(context);
                          _confirmDelete(context, ref, pattern);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFA5151)),
                          foregroundColor: const Color(0xFFFA5151),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        child: const Text("删除", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F2F5),
                          foregroundColor: const Color(0xFF606266),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("取消", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          print("模式: $selectedMode, 开始: $formatStart, 结束: $formatEnd");
                          if (selectedMode == 0) {
                            print("固定周选值: $weeklySelection");
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern,
                                patternType: selectedMode!,
                                startDate: formatStart,
                                endDate: formatEnd,
                                shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList());
                            Navigator.pop(context);
                          } else {
                            print("自由添加队列: $customShiftIds");
                            if(customShiftIds == null || customShiftIds!.isEmpty){
                              setModalState(() {
                                isErrorMsg = true;
                              });
                              return;
                            }

                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern,
                                patternType: selectedMode!,
                                startDate: formatStart,
                                endDate: formatEnd,
                                shiftConfigIds: customShiftIds!);
                            Navigator.pop(context);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("模式生成", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          print("模式: $selectedMode, 开始: $formatStart, 结束: $formatEnd");
                          if (selectedMode == 0) {
                            print("固定周选值: $weeklySelection");
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern,
                                patternType: selectedMode!,
                                startDate: formatStart,
                                endDate: formatEnd,
                                shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList());

                            final startDateTime = DateTime.parse(formatStart);
                            await ref.read(shiftViewModelProvider(startDateTime.year, startDateTime.month).notifier).generateShifts(
                              startDate: formatStart,
                              endDate: formatEnd,
                              patternType: selectedMode!,
                              shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList(),
                            );
                            Navigator.pop(context);
                          } else {
                            print("自由添加队列: $customShiftIds");
                            if(customShiftIds == null || customShiftIds!.isEmpty){
                              setModalState(() {
                                isErrorMsg = true;
                              });
                              return;
                            }
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern,
                                patternType: selectedMode!,
                                startDate: formatStart,
                                endDate: formatEnd,
                                shiftConfigIds: customShiftIds!);

                            final startDateTime = DateTime.parse(formatStart);
                            await ref.read(shiftViewModelProvider(startDateTime.year, startDateTime.month).notifier).generateShifts(
                              startDate: formatStart,
                              endDate: formatEnd,
                              patternType: selectedMode!,
                              shiftConfigIds: customShiftIds!,
                            );
                            Navigator.pop(context);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("排班生成", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      ShiftPattern pattern) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: const Text("确认删除"),
            content: Text("确定要删除吗？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("算了"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await ref
                      .read(shiftPatternViewModelProvider.notifier)
                      .deleteShiftPatternById(pattern.id);
                },
                child: Text("删除", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
