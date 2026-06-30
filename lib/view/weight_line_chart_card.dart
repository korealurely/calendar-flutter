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

class _WeightLineChartCard extends State<WeightLineChartCard>{
  //点击的体重点
  LineBarSpot? touchedSpot;
  
  @override
  Widget build(BuildContext context) {
    final dateStr = "${widget.currentMonth.year}年${widget.currentMonth.month.toString().padLeft(2,'0')}月";
    
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
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //头部标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  child: Text(
                    "体重趋势",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xFF1F1F1F)
                    ),
                  )
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: widget.isLoading ? null : (){
                        final preMonth = DateTime(widget.currentMonth.year,widget.currentMonth.month -1);
                        widget.onMonthChanged(preMonth);
                      }, 
                      icon: const Icon(Icons.chevron_left_rounded,color: Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(dateStr,style:TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Color(0xFF1F1F1F))),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: widget.isLoading ? null : (){
                      final nextMonth = DateTime(widget.currentMonth.year,widget.currentMonth.month + 1);
                      widget.onMonthChanged(nextMonth);
                    },
                    icon: const Icon(Icons.chevron_right_rounded,color: Color(0xFF434343)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 24),

          //分流
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
    //取得当月体重峰值
    final weights = widget.dataList.map((e) => e.weight).toList();
    final double maxW = weights.reduce(max);
    final double minW = weights.reduce(min);

    //计算y轴峰值
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
              getTooltipColor: (spot) => const Color(0xFF1F1F1F),
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchSpots){
                return touchSpots.map((barSpot){
                  return LineTooltipItem(
                      "${barSpot.y.toStringAsFixed(2)} kg",
                      const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),
                  );
                }).toList();
              }
            ),
            getTouchedSpotIndicator: (LineChartBarData barData,List<int> spotIndexes){
              return spotIndexes.map((spotIndex){
                return TouchedSpotIndicatorData(
                    FlLine(color: const Color(0xFF4A90E2).withValues(alpha: 0.3),strokeWidth: 2,dashArray: [4,4]),
                    FlDotData(
                      getDotPainter: (spot,percent,barData,index) => FlDotCirclePainter(
                        radius: 6,
                        color: const Color(0xFF4A90E2),
                        strokeWidth: 2,
                        strokeColor: Colors.white
                      ),
                    )
                );
              }).toList();
            },
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 3,//切成三条参考线
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
              dashArray: [5,5]
            ),
          ),
          borderData: FlBorderData(show: false),//四周边框
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
                interval: (maxY - minY) / 2, // 保持两等分步长不变
                getTitlesWidget: (value, meta) {
                  // 1. 安全守卫：超出最大值的一律人间蒸发
                  if (value > maxY + 0.05) return const SizedBox.shrink();

                  // 2. 人肉算出完美的中点
                  final double midY = minY + (maxY - minY) / 2;

                  // 3. 扩大捕捉网（由于轴距是 2.9，用 0.1 的容错率可以精准、且唯一地抓到这三个点）
                  bool isBottom = (value - minY).abs() < 0.1;
                  bool isCenter = (value - midY).abs() < 0.1;
                  bool isTop    = (value - maxY).abs() < 0.1;

                  if (isBottom || isCenter || isTop) {
                    // 🎯 核心纠偏：如果被我们抓到了，就绝对不用 value
                    // 而是直接把我们算好的目标值塞给它，当场消除浮点数变形！
                    double targetValue = value;
                    if (isBottom) targetValue = minY;   // 74.48
                    if (isCenter) targetValue = midY;   // 77.38
                    if (isTop)    targetValue = maxY;   // 80.28

                    return Text(
                      // 🚀 这里推荐保留 1 位小数，展示 74.5、77.4、80.3，非常精准！
                      // 如果你非要纯整数，就改成 .toStringAsFixed(0)，它会显示完美的 74、77、80，绝不会出 75 和 78！
                      targetValue.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.black26,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  // 其他被浮点数对齐机制带出来的杂质，一律抹杀
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 1,
                getTitlesWidget: (value,meta){
                  final int day = value.toInt();
                  if(day == 1 || day == 10 || day == 20 || day == 30){
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('$day日',style: const TextStyle(color:Colors.black38,fontSize: 10)),
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
              isCurved: true,//平滑曲线
              curveSmoothness: 0.35,
              color: const Color(0xFF4A90E2),
              barWidth: 3,
              isStrokeCapRound: true,
              // 🚀 【关键配置】：控制数据的 dot 点
              dotData: FlDotData(
                show: true, // 确保开启显示点
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,                      // 圆点的半径（大小）
                    color: Colors.white,            // 圆点的填充颜色（比如改成白色底）
                    strokeWidth: 2,                 // 圆点外边框的粗细
                    strokeColor: const Color(0xFF4A90E2), // 外边框的颜色（让它跟折线颜色一致，非常精致）
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF4A90E2).withValues(alpha: 0.25),
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
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,size: 40,color: Colors.redAccent.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Text(widget.errorMsg ?? "体重曲线绘制失败",style: const TextStyle(fontSize: 11,color: Colors.black38)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded,size: 14),
              label: const Text("重新加载",style: TextStyle(fontSize: 12)),
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F7FA),
                foregroundColor: const Color(0xFF434343),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              )
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart_rounded,size: 40,color:Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          const Text("本月还没有记录体重数据",
            style: TextStyle(fontSize: 13,color: Colors.grey,fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}