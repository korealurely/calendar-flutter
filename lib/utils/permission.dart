import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';// 引入你的多语言
import 'package:permission_handler/permission_handler.dart';

/// 纯 Dart 获取安卓 SDK 版本（无需任何第三方库）
int _getAndroidSdkInt() {
  if (!Platform.isAndroid) return 0;
  try {
    final versionString = Platform.operatingSystemVersion;
    final regExp = RegExp(r'API\s+(\d+)');
    final match = regExp.firstMatch(versionString);
    if (match != null) {
      return int.parse(match.group(1) ?? '0');
    }
  } catch (e) {
    debugPrint("获取系统版本失败: $e");
  }
  return 0;
}

/// 🎯 申请通知权限（完美兼容 Android 10、13+ 以及 iOS 全版本）
Future<void> requestNotificationPermission({
  required BuildContext context,
  required VoidCallback onGranted,
  required VoidCallback onDenied,
}) async {

  PermissionStatus status = await Permission.notification.status;

  // ==================== 1. 安卓端特异性兼容 ====================
  if (Platform.isAndroid) {
    final sdkInt = _getAndroidSdkInt();
    if (sdkInt < 33) {
      if (status.isDenied || status.isPermanentlyDenied) {
        onDenied();
        _showRedirectDialog(context);
        return;
      }
      onGranted();
      return;
    }
  }

  // ==================== 2. iOS 端 & Android 13+ 动态请求 ====================
  // 🎯 修改点 1：只有在真正被拒绝（isDenied）时，才去调用 request()
  // 如果是 provisional，直接跳过 request()，不要打扰系统
  if (status.isDenied) {
    status = await Permission.notification.request();
  }

  // 🎯 修改点 2：最终判定时，将 isGranted 和 isProvisional 都视为“已授权”
  if (status.isGranted || status.isProvisional) {
    onGranted();
  } else {
    onDenied();

    // 只有在明确被永久拒绝（isPermanentlyDenied）时，才弹窗引导去设置
    if (status.isPermanentlyDenied) {
      _showRedirectDialog(context);
    }
  }
}

/// 📱 弹框提示去系统设置开启通知（支持多语言，双端通用）
void _showRedirectDialog(BuildContext context) {
  //final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.openNotice, // arb: "开启提醒"
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(AppLocalizations.of(context)!.noticeHint), // arb: "为了确保排班闹钟能准时响铃..."
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.later, // arb: "稍后"
              style: const TextStyle(color: Colors.grey),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.goToSetting, // arb: "去设置"
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              // 🚀 openAppSettings() 在 iOS 上极为强大，会自动精准跳转到“追梦日历”的 iOS 系统设置页
              await openAppSettings();
            },
          ),
        ],
      );
    },
  );
}