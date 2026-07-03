import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
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
    // 🚀 【换装天眼】：提前抓取黑夜状态
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🚀 【优化 1】：大背景全自动换装（白天现代淡灰，黑夜自动收缩为夜间大底色）
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.patternManagement,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // 🚀 【优化 2】：消灭死色，标题跟随系统主题
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor, // 🚀 【优化 3】：导航栏底色完美感应
        elevation: 0,
        scrolledUnderElevation: 0,
        // 🚀 【优化 4】：AppBar 底部层次分割线自适应降噪
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFE5E5E5),
            height: 0.5,
          ),
        ),
      ),
      body: patternListSync.when(
        data: (dbList) {
          if (dbList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 48,
                    color: isDark ? Colors.white24 : Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.noPatternHint,
                    // 🚀 【优化 5】：空状态提示文字颜色深度柔和化
                    style: TextStyle(
                      color: isDark ? Colors.white38 : const Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }
          return ImplicitlyAnimatedList<ShiftPattern>(
            items: dbList,
            padding: const EdgeInsets.only(top: 14, bottom: 96),
            physics: const BouncingScrollPhysics(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            itemBuilder: (context, animation, pattern, index) {
              return SizeFadeTransition(
                sizeFraction: 0.8,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildPatternCard(context, ref, pattern, isShadow: false),
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
        error: (error, _) => Center(
          child: Text(
            "${AppLocalizations.of(context)!.loadErr} $error",
            // 🚀 【优化 6】：将刺眼的纯红换成在黑白底表现都极佳的柔和红
            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.blue),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //print("老哥点击了添加班次周期模式");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent, // 确保子弹窗圆角外壳不露白边
            builder: (context) => _buildAddElementBottomSheet(context, ref, null),
          );
        },
        backgroundColor: Colors.blue,
        elevation: 4,
        highlightElevation: 2,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label:  Text(
          AppLocalizations.of(context)!.addPattern,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
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
    // 🚀 【换装天眼 1】：抓取全局暗黑模式状态
    final isDark = Theme.of(context).brightness == Brightness.dark;

// 根据模式类型，定义精致微标签的色系
    final bool isFixedWeekly = pattern.patternType == 0;

// ☀️ 白天原本的颜色
    const Color lightRed = Color(0xFFFEEFEE);
    const Color lightBlue = Color(0xFFE8F4FF);
    const Color textRed = Color(0xFFFA5151);
    const Color textBlue = Color(0xFF0052D9);

// 🚀 核心：用标准的 .withValues 完美实现暗黑模式下的低饱和度标标签背景
    final Color tagBgColor = isFixedWeekly
        ? (isDark ? const Color(0xFFFA5151).withValues(alpha: 0.15) : lightRed)
        : (isDark ? const Color(0xFF0052D9).withValues(alpha: 0.15) : lightBlue);

// 🚀 暗黑模式下的文字颜色提亮（用更柔和的亮红/亮蓝，在黑底上极度清晰）
    final Color tagTextColor = isFixedWeekly
        ? (isDark ? const Color(0xFFFF7875) : textRed)
        : (isDark ? const Color(0xFF597EF7) : textBlue);

    final String tagText = isFixedWeekly ? AppLocalizations.of(context)!.weekPattern : AppLocalizations.of(context)!.custom;

    return Padding(
      key: ValueKey(pattern.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isShadow
              ? [
            BoxShadow(
              // 🚀 【优化 2】：阴影降噪
              color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ]
              : [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.black.withValues(alpha: 0.02),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.01),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            // 🚀 【优化 3】：核心承载色全面对接卡片主题色（白天纯白，黑夜高档深灰）
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04),
                  width: 0.8),
            ),
            child: InkWell(
              onTap: () {
                //print("老哥点击了模式卡片：${pattern.id}");
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 第一层：日期标题 + 模式类型微标签并排
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${pattern.startDate}  ~  ${pattern.endDate}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                // 🚀 【优化 4】：日期文字跟随主题自适应
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tagText,
                            style: TextStyle(
                                color: tagTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    // 🌟 黄金分割线/间距
                    const SizedBox(height: 14),
                    // 🚀 【优化 5】：卡片内部中横线暗黑隐形化
                    Container(
                        height: 0.8,
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF5F5F5)
                    ),
                    const SizedBox(height: 12),

                    // 🌟 第二层：时钟图标 + 班次流式标签仓
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.5),
                          child: Icon(
                            Icons.schedule_outlined,
                            size: 14,
                            // 🚀 【优化 6】：小图标灰色适度提亮
                            color: isDark ? Colors.white38 : const Color(0xFF8C8C8C),
                          ),
                        ),
                        const SizedBox(width: 8),

                        Expanded(
                          child: pattern.shiftConfigs.isEmpty
                              ? Text(
                            "暂未配置具体班次",
                            style: TextStyle(
                                color: isDark ? Colors.white38 : const Color(0xFF8C8C8C),
                                fontSize: 13),
                          )
                              : Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: pattern.shiftConfigs.map((item) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  // 🚀 【优化 7】：右侧流式班次胶囊底色适配
                                  color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF5F7FA),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    // 🚀 【优化 8】：胶囊文字自适应
                                    color: isDark ? Colors.white70 : const Color(0xFF434343),
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
    final configList = ref.read(shiftConfigViewModelProvider).value ?? <ShiftConfig>[];

    if (configList.isEmpty) {
      //print("警告：数据库中暂无具体班次配置，Spinner可能为空");
    }

    int? selectedMode;
    DateTime? startDate;
    DateTime? endDate;
    Map<int, int?>? weeklySelection;
    List<int>? customShiftIds;
    bool isInitialized = false;
    bool isErrorMsg = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        // 🚀 【换装天眼】：抓取全局暗黑状态
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (!isInitialized) {
          selectedMode = pattern != null ? pattern.patternType : 0;
          startDate = pattern != null ? DateTime.parse(pattern.startDate) : DateTime.now();
          endDate = pattern != null ? DateTime.parse(pattern.endDate) : DateTime.now().add(const Duration(days: 7));

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

          customShiftIds = pattern != null && pattern.patternType == 1
              ? pattern.shiftConfigIds.toList()
              : [];

          isInitialized = true;
        }

        final String formatStart = "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
        final String formatEnd = "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

        // 🚀 抽取暗黑复用的背景色系
        final containerBg = isDark ? const Color(0xFF25262B) : const Color(0xFFF5F7FA);
        final cancelBtnBg = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF0F2F5);
        final itemTextColor = Theme.of(context).textTheme.bodyLarge?.color;

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              // 🚀 【优化 1】：弹窗大背景全感应（白天纯白，夜间采用高档深灰）
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                        color: isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),

                // ==================== 第一行：模式选择切换 ====================
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<int>(
                        segments:  [
                          ButtonSegment(value: 0, label: Text(AppLocalizations.of(context)!.weekPattern, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          ButtonSegment(value: 1, label: Text(AppLocalizations.of(context)!.custom, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                        ],
                        selected: {selectedMode!},
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: Colors.blue,
                          selectedForegroundColor: Colors.white,
                          // 🚀 【优化 2】：未选中文字颜色，夜间提亮
                          foregroundColor: isDark ? const Color(0xFFA1A3A6) : const Color(0xFF606266),
                          side: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08)),
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
                  Text(AppLocalizations.of(context)!.weekSetLabel, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final weekDay = index + 1;
                        final List<String> weekTitles = ["",
                          AppLocalizations.of(context)!.mon1,
                          AppLocalizations.of(context)!.tue1,
                          AppLocalizations.of(context)!.wed1,
                          AppLocalizations.of(context)!.thu1,
                          AppLocalizations.of(context)!.fri1,
                          AppLocalizations.of(context)!.sat1,
                          AppLocalizations.of(context)!.sun1];
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 8, bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // 🚀 【优化 3】：自适应卡片项目微灰色底色
                            color: containerBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.03)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(weekTitles[weekDay], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: itemTextColor)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: DropdownButton<int>(
                                  value: weeklySelection![weekDay],
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  // 🚀 【优化 4】：Dropdown 文字和下拉弹窗背景主题化适配
                                  dropdownColor: Theme.of(context).cardColor,
                                  style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                                  icon: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.blue),
                                  items: configList.map((config) {
                                    return DropdownMenuItem<int>(
                                      value: config.id,
                                      child: Text(config.name, style: TextStyle(color: isDark ? Colors.white70 : Colors.black12, fontSize: 12)),
                                    );
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
                  Text(AppLocalizations.of(context)!.customShiftLabel, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...customShiftIds!.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final configId = entry.value;
                        final targetConfig = configList.where((e) => e.id == configId).firstOrNull;
                        return Chip(
                          label: Text(targetConfig?.name ?? AppLocalizations.of(context)!.unknownShift, style: const TextStyle(fontSize: 12)),
                          // 🚀 【优化 5】：已添加的胶囊标签在夜间微调饱和度，防止对比过载
                          backgroundColor: isDark ? const Color(0xFF0052D9).withValues(alpha: 0.15) : const Color(0xFFE8F4FF),
                          labelStyle: TextStyle(color: isDark ? const Color(0xFF597EF7) : Colors.blue, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.zero,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          deleteIcon: Icon(Icons.cancel, size: 14, color: isDark ? const Color(0xFF597EF7) : Colors.blue),
                          onDeleted: () {
                            setModalState(() => customShiftIds!.removeAt(idx));
                          },
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: containerBg, borderRadius: BorderRadius.circular(6)),
                        child: DropdownButton<int>(
                          hint: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 14, color: isDark ? Colors.white38 : Colors.grey),
                              const SizedBox(width: 4),
                              Text(AppLocalizations.of(context)!.add, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey))
                            ],
                          ),
                          dropdownColor: Theme.of(context).cardColor,
                          underline: const SizedBox(),
                          icon: const SizedBox(),
                          items: configList.map<DropdownMenuItem<int>>((config) {
                            return DropdownMenuItem<int>(
                              value: config.id,
                              child: Text(config.name, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : const Color(0xFF1F1F1F))),
                            );
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
                Text(AppLocalizations.of(context)!.dateRange, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
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
                          decoration: BoxDecoration(color: containerBg, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatStart, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: itemTextColor)),
                              Icon(Icons.calendar_today, size: 14, color: isDark ? Colors.white38 : Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(AppLocalizations.of(context)!.to, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey))),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picker = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? startDate ?? DateTime.now(),
                              firstDate: startDate ?? DateTime(2020),
                              lastDate: DateTime(2030));
                          if (picker != null) {
                            setModalState(() => endDate = picker);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(color: containerBg, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatEnd, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: itemTextColor)),
                              Icon(Icons.calendar_today, size: 14, color: isDark ? Colors.white38 : Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                if(isErrorMsg)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "⚠️ 请选择一个自定义排班！",
                      style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                // ==================== 第四行：取消、删除、确定生成按钮 ====================
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1️⃣ 上方：一键双发（最核心的主推荐操作，拉满）
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // ... 保持你原本的【一键双发】核心业务逻辑不变
                          if (selectedMode == 0) {
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern, patternType: selectedMode!, startDate: formatStart, endDate: formatEnd,
                                shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList());
                            final startDateTime = DateTime.parse(formatStart);
                            await ref.read(shiftViewModelProvider(startDateTime.year, startDateTime.month).notifier).generateShifts(
                              startDate: formatStart, endDate: formatEnd, patternType: selectedMode!,
                              shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList(),
                            );
                            Navigator.pop(context);
                          } else {
                            if(customShiftIds == null || customShiftIds!.isEmpty){ setModalState(() { isErrorMsg = true; }); return; }
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern, patternType: selectedMode!, startDate: formatStart, endDate: formatEnd, shiftConfigIds: customShiftIds!);
                            final startDateTime = DateTime.parse(formatStart);
                            await ref.read(shiftViewModelProvider(startDateTime.year, startDateTime.month).notifier).generateShifts(
                              startDate: formatStart, endDate: formatEnd, patternType: selectedMode!, shiftConfigIds: customShiftIds!,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14), // 加高一点更高级
                        ),
                        child: Text(AppLocalizations.of(context)!.generateShifts, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2️⃣ 中间：仅生成规律
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // ... 保持你原本的【仅生成规律】核心业务逻辑不变
                          if (selectedMode == 0) {
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern, patternType: selectedMode!, startDate: formatStart, endDate: formatEnd,
                                shiftConfigIds: weeklySelection!.values.toList().whereType<int>().toList());
                            Navigator.pop(context);
                          } else {
                            if(customShiftIds == null || customShiftIds!.isEmpty){ setModalState(() { isErrorMsg = true; }); return; }
                            await ref.read(shiftPatternViewModelProvider.notifier).changeShiftPattern(
                                oldPattern: pattern, patternType: selectedMode!, startDate: formatStart, endDate: formatEnd, shiftConfigIds: customShiftIds!);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withValues(alpha: 0.1), // 错开颜色层级
                          foregroundColor: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(AppLocalizations.of(context)!.generatePattern, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3️⃣ 底部：删除和取消（横向并排，不占纵向高度）
                    Row(
                      children: [
                        if (pattern != null) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _confirmDelete(context, ref, pattern);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFA5151)),
                                foregroundColor: const Color(0xFFFA5151),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cancelBtnBg,
                              foregroundColor: isDark ? Colors.white60 : const Color(0xFF606266),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ),
                      ],
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

// ==================== 确认删除对话框暗黑优化 ====================
  void _confirmDelete(BuildContext context, WidgetRef ref, ShiftPattern pattern) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 🚀 【优化 7】：自适应背景色
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.confirmDel, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        content: Text(AppLocalizations.of(context)!.confirmDelHint, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // 🚀 【优化 8】：刺眼红色柔和化
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(shiftPatternViewModelProvider.notifier).deleteShiftPatternById(pattern.id);
            },
            child:  Text(AppLocalizations.of(context)!.delete, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
