import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/shift_pattern_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';

// 🚀 引入咱们刚刚导进来的硬核 Diff 动画库
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:flutter_calendar/view/shift_config_edit_bottom_sheet.dart';

class ShiftConfigPage extends ConsumerWidget {
  const ShiftConfigPage({super.key});

  //弹出窗口
  void _confirmDelete(BuildContext context, WidgetRef ref, ShiftConfig config) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("确认删除"),
        content: Text("确定要删除【${config.name}】吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("算了"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref
                  .read(shiftConfigViewModelProvider.notifier)
                  .deleteConfigById(config.id);
            },
            child: const Text("删除", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final configListSync = ref.watch(shiftConfigViewModelProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "班次管理",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => const ShiftPatternPage(),
                ),
              );
            },
            child: Text("模式",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: configListSync.when(
        data: (dbList) {
          if (dbList.isEmpty) {
            return const Center(
              child: Text(
                "暂无班次配置，点击右下角+添加",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ImplicitlyAnimatedList<ShiftConfig>(
            items: dbList,
            padding: const EdgeInsets.only(top: 12, bottom: 86),
            physics: const BouncingScrollPhysics(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            itemBuilder: (context, animation, config, index) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildShiftCard(context, ref, config, index),
              );
            },
            removeItemBuilder: (context, animation, config) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOutCubic,
                animation: animation,
                child: _buildShiftCard(context, ref, config, 0, isShadow: true),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 3)),
        error: (err, _) => Center(
          child: Text("翻车了：$err", style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("添加班次");
          // Navigator.of(context, rootNavigator: false).push(
          //   MaterialPageRoute(
          //     builder: (context) => const ShiftPatternPage(),
          //   ),
          // );
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => ShiftConfigEditBottomSheet(config: null),
          );
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "添加班次",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildShiftCard(
    BuildContext context,
    WidgetRef ref,
    ShiftConfig config,
    int index, {
    bool isShadow = true,
  }) {
    return Padding(
      key: ValueKey(config.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            child: ListTile(
              onTap: () {
                //_confirmDelete(context, ref, config);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      ShiftConfigEditBottomSheet(config: config),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(config.colorValue),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  config.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                config.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2D3142),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 13,
                      color: Colors.grey.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${config.startTime} - ${config.endTime}",
                      style: const TextStyle(
                        color: Color(0xFF909399),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: !isShadow
                  ? IconButton(
                      onPressed: () => {
                        //_confirmDelete(context, ref, config)
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
