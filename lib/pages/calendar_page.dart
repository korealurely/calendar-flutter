import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import '../view/month_grid_view.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/provider/weight_provider.dart';
import '../utils/date_util.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar/pages/weight_history_page.dart';
import 'package:flutter_calendar/pages/weight_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  final DateTime _baseDate = DateTime(2020, 1, 1);
  late PageController _pageController;
  late int _currentYear;
  late int _currentMonth;
  DateTime _selectedDate = DateTime.now();
  double _currentCardHeight = 280.0;
  final Map<String, Map<String, int>> _monthCalcCache = {};
  final current = DateUtil.getCurrentYearMonth();
  late int initialPage;

  @override
  void initState() {
    super.initState();
    initialPage = DateUtil.getMonthDistance(
      targetYear: current['year']!,
      targetMonth: current['month']!,
      startYear: _baseDate.year,
      startMonth: _baseDate.month,
    );
    if (initialPage < 0) {
      initialPage = 0;
    }

    _pageController = PageController(initialPage: initialPage);
    _currentYear = current['year']!;
    _currentMonth = current['month']!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCardHeight(initialPage);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCardHeight(int index) {
    DateTime monthDate = DateTime(_baseDate.year, _baseDate.month + index, 1);
    int firstDay = monthDate.weekday % 7;
    int totalDays = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    int totalCells = firstDay + totalDays;
    int rows = (totalCells / 7).ceil();

    double stepHeight;
    double basePadding;

    if (Platform.isIOS) {
      stepHeight = 64.0;
      basePadding = 30.0;
    } else {
      stepHeight = 50.0;
      basePadding = 20.0;
    }
    setState(() {
      _currentCardHeight = (rows * stepHeight) + basePadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedDateId = _selectedDate.year * 10000 + _selectedDate.month * 100 + _selectedDate.day;

    final currentMonthDataAsync = ref.watch(shiftViewModelProvider(_currentYear, _currentMonth));
    final currentMonthWeightAsync = ref.watch(weightViewModelProvider(_currentYear,_currentMonth));

    // 🚀 【换装天眼】：获取当前系统是否处于暗黑模式
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🚀 【优化 1】：去除写死的浅灰色底，自动读取系统背景色（白天浅灰，暗黑纯黑）
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                AppLocalizations.of(context)!.yearMonthDate(_selectedDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // 🚀 【优化 2】：文字显式读取系统大字颜色
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )
            ),
            IconButton(
                onPressed: (){
                  setState((){
                    _pageController.animateToPage(
                        initialPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut
                    );
                    _selectedDate = DateTime.now();
                  });
                },
                icon: Icon(
                  Icons.calendar_month_outlined,
                  // 🚀 【优化 3】：图标颜色主题自适应
                  color: isDark ? Colors.white70 : Colors.black87,
                )
            )
          ],
        ),
        centerTitle: false,
        // 🚀 【优化 4】：AppBar背景自适应（读卡片白/深灰）
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              // 🚀 【优化 5】：日历大卡片背景色自适应
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  // 🚀 【优化 6】：暗黑模式下阴影收敛，防止白边糊掉
                  color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWeekHeader(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    // 🚀 【优化 7】：分割线颜色适配
                      color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.2),
                      height: 1
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  height: _currentCardHeight,

                  child: PageView.builder(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),

                    onPageChanged: (int index) {
                      DateTime targetDate = DateTime(_baseDate.year, _baseDate.month + index, 1);
                      setState(() {
                        _currentYear = targetDate.year;
                        _currentMonth = targetDate.month;
                        if(targetDate.year == DateTime.now().year && targetDate.month == DateTime.now().month){
                          _selectedDate = DateTime.now();
                        }else{
                          _selectedDate = targetDate;
                        }
                      });
                      _updateCardHeight(index);
                      _onMonthChanged(targetDate.year, targetDate.month);
                    },

                    itemBuilder: (context, index) {
                      DateTime monthDate = DateTime(_baseDate.year, _baseDate.month + index, 1);
                      String cacheKey = "${monthDate.year}-${monthDate.month}";
                      int firstDay;
                      int totalDays;

                      if (_monthCalcCache.containsKey(cacheKey)) {
                        firstDay = _monthCalcCache[cacheKey]!['firstDay']!;
                        totalDays = _monthCalcCache[cacheKey]!['totalDays']!;
                      } else {
                        firstDay = monthDate.weekday % 7;
                        totalDays = DateTime(monthDate.year, monthDate.month + 1, 0).day;
                        _monthCalcCache[cacheKey] = {'firstDay': firstDay, 'totalDays': totalDays};
                      }
                      final monthDataAsync = ref.watch(shiftViewModelProvider(monthDate.year,monthDate.month));
                      final weightAsync = ref.watch(weightViewModelProvider(monthDate.year,monthDate.month));
                      return monthDataAsync.when(
                        data: (shiftMap) => weightAsync.when(
                            data: (weightMap){
                              return MonthGridView(
                                firstDayOfWeek: firstDay,
                                daysInMonth: totalDays,
                                year: monthDate.year,
                                month: monthDate.month,
                                selectedDate: _selectedDate,
                                shiftMap:shiftMap,
                                weightMap: weightMap,
                                onDayTap: (DateTime clickDate){
                                  setState(() {
                                    _selectedDate = clickDate;
                                  });
                                },
                              );
                            },
                            error: (err, _) => Center(child: Text("体重数据对账失败: $err", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                            loading: () => const Center(child: CircularProgressIndicator())
                        ),

                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text("日历数据对账失败: $err", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          currentMonthDataAsync.when(
            data: (shiftMap){
              final currentDayShift = shiftMap[selectedDateId];
              return _buildSelectShift(currentDayShift, _selectedDate, onTap: () {
                _showShiftEditBottomSheet(context, _selectedDate, currentDayShift);
              },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
          ),

          currentMonthWeightAsync.when(
            data: (weightMap){
              final currentWeightList = weightMap[selectedDateId];
              final bool hasWeights = currentWeightList != null && currentWeightList.isNotEmpty;

              return _buildSelectWeight(currentWeightList, _selectedDate, onTap: () {
                Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => hasWeights ? WeightHistoryPage(selectedDate: _selectedDate) : const WeightPage(),
                  ),
                );
              },
              );
            },
            error: (_, _) => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }

  void _onMonthChanged(int year, int month) {
    print("[月份变换监听]，$year 年 $month月");
  }

  Widget _buildWeekHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weeks = [
      AppLocalizations.of(context)!.sun,
      AppLocalizations.of(context)!.mon,
      AppLocalizations.of(context)!.tue,
      AppLocalizations.of(context)!.wed,
      AppLocalizations.of(context)!.thu,
      AppLocalizations.of(context)!.fri,
      AppLocalizations.of(context)!.sat];
    return Row(
      children: weeks.map((w) => Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
                w,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    // 🚀 【优化 8】：星期文字在暗黑模式下自动提亮成更柔和的白色
                    color: isDark ? Colors.white54 : Colors.black54
                )
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildSelectShift(CalendarShift? shift, DateTime selectedDate, {VoidCallback? onTap}) {
    final bool hasConfig = shift != null && shift.config != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            // 🚀 【优化 9】：详情卡片背景色自适应
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                width: 0.8,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.blue.withValues(alpha: 0.05),
              highlightColor: Colors.blue.withValues(alpha: 0.02),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.monthDayDate(selectedDate)} ${AppLocalizations.of(context)!.detail}",
                              // 🚀 【优化 10】：文本颜色主题感知
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 18, color: isDark ? Colors.white38 : Colors.black26),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasConfig ? Color(shift.config!.colorValue).withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hasConfig ? shift.config!.name : AppLocalizations.of(context)!.noShift,
                            style: TextStyle(
                              color: hasConfig ? Color(shift.config!.colorValue) : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (hasConfig) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        // 🚀 【优化 11】：分割线自适应
                        child: Divider(color: isDark ? Colors.white10 : const Color(0xFFEEEEEE), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.play_circle_outline, size: 18, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.startShift, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 14)),
                            ],
                          ),
                          Text(
                            shift.config!.startTime ?? "--:--",
                            style: TextStyle(fontFamily: 'Courier', fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.stop_circle_outlined, size: 18, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.endWork, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 14)),
                            ],
                          ),
                          Text(
                            shift.config!.endTime ?? "--:--",
                            style: TextStyle(fontFamily: 'Courier', fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Column(
                            children: [
                              Icon(Icons.hotel_outlined, size: 36, color: isDark ? Colors.white30 : Colors.black26),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.noShiftHint,
                                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectWeight(List<CalendarWeight>? weights, DateTime selectedDate, {VoidCallback? onTap}) {
    final bool hasData = weights != null && weights.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double avgWeight = 0;
    double maxWeight = 0;
    double minWeight = 0;

    if (hasData) {
      final values = weights.map((w) => w.weight).toList();
      avgWeight = values.reduce((a, b) => a + b) / values.length;
      maxWeight = values.reduce((a, b) => a > b ? a : b);
      minWeight = values.reduce((a, b) => a < b ? a : b);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            // 🚀 【优化 12】：体重卡片背景自适应
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                width: 0.8,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.green.withValues(alpha: 0.05),
              highlightColor: Colors.green.withValues(alpha: 0.02),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.monthDayDate(selectedDate)} ${AppLocalizations.of(context)!.weight}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 18, color: isDark ? Colors.white38 : Colors.black26),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasData ? Colors.green.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hasData ? "${weights.length} 次测量" : AppLocalizations.of(context)!.noData,
                            style: TextStyle(
                              color: hasData ? Colors.green : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (hasData) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: isDark ? Colors.white10 : const Color(0xFFEEEEEE), height: 1),
                      ),

                      Row(
                        children: [
                          _buildWeightMetric("平均体重", "${avgWeight.toStringAsFixed(2)} kg", Colors.green),
                          _buildVerticalDivider(),
                          _buildWeightMetric("当日最高", "${maxWeight.toStringAsFixed(2)} kg", Colors.redAccent),
                          _buildVerticalDivider(),
                          _buildWeightMetric("当日最低", "${minWeight.toStringAsFixed(2)} kg", Colors.blueAccent),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: isDark ? Colors.white10 : const Color(0xFFEEEEEE), height: 1),
                      ),

                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                          const SizedBox(width: 6),
                          Text(
                            "测量时间：",
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: weights.map((w) {
                                  final String timeText = DateFormat('HH:mm').format(w.updatedAt);
                                  return Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      timeText,
                                      style: TextStyle(fontFamily: 'Courier', fontSize: 11, color: isDark ? Colors.white70 : Colors.black54),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Column(
                            children: [
                              Icon(Icons.monitor_weight_outlined, size: 36, color: isDark ? Colors.white30 : Colors.black26),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.noWeightHint,
                                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightMetric(String title, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: isDark ? Colors.white38 : Colors.black45, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 24,
      width: 0.8,
      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
    );
  }

  void _showShiftEditBottomSheet(BuildContext context, DateTime date, CalendarShift? currentShift) {
    int? selectedConfigId = currentShift?.shiftConfigId;
    ShiftConfig? currentConfig = currentShift?.config;

    // 3. 动态计算格式化后的日期文本（时刻盯着内存里的局部变量）
    final String formatDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      // 🚀 【优化 13】：底部弹窗卡片颜色自适应（不再硬编码成白色）
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return Consumer(
              builder: (context, ref, child) {
                final configListAsync = ref.watch(shiftConfigViewModelProvider);

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.monthDayDate(date)} ${AppLocalizations.of(context)!.editShift}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: isDark ? Colors.white38 : Colors.black38),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text(AppLocalizations.of(context)!.selectShiftType, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),

                      configListAsync.when(
                        data: (configList) {
                          // 🚀 【优化 14】：ChoiceChip 样式适配
                          final unselectedColor = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F7FA);
                          final unselectedLabelStyle = TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.normal);

                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ChoiceChip(
                                label:  Text(AppLocalizations.of(context)!.clearShift),
                                labelStyle: selectedConfigId == null
                                    ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                    : unselectedLabelStyle,
                                selected: selectedConfigId == null,
                                selectedColor: Colors.blue,
                                backgroundColor: unselectedColor,
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onSelected: (selected) {
                                  if (selected) {
                                    setPopupState(() {
                                      selectedConfigId = null;
                                      currentConfig = null;
                                    });
                                  }
                                },
                              ),

                              ...configList.map((config) {
                                final isSelected = selectedConfigId == config.id;
                                return ChoiceChip(
                                  label: Text(config.name),
                                  selected: isSelected,
                                  labelStyle: isSelected
                                      ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                      : unselectedLabelStyle,
                                  selectedColor: Colors.blue,
                                  backgroundColor: unselectedColor,
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setPopupState(() {
                                        selectedConfigId = config.id;
                                        currentConfig = config;
                                      });
                                    }
                                  },
                                );
                              }),
                            ],
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text("${AppLocalizations.of(context)!.loadErr} $err", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                      ),
                      const SizedBox(height: 24),

                      // 🚀 【优化 15】：保存按钮暗黑模式适配
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () async{
                            // TODO: 结合你原本的 ViewModel 去执行保存
                            Navigator.pop(context);

                            // 2. 拿着最终选好的 selectedConfigId 去敲 Isar 数据库的大门
                            if (selectedConfigId == null) {
                              // 🛑 如果最后选的是清除/休息，执行物理删除
                              final dateId = date.year * 10000 + date.month * 100 + date.day;
                              await ref.read(shiftViewModelProvider(date.year, date.month).notifier).deleteShiftById(dateId);
                            } else {
                              // 💾 否则，直接保存选中的班次 ID
                              await ref.read(shiftViewModelProvider(date.year, date.month).notifier).changeDayShift(
                                year: date.year,
                                month: date.month,
                                day: date.day,
                                shiftId: selectedConfigId, // 最终确定的班次
                                isAlarm: false,
                                alarmTime: currentConfig != null && currentConfig?.startTime!= null ? DateTime.parse("$formatDate ${currentConfig?.startTime}") : null, // 纯改班次，时间走配置里的默认值，不覆盖
                              );
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}