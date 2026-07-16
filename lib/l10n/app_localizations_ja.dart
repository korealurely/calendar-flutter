// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get myPageTitle => 'マイページ';

  @override
  String get clearCache => 'キャッシュをクリア';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get currentVersion => '現在のバージョン';

  @override
  String get homePage => 'ホーム';

  @override
  String get shift => 'シフト';

  @override
  String get statistic => '統計';

  @override
  String get my => 'マイページ';

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
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get detail => '詳細';

  @override
  String get noShift => 'シフトなし';

  @override
  String get noShiftHint => '今日はシフトがありません。ゆっくり休みましょう～';

  @override
  String get startShift => '出勤時間';

  @override
  String get endWork => '退勤時間';

  @override
  String get editShift => 'シフト編集';

  @override
  String get selectShiftType => 'シフトタイプを選択';

  @override
  String get clearShift => 'クリア／休み';

  @override
  String get confirm => '確定';

  @override
  String get loadErr => '読み込み失敗:';

  @override
  String get weight => '体重';

  @override
  String get noData => 'データなし';

  @override
  String get noWeightHint => '今日はまだ体重を記録していません。クリックして記録しましょう～';

  @override
  String get shiftManagement => 'シフト管理';

  @override
  String get pattern => 'パターン';

  @override
  String get addShift => 'シフト追加';

  @override
  String get shiftNameHint => 'シフト名（例：早番）';

  @override
  String get shiftLabelHint => 'カレンダーラベル（例：早）';

  @override
  String get to => 'から';

  @override
  String get customColor => '専用カラー';

  @override
  String get setColor => 'クリックしてカラーを設定';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get shiftErrMsg => 'シフト名とラベルをすべて入力してください！';

  @override
  String get setShiftColor => 'シフトカラーを選択';

  @override
  String get patternManagement => '周期パターン管理';

  @override
  String get noPatternHint => 'パターンがありません。下のボタンから追加してください';

  @override
  String get addPattern => '周期パターン追加';

  @override
  String get weekPattern => '固定週';

  @override
  String get custom => 'カスタム';

  @override
  String get confirmDel => '削除を確定';

  @override
  String get confirmDelHint => '本当に削除しますか？';

  @override
  String get generateShifts => 'シフト生成';

  @override
  String get generatePattern => 'パターン生成';

  @override
  String get weekSetLabel => '1週間7日間のシフトを設定';

  @override
  String get mon1 => '月曜日';

  @override
  String get tue1 => '火曜日';

  @override
  String get wed1 => '水曜日';

  @override
  String get thu1 => '木曜日';

  @override
  String get fri1 => '金曜日';

  @override
  String get sat1 => '土曜日';

  @override
  String get sun1 => '日曜日';

  @override
  String get customShiftLabel => 'シフト順序を自由に設定（左から右へ順番にループ）';

  @override
  String get unknownShift => '不明なシフト';

  @override
  String get add => '追加';

  @override
  String get dateRange => '有効日範囲';

  @override
  String get dataStatistic => 'データ統計';

  @override
  String get shiftStatistic => 'シフト統計';

  @override
  String get staticErrorHint => 'データ照合に一部失敗しました';

  @override
  String get reload => '再読み込み';

  @override
  String get noShiftStatHint => '今月はシフト統計データがありません～';

  @override
  String get totalDays => '合計日数';

  @override
  String get day => '日';

  @override
  String get weightStat => '体重推移';

  @override
  String get day1 => '日';

  @override
  String get weightStatError => '体重グラフの描画に失敗しました';

  @override
  String get weightStatHint => '今月はまだ体重データが記録されていません';

  @override
  String get workTimeStat => '勤務時間統計';

  @override
  String get hour => '時間';

  @override
  String get workStatError => '勤務時間統計の読み込みに失敗しました';

  @override
  String get workStatHint => '今月はまだ勤務時間データが登録されていません～';

  @override
  String get language => '言語';

  @override
  String get noShiftConfigHint => 'シフト設定がありません。右下の「＋」から追加してください';

  @override
  String deleteConfigConfirmContent(String configName) {
    return '【$configName】を本当に削除しますか？';
  }

  @override
  String get clearHint => 'すべてのデータを本当にクリアしますか？';

  @override
  String get sync => '同期';

  @override
  String get syncHint => 'システムカレンダーに同期しますか？';

  @override
  String get syncData => 'データ同期';

  @override
  String get syncSuccess => 'データ同期に成功しました！';

  @override
  String get syncFailCheck =>
      'データ同期に失敗しました。データが完全か、またはアプリにシステムカレンダーの読み取り権限があるかご確認ください。';

  @override
  String get systemNotice => 'システム通知';

  @override
  String get openNotice => '通知をオンにする';

  @override
  String get noticeHint => 'シフトアラームが時間通りに鳴るように、設定で通知権限をオンにしてください。';

  @override
  String get later => '後で';

  @override
  String get goToSetting => '設定へ行く';
}
