import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';

class MonthGridView extends StatelessWidget {
  final int firstDayOfWeek;
  final int daysInMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDayTap;

  final int year;
  final int month;

  final Map<int, CalendarShift> shiftMap;
  final Map<int, List<CalendarWeight>> weightMap;

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

    // 🚀 【换装天眼 1】：获取当前是否为暗黑模式
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.95,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek) {
          return const SizedBox.shrink();
        }
        int day = index - firstDayOfWeek + 1;

        int targetDateId = year * 10000 + month * 100 + day;
        final currentShift = shiftMap[targetDateId];
        final shiftConfig = currentShift?.config;

        bool isSelected = selectedDate.year == year &&
            selectedDate.month == month &&
            selectedDate.day == day;

        final nowDate = DateTime.now();
        bool isToday = nowDate.year == year &&
            nowDate.month == month &&
            nowDate.day == day;

        // 🎨 【换装核心 2】：基础文字颜色，跟随系统白天/黑夜的大字颜色（白天藏青黑，夜间奶白）
        Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white70 : Colors.black87);
        Color circleColor = Colors.transparent;

        if (isSelected) {
          // 🚀 【换装核心 3】：选中状态适配
          // 如果是黑夜模式，选中的字用亮一点的淡蓝，底色圈圈用带透明度的深蓝，防止刺眼
          textColor = isDark ? const Color(0xFF5A9FFF) : Colors.blue;
          circleColor = isDark ? Colors.blue.withValues(alpha: 0.25) : Colors.blue.withValues(alpha: 0.15);
        } else if (isToday) {
          // 今天但没选中的高亮红，黑夜模式下用稍微带点橙色调的红（比如橙红），在黑底上更醒目
          textColor = isDark ? const Color(0xFFFF5252) : Colors.red;
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
                          color: Colors.white, // 💡 班次格子里的字，不论白天黑夜，统一白色最清晰
                          height: 1.1,
                        ),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: SizedBox(height: 13),
                  ),

                // 3. 🟢 体重小绿点
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Builder(
                    builder: (context) {
                      final hasWeight = weightMap.containsKey(targetDateId) &&
                          weightMap[targetDateId]!.isNotEmpty;

                      if (hasWeight) {
                        return Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            // 🚀 【换装核心 4】：小绿点在黑夜下可以用亮荧光绿，白天用普通绿，视觉质感直接拉满
                            color: isDark ? const Color(0xFF2ECC71) : Colors.green,
                            shape: BoxShape.circle,
                          ),
                        );
                      }
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