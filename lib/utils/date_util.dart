// lib/utils/date_util.dart

class DateUtil {
  // 💡 避坑细节：私有化构造函数，这样外部就无法调用 DateUtil() 去实例化它。
  // 因为工具类只需要通过类名直接点出方法，不需要实例化对象。
  DateUtil._();

  /// 计算两个年月之间相差的月份数
  ///
  /// 公式：(目标年 - 起始年) * 12 + (目标月 - 起始月)
  /// 返回正数代表目标年月在起始年月【之后】，负数代表在【之前】
  static int getMonthDistance({
    required int targetYear,
    required int targetMonth,
    required int startYear,
    required int startMonth,
  }) {
    int yearDifference = targetYear - startYear;
    int monthDifference = targetMonth - startMonth;
    return (yearDifference * 12) + monthDifference;
  }

  /// 【扩展实用方法】获取当前系统的真实年份和月份
  /// 方便你随时拿去跟基准日期做对比
  static Map<String, int> getCurrentYearMonth() {
    DateTime now = DateTime.now();
    return {
      'year': now.year,
      'month': now.month,
    };
  }

  static double calculateTimeDifference(String? time1, String? time2) {
    // 1. 严格空值校验
    if (time1 == null || time2 == null || time1.isEmpty || time2.isEmpty) {
      return 0.0;
    }

    try {
      // 2. 使用 trim() 剔除前后可能存在的隐形空格
      //    同时，如果有些地方传过来带秒（HH:MM:SS），直接取前两位，自动过滤掉秒
      List<String> parts1 = time1.trim().split(':');
      List<String> parts2 = time2.trim().split(':');

      // 只要长度不小于 2 即可（兼容 HH:MM 和 HH:MM:SS）
      if (parts1.length < 2 || parts2.length < 2) {
        print("【工时计算错误】格式不正确: time1=$time1, time2=$time2");
        return 0.0; // 安全返回，不崩溃
      }

      int hour1 = int.parse(parts1[0]);
      int minute1 = int.parse(parts1[1]);
      int hour2 = int.parse(parts2[0]);
      int minute2 = int.parse(parts2[1]);

      // 3. 验证数值有效性
      if (hour1 < 0 || hour1 > 23 || minute1 < 0 || minute1 > 59 ||
          hour2 < 0 || hour2 > 23 || minute2 < 0 || minute2 > 59) {
        print("【工时计算错误】数值越界: time1=$time1, time2=$time2");
        return 0.0;
      }

      // 4. 创建基准时间
      DateTime dateTime1 = DateTime(2023, 1, 1, hour1, minute1);
      DateTime dateTime2 = DateTime(2023, 1, 1, hour2, minute2);

      // 🚀 额外考虑一种业务场景：如果是跨天打卡（比如 22:00 上班，次日 06:00 下班）
      // 如果结束时间比开始时间小，说明跨天了，自动给结束时间加 1 天
      if (dateTime2.isBefore(dateTime1) || dateTime2.isAtSameMomentAs(dateTime1)) {
        dateTime2 = dateTime2.add(const Duration(days: 1));
      }

      Duration difference = dateTime2.difference(dateTime1);

      // 💡 优化计算：直接用 inMinutes 算分钟，再除以 60.0，比用毫秒除以那大一串数字更不容易丢精度，也更直观
      double hoursDifference = difference.inMinutes / 60.0;

      // 根据业务需要，如果你不希望跨天算负数，或者一定要正数，用 abs()；
      // 如果上面加了跨天处理，这里直接返回即可
      return double.parse(hoursDifference.toStringAsFixed(1)); // 顺手保留一位小数，更符合工时习惯

    } catch (e) {
      print("【工时计算致命异常】: $e");
      return 0.0; // 线上环境安全兜底，不至于让用户卡死白屏
    }
  }
}