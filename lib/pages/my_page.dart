import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/provider/theme_provider.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConsumerStatefulWidget();
}

class _ConsumerStatefulWidget extends ConsumerState<ConsumerStatefulWidget>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final bool isDarkMode = themeMode == ThemeMode.dark;
    // 🚀 【换装天眼】：抓取当前系统的黑夜状态
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🚀 【优化 1】：大背景动态自适应（白天现代淡灰，黑夜自动收拢）
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // 🚀 【优化 2】：标题字色自适应主题
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor, // 🚀 【优化 3】：AppBar 底色无缝感应
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8), // 给顶部留一点呼吸间距
          children: [
            _buildCard(
              context,
              AppLocalizations.of(context)!.clearCache,
              onTap: () {
                //实现点击方法
              },
            ),
            _buildCard(
              context,
              AppLocalizations.of(context)!.darkMode,
              trailing: SizedBox(
                height: 32,
                child: Switch(
                  value: isDarkMode,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blue, // 🚀 高级感蓝色轨道
                  inactiveThumbColor: isDark ? const Color(0xFF999999) : Colors.white,
                  inactiveTrackColor: isDark ? Colors.white12 : const Color(0xFFE5E5E5),
                  // 🎯 【核心手术】：狙击未打开时的尴尬黑边
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (!states.contains(WidgetState.selected)) {
                      // 当 Switch 未被选中（未打开）时，强行把边框颜色设为透明，彻底干掉大黑边！
                      return Colors.transparent;
                    }
                    return null; // 打开状态下维持原样或交由系统处理
                  }),
                  onChanged: (value) {
                    // 🚀 【核心修复】：直接通知 Riverpod 改变全局主题，不需要再套一层局部 setState！
                    ref.read(appThemeModeProvider.notifier).toggleTheme(value);
                  },
                ),
              ),
            ),
            _buildCard(
              context,
              AppLocalizations.of(context)!.currentVersion,
              onTap: () {
                //实现点击方法
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "v1.0.0",
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white38 : const Color(0xFFB0B5C1),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, // 🚀 传入 context 以便获取系统主题
      String title, {
        VoidCallback? onTap,
        Widget? trailing,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double cardRadius = 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14), // 优化间距，呼吸感更足
      decoration: BoxDecoration(
        // 🚀 【优化 4】：卡片实体底色对接主题色（白天纯白，夜间采用高级暗灰）
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(cardRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardRadius),
                // 🚀 【优化 5】：卡片边框黑夜微调，利用极低透明度的白边取代硬编码
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
                  width: 0.8,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        // 🚀 【优化 6】：文字颜色动态匹配，白天是高级藏青黑，夜间变亮白
                        color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  trailing ??
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark ? Colors.white38 : const Color(0xFFB0B5C1),
                        size: 22,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}