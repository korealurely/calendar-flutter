import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_calendar/data/weight_stat_item.dart';

class WeightLineChartCard extends StatefulWidget{
  final List<WeightStatItem> dataList;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final bool isLoading;
  final bool hasError;
  final String? errorMsg;
  final VoidCallback? onRetry;

  const WeightLineChartCard({super.key, required this.dataList, required this.currentMonth, required this.onMonthChanged, required this.isLoading, required this.hasError, this.errorMsg, this.onRetry});

  @override
  State<WeightLineChartCard> createState() => _WeightLineChartCard();
}

class _ShiftPieChartCard {} // 修正空类错误

class _WeightLineChartCard extends State<WeightLineChartCard>{
  LineBarSpot? touchedSpot;

  @override
  Widget build(BuildContext context) {
    // 🚀 【换装天眼 1】：获取黑夜状态
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = "${widget.currentMonth.year}年${widget.currentMonth.month.toString().padLeft(2,'0')}月";

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // 🚀 【优化 1】：自适应卡片大背景
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "体重趋势",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // 🚀 【优化 2】：消灭死色，跟随全局标题颜色
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.isLoading ? null : (){
                      final preMonth = DateTime(widget.currentMonth.year,widget.currentMonth.month -1);
                      widget.onMonthChanged(preMonth);
                    },
                    icon: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white60 : const Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: widget.isLoading ? null : (){
                      final nextMonth = DateTime(widget.currentMonth.year,widget.currentMonth.month + 1);
                      widget.onMonthChanged(nextMonth);
                    },
                    icon: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white60 : const Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 24),

          _buildInnerContent()
        ],
      ),
    );
  }

  Widget _buildInnerContent() {
    if(widget.hasError) return _buildErrorState();

    return AnimatedOpacity(
      opacity: widget.isLoading ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: widget.dataList.isEmpty ? _buildEmptyState() : _buildChartContext(),
    );
  }

  Widget _buildChartContext() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weights = widget.dataList.map((e) => e.weight).toList();
    final double maxW = weights.reduce(max);
    final double minW = weights.reduce(min);

    final double minY = max(0,minW - 2);
    final double maxY = maxW + 2;

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchCallback: (FlTouchEvent event, LineTouchResponse? response){
              setState(() {
                if(!event.isInterestedForInteractions || response == null || response.lineBarSpots == null){
                  touchedSpot = null;
                  return;
                }
                touchedSpot = response.lineBarSpots!.first;
              });
            },
            touchTooltipData: LineTouchTooltipData(
              // 🚀 【优化 3】：点击提示气泡底色在夜间用高级纯深灰，文字纯白，边界清晰
                getTooltipColor: (spot) => isDark ? const Color(0xFF2C2C2E) : const Color(0xFF1F1F1F),
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> touchSpots){
                  return touchSpots.map((barSpot){
                    return LineTooltipItem(
                      "${barSpot.y.toStringAsFixed(2)} kg",
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    );
                  }).toList();
                }
            ),
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes){
              return spotIndexes.map((spotIndex){
                return TouchedSpotIndicatorData(
                    FlLine(color: const Color(0xFF4A90E2).withValues(alpha: 0.3), strokeWidth: 2, dashArray: [4,4]),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 6,
                          color: const Color(0xFF4A90E2),
                          strokeWidth: 2,
                          // 🚀 【优化 4】：长按选中的焦点圆圈描边，黑夜下必须用 cardColor（深灰），否则用白色在黑底上突兀刺眼
                          strokeColor: isDark ? Theme.of(context).cardColor : Colors.white
                      ),
                    )
                );
              }).toList();
            },
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 3,
            getDrawingHorizontalLine: (value) => FlLine(
              // 🚀 【优化 5】：网格横线颜色自适应透明度
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
                strokeWidth: 1,
                dashArray: [5,5]
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: 31,
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: (maxY - minY) / 2,
                getTitlesWidget: (value, meta) {
                  if (value > maxY + 0.05) return const SizedBox.shrink();

                  final double midY = minY + (maxY - minY) / 2;

                  bool isBottom = (value - minY).abs() < 0.1;
                  bool isCenter = (value - midY).abs() < 0.1;
                  bool isTop    = (value - maxY).abs() < 0.1;

                  if (isBottom || isCenter || isTop) {
                    double targetValue = value;
                    if (isBottom) targetValue = minY;
                    if (isCenter) targetValue = midY;
                    if (isTop)    targetValue = maxY;

                    return Text(
                      targetValue.toStringAsFixed(1),
                      style: TextStyle(
                        // 🚀 【优化 6】：Y 轴坐标轴字体颜色在黑夜下适度提亮
                        color: isDark ? Colors.white30 : Colors.black26,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: 1,
                  getTitlesWidget: (value, meta){
                    final int day = value.toInt();
                    if(day == 1 || day == 10 || day == 20 || day == 30){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            '$day日',
                            // 🚀 【优化 7】：X 轴日期文字自适应
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 10)
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: widget.dataList.map((e) => FlSpot(e.day.toDouble(), e.weight)).toList(),
              isCurved: true,
              curveSmoothness: 0.35,
              color: const Color(0xFF4A90E2),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    // 🚀 【优化 8】：普通未激活的趋势圆点核心。黑夜模式下用 cardColor（深灰）填内芯，形成高級的空心通透感！
                    color: isDark ? Theme.of(context).cardColor : Colors.white,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFF4A90E2),
                  );
                },
              ),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // 🚀 【优化 9】：渐变区域黑夜模式下收敛透明度（0.15），白天保持（0.25），防止深夜大面积亮蓝色块晃眼
                        const Color(0xFF4A90E2).withValues(alpha: isDark ? 0.15 : 0.25),
                        const Color(0xFF4A90E2).withValues(alpha: 0.00)
                      ]
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Text(widget.errorMsg ?? "体重曲线绘制失败", style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 14),
              label: const Text("重新加载", style: TextStyle(fontSize: 12)),
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                // 🚀 【优化 10】：重试按钮底色完美适配
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF5F7FA),
                  foregroundColor: isDark ? Colors.white70 : const Color(0xFF434343),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              )
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart_rounded, size: 40, color: isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            "本月还没有记录体重数据",
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}