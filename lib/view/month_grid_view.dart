import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/calendar_shift.dart'; // 💥 确保引入了你的排班模型
import 'package:flutter_calendar/data/calendar_weight.dart';

class MonthGridView extends StatelessWidget {
  final int firstDayOfWeek;
  final int daysInMonth;
  final DateTime selectedDate; // 当前选中日期
  final ValueChanged<DateTime> onDayTap; // 点击回调函数

  final int year;
  final int month;

  // 📡 从外层 PageView 传进来的、带着全量配置的当月排班大字典
  final Map<int, CalendarShift> shiftMap;

  final Map<int,List<CalendarWeight>> weightMap;

  const MonthGridView({
    super.key,
    required this.firstDayOfWeek,
    required this.daysInMonth,
    required this.selectedDate,
    required this.onDayTap,
    required this.year,
    required this.month,
    required this.shiftMap,
    required this.weightMap,
  });

  @override
  Widget build(BuildContext context) {
    int totalItems = firstDayOfWeek + daysInMonth;

    return GridView.builder(
      shrinkWrap: true, // 💥 必须加这句！否则页面还是会报错
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4, // 格子行间距不宜过大
        crossAxisSpacing: 4,
        childAspectRatio: 0.95, // 💥 拉高纵向空间，给数字下方的小方格留出精致的生存空间
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek) {
          return const SizedBox.shrink();
        }
        int day = index - firstDayOfWeek + 1;

        // 🎯 算出当天的绝对身份证 dateId (例如 20260606)
        int targetDateId = year * 10000 + month * 100 + day;
        final currentShift = shiftMap[targetDateId];
        final shiftConfig = currentShift?.config; // 拿到内存里缝合好的具体配置

        bool isSelected = selectedDate.year == year &&
            selectedDate.month == month &&
            selectedDate.day == day;

        final nowDate = DateTime.now();
        bool isToday = nowDate.year == year &&
            nowDate.month == month &&
            nowDate.day == day;

        // 🎨 样式分流：数字文本颜色控制
        Color textColor = Colors.black87;
        Color circleColor = Colors.transparent; // 基础网格大背景

        if (isSelected) {
          textColor = Colors.blue; // 优先满足：被选中的颜色
          circleColor = Colors.blue.withValues(alpha: 0.15); // 选中时的圆形浅色背景
        } else if (isToday) {
          textColor = Colors.red; // 其次满足：如果是今天，但没被选中，显示高亮色
        } else if (shiftConfig != null) {
          // 如果有班次，文字可以稍微加深或者配合班次颜色微调，这里保持舒适的黑白对比
          textColor = Colors.black87;
        }

        return GestureDetector(
          onTap: () => onDayTap(DateTime(year, month, day)),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. 日期数字
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),

                // 2. 🚀 精致的小方格班次标签
                if (shiftConfig != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Color(shiftConfig.colorValue),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        shiftConfig.label,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  )
                else
                // 💡 占位符：保证没班次时，下方的绿点也不会往上顶
                  const Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: SizedBox(height: 13),
                  ),

                // 3. 🟢 【全新魔改】：体重小绿点
                Padding(
                  padding: const EdgeInsets.only(top: 4.0), // 跟上方的班次标签拉开小距离
                  child: Builder(
                    builder: (context) {
                      // 🎯 检查 weightMap 里有没有当天的体重记录（并且列表不为空）
                      final hasWeight = weightMap.containsKey(targetDateId) &&
                          weightMap[targetDateId]!.isNotEmpty;

                      if (hasWeight) {
                        return Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Colors.green, // 🟩 充满生机的小绿点
                            shape: BoxShape.circle,
                          ),
                        );
                      }
                      // 💡 黄金防抖细节：如果没有体重，塞一个等高的透明占位符
                      // 确保所有日期格子的数字和标签都在同一起跑线！
                      return const SizedBox(height: 5);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}