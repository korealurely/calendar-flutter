// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get myPageTitle => '我的';

  @override
  String get clearCache => '清除缓存';

  @override
  String get darkMode => '黑夜模式';

  @override
  String get currentVersion => '当前版本';

  @override
  String get homePage => '主页';

  @override
  String get shift => '排班';

  @override
  String get statistic => '统计';

  @override
  String get my => '我的';

  @override
  String yearMonthDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String monthDayDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get sun => '日';

  @override
  String get detail => '详情';

  @override
  String get noShift => '暂无排班';

  @override
  String get noShiftHint => '今天没有排班计划，睡个大懒觉吧~';

  @override
  String get startShift => '上班时间';

  @override
  String get endWork => '下班时间';

  @override
  String get editShift => '修改班次';

  @override
  String get selectShiftType => '选择班次类型';

  @override
  String get clearShift => '清除/休息';

  @override
  String get confirm => '确定';

  @override
  String get loadErr => '加载失败:';

  @override
  String get weight => '体重';

  @override
  String get noData => '暂无数据';

  @override
  String get noWeightHint => '今天还没称体重呢，点击记录一下吧~';

  @override
  String get shiftManagement => '班次管理';

  @override
  String get pattern => '模式';

  @override
  String get addShift => '添加班次';

  @override
  String get shiftNameHint => '班次名称（如: 早班）';

  @override
  String get shiftLabelHint => '日历格子标签（如: 早）';

  @override
  String get to => '至';

  @override
  String get customColor => '专属颜色';

  @override
  String get setColor => '点击设定颜色';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get shiftErrMsg => '请完整填写班次名称和标签！';

  @override
  String get setShiftColor => '选择班次颜色';

  @override
  String get patternManagement => '周期模式管理';

  @override
  String get noPatternHint => '暂无模式配置，点击下方按钮添加';

  @override
  String get addPattern => '添加周期模式';

  @override
  String get weekPattern => '固定周';

  @override
  String get custom => '自定义';

  @override
  String get confirmDel => '确定删除';

  @override
  String get confirmDelHint => '确定要删除吗？';

  @override
  String get generateShifts => '排班生成';

  @override
  String get generatePattern => '模式生成';

  @override
  String get weekSetLabel => '配置一周七天循环班次';

  @override
  String get mon1 => '周一';

  @override
  String get tue1 => '周二';

  @override
  String get wed1 => '周三';

  @override
  String get thu1 => '周四';

  @override
  String get fri1 => '周五';

  @override
  String get sat1 => '周六';

  @override
  String get sun1 => '周日';

  @override
  String get customShiftLabel => '自由定义排班顺序（从左往右按顺序循环）';

  @override
  String get unknownShift => '未知班次';

  @override
  String get add => '追加';

  @override
  String get dateRange => '生效日期范围';

  @override
  String get dataStatistic => '数据统计';

  @override
  String get shiftStatistic => '班次统计';

  @override
  String get staticErrorHint => '数据对账有些小失败';

  @override
  String get reload => '重新加载';

  @override
  String get noShiftStatHint => '本月暂无排班统计数据哦~';

  @override
  String get totalDays => '总天数';

  @override
  String get day => '天';

  @override
  String get weightStat => '体重趋势';

  @override
  String get day1 => '日';

  @override
  String get weightStatError => '体重曲线绘制失败';

  @override
  String get weightStatHint => '本月还没有记录体重数据';

  @override
  String get workTimeStat => '工时统计';

  @override
  String get hour => '小时';

  @override
  String get workStatError => '工时统计加载失败';

  @override
  String get workStatHint => '本月还没有登记工时数据哦~';

  @override
  String get language => '语言';

  @override
  String get noShiftConfigHint => '暂无班次配置，点击右下角+添加';

  @override
  String deleteConfigConfirmContent(String configName) {
    return '确定要删除【$configName】吗？';
  }

  @override
  String get clearHint => '确定清空所有数据吗？';

  @override
  String get sync => '同步';

  @override
  String get syncHint => '确定同步到系统日历吗?';

  @override
  String get syncData => '同步数据';

  @override
  String get syncSuccess => '同步数据成功!';

  @override
  String get syncFailCheck => '同步数据失败，请检查数据是否完整或APP是否具有系统日历读取权限';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get myPageTitle => '我的';

  @override
  String get clearCache => '清除快取';

  @override
  String get darkMode => '黑夜模式';

  @override
  String get currentVersion => '當前版本';

  @override
  String get homePage => '主頁';

  @override
  String get shift => '排班';

  @override
  String get statistic => '統計';

  @override
  String get my => '我的';

  @override
  String yearMonthDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String monthDayDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get sun => '日';

  @override
  String get detail => '詳情';

  @override
  String get noShift => '暫無排班';

  @override
  String get noShiftHint => '今天沒有排班計劃，睡個大懶覺吧~';

  @override
  String get startShift => '上班時間';

  @override
  String get endWork => '下班時間';

  @override
  String get editShift => '修改班次';

  @override
  String get selectShiftType => '選擇班次類型';

  @override
  String get clearShift => '清除／休息';

  @override
  String get confirm => '確定';

  @override
  String get loadErr => '加載失敗:';

  @override
  String get weight => '體重';

  @override
  String get noData => '暫無資料';

  @override
  String get noWeightHint => '今天還沒稱體重呢，點擊記錄一下吧~';

  @override
  String get shiftManagement => '班次管理';

  @override
  String get pattern => '模式';

  @override
  String get addShift => '新增班次';

  @override
  String get shiftNameHint => '班次名稱（如：早班）';

  @override
  String get shiftLabelHint => '日曆格子標籤（如：早）';

  @override
  String get to => '至';

  @override
  String get customColor => '專屬顏色';

  @override
  String get setColor => '點擊設定顏色';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get shiftErrMsg => '請完整填寫班次名稱和標籤！';

  @override
  String get setShiftColor => '選擇班次顏色';

  @override
  String get patternManagement => '週期模式管理';

  @override
  String get noPatternHint => '暫無模式配置，點擊下方按鈕新增';

  @override
  String get addPattern => '新增週期模式';

  @override
  String get weekPattern => '固定週';

  @override
  String get custom => '自訂';

  @override
  String get confirmDel => '確定刪除';

  @override
  String get confirmDelHint => '確定要刪除嗎？';

  @override
  String get generateShifts => '排班生成';

  @override
  String get generatePattern => '模式生成';

  @override
  String get weekSetLabel => '配置一週七天循環班次';

  @override
  String get mon1 => '週一';

  @override
  String get tue1 => '週二';

  @override
  String get wed1 => '週三';

  @override
  String get thu1 => '週四';

  @override
  String get fri1 => '週五';

  @override
  String get sat1 => '週六';

  @override
  String get sun1 => '週日';

  @override
  String get customShiftLabel => '自由定義排班順序（從左往右按順序循環）';

  @override
  String get unknownShift => '未知班次';

  @override
  String get add => '追加';

  @override
  String get dateRange => '生效日期範圍';

  @override
  String get dataStatistic => '資料統計';

  @override
  String get shiftStatistic => '班次統計';

  @override
  String get staticErrorHint => '資料對帳有些小失敗';

  @override
  String get reload => '重新加載';

  @override
  String get noShiftStatHint => '本月暫無排班統計資料哦~';

  @override
  String get totalDays => '總天數';

  @override
  String get day => '天';

  @override
  String get weightStat => '體重趨勢';

  @override
  String get day1 => '日';

  @override
  String get weightStatError => '體重曲線繪製失敗';

  @override
  String get weightStatHint => '本月還沒有記錄體重資料';

  @override
  String get workTimeStat => '工時統計';

  @override
  String get hour => '小時';

  @override
  String get workStatError => '工時統計加載失敗';

  @override
  String get workStatHint => '本月還沒有登記工時資料哦~';

  @override
  String get language => '語言';

  @override
  String get noShiftConfigHint => '暫無班次配置，點擊右下角＋新增';

  @override
  String deleteConfigConfirmContent(String configName) {
    return '確定要刪除【$configName】嗎？';
  }

  @override
  String get clearHint => '確定清空所有資料嗎？';

  @override
  String get sync => '同步';

  @override
  String get syncHint => '確定要同步到系統行事曆嗎？';

  @override
  String get syncData => '同步資料';

  @override
  String get syncSuccess => '同步資料成功！';

  @override
  String get syncFailCheck => '同步資料失敗，請檢查資料是否完整或APP是否具有系統行事曆讀取權限';
}
