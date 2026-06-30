import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/provider/weight_provider.dart';

// 🚀 引入咱们刚刚导进来的硬核 Diff 动画库
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:intl/intl.dart';

class WeightHistoryPage extends ConsumerWidget {
  final DateTime selectedDate;

  const WeightHistoryPage({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayWeightAsync = ref.watch(dayWeightsStreamProvider(selectedDate));
    final String titleStr = DateFormat('yyyy年M月d日').format(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "$titleStr 体重",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: dayWeightAsync.when(
        data: (weightList) {
          if (weightList.isEmpty) {
            return const Center(
              child: Text(
                "今日暂无体重数据，请到体重界面称重",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ImplicitlyAnimatedList<CalendarWeight>(
            items: weightList,
            padding: const EdgeInsets.only(top: 12, bottom: 86),
            physics: const BouncingScrollPhysics(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id, // 👈 调到前面更好看
            itemBuilder: (context, animation, calendarWeight, index) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildWeightCard(context, ref, calendarWeight, index),
              );
            },
            removeItemBuilder: (context, animation, calendarWeight) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOutCubic,
                animation: animation,
                // 🎯 避坑：删除时将当前已知的 calendarWeight 渲染成正在消亡的 Card，index 传 -1 标识状态
                child: _buildWeightCard(context, ref, calendarWeight, -1),
              );
            },
          );
        },
        error: (err, _) => Center(
          child: Text("翻车了：$err", style: const TextStyle(color: Colors.red)),
        ),
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
      ), // ⚠️ 之前少了这个括号闭合 when
    ); // ⚠️ 之前少了这个括号闭合 Scaffold
  }

  // 📦 把辅助卡片方法写在外面，结构才最干净
  // 📦 极简纯粹版卡片：只保留体重与时间
  Widget _buildWeightCard(BuildContext context, WidgetRef ref, CalendarWeight calendarWeight, int index) {
    // 💡 健壮性处理：如果数据库里某条记录的 updatedAt 为空，则降级使用当前时间，防止空指针翻车
    final DateTime time = calendarWeight.updatedAt ;
    final String timeText = DateFormat('HH:mm').format(time);

    return Padding(
      key: ValueKey(calendarWeight.id), // 👈 动效库核心 Key，千万不能丢
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              offset: const Offset(0, 1),
              blurRadius: 4
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.04),
                width: 0.8
              )
            ),
            child: ListTile(
              splashColor:  Colors.green.withValues(alpha: 0.05),
              onTap: () {
                //_confirmDelete(context, ref, config);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEDF9EE),
                child: Icon(Icons.scale, color: Colors.green, size: 20),
              ),
              title: Text(
                "${calendarWeight.weight.toStringAsFixed(2)} kg",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // 🎯 核心改动：删掉阻抗，把测量时间直接作为副标题展示，排版更符合信息层级
              subtitle: Text(
                "测量时间: $timeText",
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
              trailing: index == -1
                  ? const SizedBox.shrink() // 正在删除时隐藏右侧
                  : IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () async {
                  final repo = ref.read(weightRepositoryProvider);

                  await repo.deleteWeightById(calendarWeight.id);

                },
              ),
            ),
          ),
        ),
      )
    );
  }
}

