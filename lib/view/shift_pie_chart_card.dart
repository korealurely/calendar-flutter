import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_calendar/data/shift_stat_item.dart';

class ShiftPieChartCard extends StatefulWidget {
  final List<ShiftStatItem> statList;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final bool isLoading;
  final bool hasError;
  final String? errorMsg;
  final VoidCallback? onRetry;

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
    // 🚀 【换装天眼】：提前抓取黑夜状态
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        // 🚀 【优化 1】：大底色自适应（白天纯白，黑夜深灰卡片色）
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // 暗黑模式下弱化阴影，防止发灰泛白
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔝 标题和切换按钮区
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "班次统计",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // 🚀 【优化 2】：消灭死色，跟随全局大标题字色
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.isLoading ? null : () {
                      final preMonth = DateTime(
                        widget.currentMonth.year,
                        widget.currentMonth.month - 1,
                      );
                      widget.onMonthChanged(preMonth);
                    },
                    // 🚀 【优化 3】：小图标自适应白/灰
                    icon: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white60 : const Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    monthStr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
                    icon: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white60 : const Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🎯 中枢分流系统
          _buildInnerContent(totalCount),
        ],
      ),
    );
  }

  Widget _buildInnerContent(int totalCount) {
    if (widget.hasError) {
      return _buildErrorState();
    }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 14),
            label: const Text("重新加载", style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              // 🚀 【优化 4】：重试按钮底色完美降噪（暗黑下用白透明遮罩形成轻质灰色，不刺眼）
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF5F7FA),
              foregroundColor: isDark ? Colors.white70 : const Color(0xFF434343),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 48,
            color: isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            "本月暂无排班统计数据哦~",
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // 🧱 局部抽取：图表核心行积木
  Widget _buildChartContent(int totalCount) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          // 🚀 【优化 5】：饼图中心总天数文字自适应
                          color: Theme.of(context).textTheme.bodyLarge?.color
                      ),
                    ),
                    Text(
                        "总天数",
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey)
                    ),
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
          color: Colors.white, // 💡 饼图块里本身的文字固定白色最安全清晰
        ),
      );
    });
  }

  Widget _buildLegendItem(ShiftStatItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            style: TextStyle(
                fontSize: 13,
                // 🚀 【优化 6】：图例名称颜色跟随换装自适应
                color: isDark ? Colors.white70 : const Color(0xFF434343),
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}