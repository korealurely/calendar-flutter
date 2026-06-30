import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_calendar/data/work_time_stat.dart';

class WorkTimeBarChartCard extends StatefulWidget {
  final List<WorkTimeStat> dataList;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final bool isLoading;
  final bool hasError;
  final String? errMsg;
  final VoidCallback? onRetry;

  const WorkTimeBarChartCard({
    super.key,
    required this.dataList,
    required this.onMonthChanged,
    required this.isLoading,
    required this.hasError,
    this.errMsg,
    this.onRetry,
    required this.currentMonth,
  });

  @override
  State<WorkTimeBarChartCard> createState() => _WorkTimeBarChartCard();
}

class _WorkTimeBarChartCard extends State<WorkTimeBarChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "工时统计",
                  maxLines: 1,
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
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            final preMonth = DateTime(
                              widget.currentMonth.year,
                              widget.currentMonth.month - 1,
                            );
                            widget.onMonthChanged(preMonth);
                          },
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF434343),
                    ),
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
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            final nextMonth = DateTime(
                              widget.currentMonth.year,
                              widget.currentMonth.month + 1,
                            );
                            widget.onMonthChanged(nextMonth);
                          },
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF434343),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildInnerContent(),
        ],
      ),
    );
  }

  Widget _buildInnerContent() {
    if (widget.hasError) return _buildErrorState();

    return AnimatedOpacity(
      opacity: widget.isLoading ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: widget.dataList.isEmpty
          ? _buildEmptyState()
          : _buildChartContent(),
    );
  }

  Widget _buildChartContent() {
    final hourList = widget.dataList.map((e) => e.hour).toList();
    final double maxH = hourList.isNotEmpty ? hourList.reduce(max) : 0;

    final double maxY = max(8.0, maxH + 2);

    const double itemWidth = 36.0;
    final double idealWidth = (widget.dataList.length * itemWidth) + 10;

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          final bool isScrollable = idealWidth > constraint.maxWidth;

          final double chartWidth = isScrollable
              ? idealWidth
              : constraint.maxWidth;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: false,
            child: SizedBox(
              height: 180,
              width: chartWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 12),
                child: BarChart(
                  BarChartData(
                    // 💡 2. 核心：强制靠左对齐，解决第一根柱子离Y轴太远的问题
                    alignment: BarChartAlignment.start,
                    // 💡 3. 核心：靠左对齐时，必须手动指定柱子之间的横向间距
                    groupsSpace: 28,

                    barTouchData: BarTouchData(
                      touchCallback: (FlTouchEvent event, barResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barResponse == null ||
                              barResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = barResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => const Color(0xFF1F1F1F),
                        tooltipRoundedRadius: 6,
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tooltipMargin: 4,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.toStringAsFixed(1)}小时',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 3, //切成三条参考线
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.1),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      ),
                    ),
                    borderData: FlBorderData(show: false),

                    minY: 0,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: maxY / 2,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toStringAsFixed(0)}h',
                            style: const TextStyle(
                              color: Colors.black26,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final int index = value.toInt();
                            if (index >= 0 && index < widget.dataList.length) {
                              final int day = widget.dataList[index].day;

                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '$day日',
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(widget.dataList.length, (i) {
                      final item = widget.dataList[i];
                      final isTouched = i == touchedIndex;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: item.hour,
                            gradient: isTouched
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF2F74C5),
                                      Color(0xFF1E5294),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF74B2FA),
                                      Color(0xFF4A90E2),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                            width: 8,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: const Color(
                                0xFF4A90E2,
                              ).withValues(alpha: 0.05),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: Colors.redAccent.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            widget.errMsg ?? "工时统计加载失败",
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 14),
            label: const Text("重新加载", style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F7FA),
              foregroundColor: const Color(0xFF434343),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧱 局部抽取：空状态面板
  Widget _buildEmptyState() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            "本月还没有登记工时数据哦~",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
