import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const String _themePreferenceKey = "app_theme_mode_key";

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  // 🚀 1. 增加一个可选的初始值属性
  final ThemeMode? _initialMode;

  // 🚀 2. 增加一个构造函数，允许外界把冷启动读出来的缓存塞进来
  AppThemeMode([this._initialMode]);

  @override
  ThemeMode build() {
    // 🚀 3. 如果外界传了初始值，就用初始值；否则兜底用系统天色
    return _initialMode ?? ThemeMode.system;
  }

  /// 切换主题并一键持久化缓存
  Future<void> toggleTheme(bool isDark) async {
    final targetMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (state == targetMode) return;

    state = targetMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, targetMode.name);
  }
}