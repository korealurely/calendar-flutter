import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_calendar/data/shift_stat_item.dart';

class ShiftPieChartCard extends StatefulWidget {
  final List<ShiftStatItem> statList;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final bool isLoading;
  final bool hasError;        // 🚀 新增：错误状态天眼
  final String? errorMsg;     // 🚀 新增：错误文案
  final VoidCallback? onRetry; // 🚀 新增：原地重试回调

  const ShiftPieChartCard({
    super.key,
    required this.statList,
    required this.currentMonth,
    required this.onMonthChanged,
    required this.isLoading,
    this.hasError = false,
    this.errorMsg,
    this.onRetry,
  });

  @override
  State<ShiftPieChartCard> createState() => _ShiftPieChartCard();
}

class _ShiftPieChartCard extends State<ShiftPieChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.statList.fold<int>(
      0,
          (sum, item) => sum + item.count,
    );

    final monthStr =
        "${widget.currentMonth.year}年${widget.currentMonth.month.toString().padLeft(2, '0')}月";

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔝 标题和切换按钮区（无论发生什么，永远坚固不动）
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "班次统计",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.isLoading ? null : () { // 加载中禁用，防止疯狂点击
                      final preMonth = DateTime(
                        widget.currentMonth.year,
                        widget.currentMonth.month - 1,
                      );
                      widget.onMonthChanged(preMonth);
                    },
                    icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    monthStr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: widget.isLoading ? null : () {
                      final nextMonth = DateTime(
                        widget.currentMonth.year,
                        widget.currentMonth.month + 1,
                      );
                      widget.onMonthChanged(nextMonth);
                    },
                    icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🎯 中枢分流系统：原地调度【报错】、【正常】、【空状态】
          _buildInnerContent(totalCount),
        ],
      ),
    );
  }

  // 🧱 核心控制器：根据 Riverpod 状态原地交替内容
  Widget _buildInnerContent(int totalCount) {
    // 🔴 1. 如果报错了，原地渲染高级重试面板，不破坏卡片外壳
    if (widget.hasError) {
      return _buildErrorState();
    }

    // 🟢 2. 正常流：套上你最喜欢的精细化淡化动画
    return AnimatedOpacity(
      opacity: widget.isLoading ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: widget.statList.isEmpty
          ? _buildEmptyState()
          : _buildChartContent(totalCount),
    );
  }

  // 🧱 局部抽取：闭环内置报错面板
  Widget _buildErrorState() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Text(
            widget.errorMsg ?? "数据对账有些小失败",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
          const SizedBox(height: 12),
          // 高级精致的重试小胶囊按钮
          ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 14),
            label: const Text("重新加载", style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F7FA),
              foregroundColor: const Color(0xFF434343),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // 🧱 局部抽取：空状态积木
  Widget _buildEmptyState() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 48,
            color: Colors.grey.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          const Text(
            "本月暂无排班统计数据哦~",
            style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // 🧱 局部抽取：图表核心行积木
  Widget _buildChartContent(int totalCount) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$totalCount",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F1F1F)),
                    ),
                    const Text("总天数", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    centerSpaceRadius: 45,
                    sections: _showingSections(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.statList.map((item) => _buildLegendItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.statList.length, (i) {
      final item = widget.statList[i];
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 32.0 : 24.0;

      return PieChartSectionData(
        color: Color(item.colorValue),
        value: item.count.toDouble(),
        title: '${item.count}天',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegendItem(ShiftStatItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: Color(item.colorValue), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            item.name,
            style: const TextStyle(fontSize: 13, color: Color(0xFF434343), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}