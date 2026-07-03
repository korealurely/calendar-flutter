import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/provider/theme_provider.dart';
// 🎯 记得引入你刚刚写 appLocaleProvider 的文件路径
import 'package:flutter_calendar/provider/locale_provider.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConsumerStatefulWidget();
}

class _ConsumerStatefulWidget extends ConsumerState<ConsumerStatefulWidget>{
  late bool _isShowLan;

  @override
  void initState() {
    super.initState();
    _isShowLan = false;
  }

  // 🚀 【优化 1】：二次确认删除弹窗，完美支持暗黑换装
  void _confirmClear(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 自动读取暗黑下的卡片底色，不亮瞎眼
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
            AppLocalizations.of(context)!.clearCache,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)
        ),
        content: Text(
          AppLocalizations.of(context)!.clearHint,
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
                  .read(shiftViewModelProvider(DateTime.now().year,DateTime.now().month).notifier)
                  .clearCache();
            },
            child: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final bool isDarkMode = themeMode == ThemeMode.dark;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8),
          children: [
            _buildCard(
              context,
              AppLocalizations.of(context)!.clearCache,
              onTap: () {
                _confirmClear(context, ref);
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
                  activeTrackColor: Colors.blue,
                  inactiveThumbColor: isDark ? const Color(0xFF999999) : Colors.white,
                  inactiveTrackColor: isDark ? Colors.white12 : const Color(0xFFE5E5E5),
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (!states.contains(WidgetState.selected)) return Colors.transparent;
                    return null;
                  }),
                  onChanged: (value) {
                    ref.read(appThemeModeProvider.notifier).toggleTheme(value);
                  },
                ),
              ),
            ),
            _buildLanCard(context), // 🚀 多语言专属卡片
            _buildCard(
              context,
              AppLocalizations.of(context)!.currentVersion,
              onTap: () {},
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "v1.0.0",
                    style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white38 : const Color(0xFFB0B5C1), size: 20),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, {VoidCallback? onTap, Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double cardRadius = 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
      decoration: BoxDecoration(
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
                        color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  trailing ?? Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white38 : const Color(0xFFB0B5C1), size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanCard(BuildContext context){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = ref.watch(appLocaleProvider); // 👁️ 实时监听
    const double cardRadius = 16.0;

    // 🎨 多语言数据套餐
    final List<Map<String, dynamic>> lanOptions = [
      {'name': '简体中文', 'locale': const Locale('zh')},
      {'name': '繁體中文', 'locale': const Locale('zh', 'TW')},
      {'name': 'English', 'locale': const Locale('en')},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
      decoration: BoxDecoration(
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1️⃣ 头部
              InkWell(
                onTap: () => setState(() => _isShowLan = !_isShowLan),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.language,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D3142),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        turns: _isShowLan ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white38 : const Color(0xFFB0B5C1), size: 22),
                      ),
                    ],
                  ),
                ),
              ),

              // 2️⃣ 列表区
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: lanOptions.map((opt) {
                      final Locale targetLocale = opt['locale'];

                      // 🎯 【强化判定】：必须两边的 languageCode 和 countryCode 完全咬合
                      bool isSelected = false;
                      if (currentLocale != null) {
                        isSelected = currentLocale.languageCode == targetLocale.languageCode &&
                            currentLocale.countryCode == targetLocale.countryCode;
                      } else {
                        // 如果本地没存过（currentLocale == null），那手机当前系统语言如果是这一档，就默认亮起它
                        final systemLocale = Localizations.localeOf(context);
                        isSelected = systemLocale.languageCode == targetLocale.languageCode &&
                            systemLocale.countryCode == targetLocale.countryCode;
                      }

                      return InkWell(
                        onTap: () {
                          // 🚀 写入内存 + 写入 Prefs 物理沙盒
                          ref.read(appLocaleProvider.notifier).changeLocale(targetLocale);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected ? Colors.blue : (isDark ? Colors.white60 : const Color(0xFF606266)),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_rounded, color: Colors.blue, size: 20)
                              else
                                const SizedBox(width: 20, height: 20),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                crossFadeState: _isShowLan ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              )
            ],
          ),
        ),
      ),
    );
  }
}