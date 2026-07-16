import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'alarm_switch_provider.g.dart';

const String _alarmSwitchPreferenceKey = "alarm_switch_key";

@riverpod
class AlarmSwitch extends _$AlarmSwitch{

  late SharedPreferences _prefs;

  // 🎯 1. 把 build 改为异步返回 Future<bool>
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    // 直接在这里读取并返回，Riverpod 会自动把这个值包装成 AsyncData 传给 UI
    return prefs.getBool(_alarmSwitchPreferenceKey) ?? false;
  }

  // 🎯 2. 提供一个优雅的修改方法
  Future<void> toggle(bool newValue) async {
    // 强制进入加载状态，防止用户高频连点
    state = const AsyncValue.loading();

    // 使用 guard 保护异步操作，如果写入失败会自动捕获异常存入 state.error
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_alarmSwitchPreferenceKey, newValue);
      return newValue; // 写入成功，返回新状态
    });
  }
}