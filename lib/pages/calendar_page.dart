import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import '../view/month_grid_view.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/provider/weight_provider.dart';
import '../utils/date_util.dart';
import 'dart:io'; // 💡 必须导入此库来判断系统平台
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🚀 1. 记得导入 Riverpod 包
import 'package:intl/intl.dart';
import 'package:flutter_calendar/pages/weight_history_page.dart';
import 'package:flutter_calendar/pages/weight_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  // 默认基准日期
  final DateTime _baseDate = DateTime(2020, 1, 1);

  // 💡 把 PageController 重新请回来
  late PageController _pageController;

  // 当前页面的年月
  late int _currentYear;
  late int _currentMonth;



  DateTime _selectedDate = DateTime.now();

  // 当前日历卡片的高度约束（4行、5行、6行日子的格子高度是动态变动的）
  double _currentCardHeight = 280.0;

  final Map<String, Map<String, int>> _monthCalcCache = {};

  final current = DateUtil.getCurrentYearMonth();

  late int initialPage;

  @override
  void initState() {
    super.initState();
    //_pageController = PageController(initialPage: 0);
    // 💡 使用工具类计算：今天距离 2026年1月1日 过去了几个月

    initialPage = DateUtil.getMonthDistance(
      targetYear: current['year']!,
      targetMonth: current['month']!,
      startYear: _baseDate.year,     // 2026
      startMonth: _baseDate.month,   // 1
    );
    // 如果算出来小于 0（说明手机时间比2020年还早），保险起见做个兜底重置为0
    if (initialPage < 0) {
      initialPage = 0;
    }

    // 如果算出来是正数，直接把 PageController 拨到当前月份对应的页码上！
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

  // 💡 核心算法：根据当前的页码，计算这个月占用了几行格子，从而动态刷新卡片高度
  void _updateCardHeight(int index) {
    DateTime monthDate = DateTime(_baseDate.year, _baseDate.month + index, 1);
    int firstDay = monthDate.weekday % 7;
    int totalDays = DateTime(monthDate.year, monthDate.month + 1, 0).day;

    // 总共占用的格子数
    int totalCells = firstDay + totalDays;
    // 算出是一共是几行（4行、5行 还是 6行）
    int rows = (totalCells / 7).ceil();

    // 💡 核心手术：根据平台动态分流计算参数
    double stepHeight; // 每行日子格子的高度步长
    double basePadding; // 卡片的上下基础边距总和

    if (Platform.isIOS) {
      // 🍏 iOS 字体臃肿，需要更大的空间
      stepHeight = 64.0;
      basePadding = 30.0;
    } else {
      // 🤖 Android (包括你的Android 10测试机) 字体紧凑，行高收紧
      // 38.0 ~ 42.0 是 Android 网格最紧凑精致的黄金比例
      stepHeight = 50.0;
      basePadding = 20.0;
    }
    // 每一行日子格子的大小大概是 46 像素（根据你 MonthGridView 的间距调整）
    // 行数 * 46 + 上下边距 = 卡片该有的完美高度
    setState(() {
      _currentCardHeight = (rows * stepHeight) + basePadding;
    });
  }

  @override
  Widget build(BuildContext context) {

    //点击返回的日期
    int selectedDateId = _selectedDate.year * 10000 + _selectedDate.month * 100 + _selectedDate.day;

    // 2. 🎯 【关键手术】：在最外层直接架设雷达，盯着“当前显示的月份数据”！
    final currentMonthDataAsync = ref.watch(shiftViewModelProvider(_currentYear, _currentMonth));

    final currentMonthWeightAsync = ref.watch(weightViewModelProvider(_currentYear,_currentMonth));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // 浅灰色高档背景
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$_currentYear年$_currentMonth月", style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
                onPressed: (){
                  setState((){
                    _pageController.animateToPage(
                        initialPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut
                    );
                    _selectedDate = DateTime.now();
                });
                  },
                icon:const Icon(Icons.calendar_month_outlined)
            )
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 固定文字星期标题
                _buildWeekHeader(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
                ),

                // 💥 终极魔法：用 AnimatedContainer 来包裹 PageView！
                // 当高度变化时，它自己会带有一个极度丝滑的上下缩短/撑长的变高动画
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250), // 高度形变动画时间
                  curve: Curves.easeOutCubic, // 缓动曲线
                  height: _currentCardHeight,  // 💡 动态绑定的高度

                  // 重新塞回 PageView，横向滑动特效瞬间复活！
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(), // 采用 Android 爽快的滚动物理效果

                    // 💡 滑动过程中实时监听
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

                      // 1. 随着手势划过去，实时计算并刷新下一页的卡片高度
                      _updateCardHeight(index);

                      // 2. 触发月份变换监听逻辑
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
                              error: (err, _) => Center(child: Text("体重数据对账失败: $err")),
                              loading: () => const Center(child: CircularProgressIndicator())
                          ),

                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, _) => Center(child: Text("日历数据对账失败: $err")),
                      );
                    },
                  ),
                ),


              ],
            ),
          ),

          currentMonthDataAsync.when(
              data: (shiftMap){
                // 🔍 初始化时，即使用户没点击，这里也能直接根据 selectedDateId 盲抓出当天的排班！
                final currentDayShift = shiftMap[selectedDateId];

                return _buildSelectShift(
                    currentDayShift,
                    _selectedDate,
                  onTap: () {
                    print("老哥，用户点击了 ${_selectedDate.month}月${_selectedDate.day}日 的卡片！");

                    // 示例 A：直接弹窗让用户修改当前日期的班次
                    _showShiftEditBottomSheet(context, _selectedDate, currentDayShift);

                    // 示例 B：或者直接路由跳转到编辑页
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(date: _selectedDate)));
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

                return _buildSelectWeight(
                  currentWeightList,
                  _selectedDate,
                  onTap: () {
                    print("老哥，用户点击了 ${_selectedDate.month}月${_selectedDate.day}日 的卡片！");
                    Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) =>hasWeights ? WeightHistoryPage(selectedDate: _selectedDate) : WeightPage(),
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

  // 星期表头积木
  Widget _buildWeekHeader() {
    final weeks = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(
      children: weeks.map((w) => Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(w, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildSelectShift(CalendarShift? shift, DateTime selectedDate, {VoidCallback? onTap}) { // 👈 🚀 1. 参数里加一个可选的 onTap 回调
    final bool hasConfig = shift != null && shift.config != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
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
                color: Colors.black.withValues(alpha: 0.04),
                width: 0.8,
              ),
            ),
            child: InkWell( // 👈 🚀 2. 核心手术：在这里注入 InkWell 点击天眼！
              onTap: onTap, // 👈 🚀 将外部的点击逻辑绑定给它
              splashColor: Colors.blue.withValues(alpha: 0.05), // 水波纹扩散的颜色（淡淡的蓝色，极高级）
              highlightColor: Colors.blue.withValues(alpha: 0.02), // 长按时高亮的颜色
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 保持内衬边距
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🏷️ 第一行：标题行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${selectedDate.month}月${selectedDate.day}日 详情",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(width: 4),
                            // 🚀 细节：加一个灰色小箭头，明摆着告诉用户“老子这卡片是可以点进去的”
                            const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasConfig ? Color(shift.config!.colorValue).withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hasConfig ? shift.config!.name : "暂无排班",
                            style: TextStyle(
                              color: hasConfig ? Color(shift.config!.colorValue) : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ✂️ 区分线与时间展示
                    if (hasConfig) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFEEEEEE), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.play_circle_outline, size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Text("上班时间", style: TextStyle(color: Colors.black54, fontSize: 14)),
                            ],
                          ),
                          Text(
                            shift.config!.startTime ?? "--:--",
                            style: const TextStyle(fontFamily: 'Courier', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.stop_circle_outlined, size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Text("下班时间", style: TextStyle(color: Colors.black54, fontSize: 14)),
                            ],
                          ),
                          Text(
                            shift.config!.endTime ?? "--:--",
                            style: const TextStyle(fontFamily: 'Courier', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                    ] else ...[
                      // 缺省空状态
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 12),
                          child: Column(
                            children: [
                              Icon(Icons.hotel_outlined, size: 36, color: Colors.black26),
                              SizedBox(height: 8),
                              Text(
                                "今天没有排班计划，睡个大懒觉吧~",
                                style: TextStyle(color: Colors.black38, fontSize: 13),
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
    // 🎯 核心安全防御：如果 weights 是 null，直接当成空列表处理
    final bool hasData = weights != null && weights.isNotEmpty;

    // 🧮 数据预处理（纯内存极简统计）
    double avgWeight = 0;
    double maxWeight = 0;
    double minWeight = 0;

    if (hasData) {
      // 💡 weights! 已经通过 hasData 验证，百分之百安全
      final values = weights.map((w) => w.weight).toList(); // 假设体重字段叫 weight
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
              color: Colors.black.withValues(alpha: 0.03),
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
                color: Colors.black.withValues(alpha: 0.04),
                width: 0.8,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.green.withValues(alpha: 0.05), // 🟩 呼应体重的绿色水波纹
              highlightColor: Colors.green.withValues(alpha: 0.02),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🏷️ 第一行：标题行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${selectedDate.month}月${selectedDate.day}日 体重",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasData ? Colors.green.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hasData ? "${weights.length} 次测量" : "暂无数据",
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFEEEEEE), height: 1),
                      ),

                      // 📊 三维数据网格面板（平均、最高、最低）
                      Row(
                        children: [
                          _buildWeightMetric("平均体重", "${avgWeight.toStringAsFixed(2)} kg", Colors.green),
                          _buildVerticalDivider(),
                          _buildWeightMetric("当日最高", "${maxWeight.toStringAsFixed(2)} kg", Colors.redAccent),
                          _buildVerticalDivider(),
                          _buildWeightMetric("当日最低", "${minWeight.toStringAsFixed(2)} kg", Colors.blueAccent),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFEEEEEE), height: 1),
                      ),

                      // 🕒 测量时间轴微小标签展示
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: Colors.black38),
                          const SizedBox(width: 6),
                          const Text(
                            "测量时间：",
                            style: TextStyle(color: Colors.black38, fontSize: 12),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: weights.map((w) {
                                  // 🚀 干净优雅的 DateTime 补零转换 (假设字段名是 w.createdAt)

                                  final String timeText = DateFormat('HH:mm').format(w.updatedAt);

                                  return Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      timeText,
                                      style: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: Colors.black54),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // 💤 缺省空状态（当 List 为 null 或者空时完美触发）
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 12),
                          child: Column(
                            children: [
                              Icon(Icons.monitor_weight_outlined, size: 36, color: Colors.black26),
                              SizedBox(height: 8),
                              Text(
                                "今天还没称体重呢，点击记录一下吧~",
                                style: TextStyle(color: Colors.black38, fontSize: 13),
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

// 🧱 辅助抽取：核心指标小格子
  Widget _buildWeightMetric(String title, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.black45, fontSize: 12)),
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

// 🧱 辅助抽取：网格分割竖线
  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 0.8,
      color: Colors.black.withValues(alpha: 0.06),
    );
  }

  void _showShiftEditBottomSheet(BuildContext context, DateTime date, CalendarShift? currentShift) {
    // 🎯 核心暂存：记录用户当前选了哪一个班次 ID（默认是当天原本的班次，可能为 null）
    int? selectedConfigId = currentShift?.shiftConfigId;

    ShiftConfig? currentConfig = currentShift?.config;

    // 3. 动态计算格式化后的日期文本（时刻盯着内存里的局部变量）
    final String formatDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // 🚀 依然保留 StatefulBuilder，因为切换 ChoiceChip 的选中状态需要局部刷新
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return Consumer(
              builder: (context, ref, child) {
                // 监控全部的班次配置（早班、晚班等）
                final configListAsync = ref.watch(shiftConfigViewModelProvider);

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 高度自适应，非常克制
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔝 顶部把手线
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🗓️ 标题行
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${date.month}月${date.day}日 修改班次",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black38),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 🎨 班次选择区
                      const Text("选择班次类型", style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),

                      configListAsync.when(
                        data: (configList) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              // 🟢 选项 A：清除/休息
                              ChoiceChip(
                                label: const Text("清除/休息"),
                                labelStyle: TextStyle(
                                  color: selectedConfigId == null ? Colors.white : Colors.black87,
                                  fontWeight: selectedConfigId == null ? FontWeight.bold : FontWeight.normal,
                                ),
                                selected: selectedConfigId == null, // 盯着内存状态
                                selectedColor: Colors.blue,
                                backgroundColor: const Color(0xFFF5F7FA),
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onSelected: (selected) {
                                  if (selected) {
                                    setPopupState(() {
                                      selectedConfigId = null; // 🚀 只改暂存状态，不写库
                                      currentConfig = null;
                                    });
                                  }
                                },
                              ),

                              // 🌀 选项 B：自定义班次列表
                              ...configList.map((config) {
                                final isSelected = selectedConfigId == config.id;
                                return ChoiceChip(
                                  label: Text(config.name),
                                  selected: isSelected,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  selectedColor: Colors.blue,
                                  backgroundColor: const Color(0xFFF5F7FA),
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setPopupState(() {
                                        selectedConfigId = config.id; // 🚀 只改暂存状态，不写库
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
                        error: (err, _) => Text("拉取班次失败: $err"),
                      ),

                      const SizedBox(height: 36), // 给大按钮留出呼吸感

                      // 🚀 终极一枪：确认提交大按钮
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
                          onPressed: () async {
                            // 1. 先关闭弹窗，收起界面
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
                          child: const Text("确认提交", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
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