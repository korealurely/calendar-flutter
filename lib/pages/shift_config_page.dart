import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_calendar/pages/shift_pattern_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';

// 🚀 引入咱们的硬核 Diff 动画库
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:flutter_calendar/view/shift_config_edit_bottom_sheet.dart';

class ShiftConfigPage extends ConsumerWidget {
  const ShiftConfigPage({super.key});

  // 🚀 【优化 1】：二次确认删除弹窗，完美支持暗黑换装
  void _confirmDelete(BuildContext context, WidgetRef ref, ShiftConfig config) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 自动读取暗黑下的卡片底色，不亮瞎眼
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
            AppLocalizations.of(context)!.confirmDel,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteConfigConfirmContent(config.name),
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252), // 暗黑下更通透的红
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref
                  .read(shiftConfigViewModelProvider.notifier)
                  .deleteConfigById(config.id);
            },
            child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configListSync = ref.watch(shiftConfigViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🚀 【优化 2】：脚手架背景自适应（白天浅灰，夜间纯黑）
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.shiftManagement,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color, // 🚀 文字自适应
          ),
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
            child:  Text(AppLocalizations.of(context)!.pattern, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
        ],
        backgroundColor: Theme.of(context).cardColor, // 🚀 顶栏自适应
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white70 : Colors.black87), // 🚀 返回键图标自适应
      ),
      body: configListSync.when(
        data: (dbList) {
          if (dbList.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noShiftConfigHint,
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
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
                child: _buildShiftCard(context, ref, config, index, isShadow: false), // 修正：你的卡片里默认带尾部删除按钮，应该是 isShadow: false 吧
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => ShiftConfigEditBottomSheet(config: null),
          );
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.addShift,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      key: ValueKey(config.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // 🚀 【优化 3】：暗黑模式下的卡片阴影弱化收敛
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Theme.of(context).cardColor, // 🚀 【优化 4】：卡片底色全自动适配
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04), // 🚀 边框弱化
                width: 0.8,
              ),
            ),
            child: ListTile(
              onTap: () {
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
                    color: Colors.white, // 班次标签里的字固定白色最清晰
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                config.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color, // 🚀 【优化 5】：班次名字颜色自适应
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 13,
                      color: isDark ? Colors.white38 : Colors.grey.withValues(alpha: 0.8), // 🚀 图标提亮
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${config.startTime} - ${config.endTime}",
                      style: TextStyle(
                        // 🚀 【优化 6】：时间范围颜色适配
                        color: isDark ? Colors.white60 : const Color(0xFF909399),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: !isShadow
                  ? IconButton(
                onPressed: () {
                  // 🚀 顺手帮你把删除按钮的二次确认弹窗接通
                  _confirmDelete(context, ref, config);
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF5252), // 暗黑模式下也极其漂亮的荧光红
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