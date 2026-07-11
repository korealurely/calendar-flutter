import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @myPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get myPageTitle;

  /// No description provided for @clearCache.
  ///
  /// In zh, this message translates to:
  /// **'清除缓存'**
  String get clearCache;

  /// No description provided for @darkMode.
  ///
  /// In zh, this message translates to:
  /// **'黑夜模式'**
  String get darkMode;

  /// No description provided for @currentVersion.
  ///
  /// In zh, this message translates to:
  /// **'当前版本'**
  String get currentVersion;

  /// No description provided for @homePage.
  ///
  /// In zh, this message translates to:
  /// **'主页'**
  String get homePage;

  /// No description provided for @shift.
  ///
  /// In zh, this message translates to:
  /// **'排班'**
  String get shift;

  /// No description provided for @statistic.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get statistic;

  /// No description provided for @my.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get my;

  /// No description provided for @yearMonthDate.
  ///
  /// In zh, this message translates to:
  /// **'{date}'**
  String yearMonthDate(DateTime date);

  /// No description provided for @monthDayDate.
  ///
  /// In zh, this message translates to:
  /// **'{date}'**
  String monthDayDate(DateTime date);

  /// No description provided for @mon.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get sun;

  /// No description provided for @detail.
  ///
  /// In zh, this message translates to:
  /// **'详情'**
  String get detail;

  /// No description provided for @noShift.
  ///
  /// In zh, this message translates to:
  /// **'暂无排班'**
  String get noShift;

  /// No description provided for @noShiftHint.
  ///
  /// In zh, this message translates to:
  /// **'今天没有排班计划，睡个大懒觉吧~'**
  String get noShiftHint;

  /// No description provided for @startShift.
  ///
  /// In zh, this message translates to:
  /// **'上班时间'**
  String get startShift;

  /// No description provided for @endWork.
  ///
  /// In zh, this message translates to:
  /// **'下班时间'**
  String get endWork;

  /// No description provided for @editShift.
  ///
  /// In zh, this message translates to:
  /// **'修改班次'**
  String get editShift;

  /// No description provided for @selectShiftType.
  ///
  /// In zh, this message translates to:
  /// **'选择班次类型'**
  String get selectShiftType;

  /// No description provided for @clearShift.
  ///
  /// In zh, this message translates to:
  /// **'清除/休息'**
  String get clearShift;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @loadErr.
  ///
  /// In zh, this message translates to:
  /// **'加载失败:'**
  String get loadErr;

  /// No description provided for @weight.
  ///
  /// In zh, this message translates to:
  /// **'体重'**
  String get weight;

  /// No description provided for @noData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// No description provided for @noWeightHint.
  ///
  /// In zh, this message translates to:
  /// **'今天还没称体重呢，点击记录一下吧~'**
  String get noWeightHint;

  /// No description provided for @shiftManagement.
  ///
  /// In zh, this message translates to:
  /// **'班次管理'**
  String get shiftManagement;

  /// No description provided for @pattern.
  ///
  /// In zh, this message translates to:
  /// **'模式'**
  String get pattern;

  /// No description provided for @addShift.
  ///
  /// In zh, this message translates to:
  /// **'添加班次'**
  String get addShift;

  /// No description provided for @shiftNameHint.
  ///
  /// In zh, this message translates to:
  /// **'班次名称（如: 早班）'**
  String get shiftNameHint;

  /// No description provided for @shiftLabelHint.
  ///
  /// In zh, this message translates to:
  /// **'日历格子标签（如: 早）'**
  String get shiftLabelHint;

  /// No description provided for @to.
  ///
  /// In zh, this message translates to:
  /// **'至'**
  String get to;

  /// No description provided for @customColor.
  ///
  /// In zh, this message translates to:
  /// **'专属颜色'**
  String get customColor;

  /// No description provided for @setColor.
  ///
  /// In zh, this message translates to:
  /// **'点击设定颜色'**
  String get setColor;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @shiftErrMsg.
  ///
  /// In zh, this message translates to:
  /// **'请完整填写班次名称和标签！'**
  String get shiftErrMsg;

  /// No description provided for @setShiftColor.
  ///
  /// In zh, this message translates to:
  /// **'选择班次颜色'**
  String get setShiftColor;

  /// No description provided for @patternManagement.
  ///
  /// In zh, this message translates to:
  /// **'周期模式管理'**
  String get patternManagement;

  /// No description provided for @noPatternHint.
  ///
  /// In zh, this message translates to:
  /// **'暂无模式配置，点击下方按钮添加'**
  String get noPatternHint;

  /// No description provided for @addPattern.
  ///
  /// In zh, this message translates to:
  /// **'添加周期模式'**
  String get addPattern;

  /// No description provided for @weekPattern.
  ///
  /// In zh, this message translates to:
  /// **'固定周'**
  String get weekPattern;

  /// No description provided for @custom.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get custom;

  /// No description provided for @confirmDel.
  ///
  /// In zh, this message translates to:
  /// **'确定删除'**
  String get confirmDel;

  /// No description provided for @confirmDelHint.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除吗？'**
  String get confirmDelHint;

  /// No description provided for @generateShifts.
  ///
  /// In zh, this message translates to:
  /// **'排班生成'**
  String get generateShifts;

  /// No description provided for @generatePattern.
  ///
  /// In zh, this message translates to:
  /// **'模式生成'**
  String get generatePattern;

  /// No description provided for @weekSetLabel.
  ///
  /// In zh, this message translates to:
  /// **'配置一周七天循环班次'**
  String get weekSetLabel;

  /// No description provided for @mon1.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get mon1;

  /// No description provided for @tue1.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get tue1;

  /// No description provided for @wed1.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get wed1;

  /// No description provided for @thu1.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get thu1;

  /// No description provided for @fri1.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get fri1;

  /// No description provided for @sat1.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get sat1;

  /// No description provided for @sun1.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get sun1;

  /// No description provided for @customShiftLabel.
  ///
  /// In zh, this message translates to:
  /// **'自由定义排班顺序（从左往右按顺序循环）'**
  String get customShiftLabel;

  /// No description provided for @unknownShift.
  ///
  /// In zh, this message translates to:
  /// **'未知班次'**
  String get unknownShift;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'追加'**
  String get add;

  /// No description provided for @dateRange.
  ///
  /// In zh, this message translates to:
  /// **'生效日期范围'**
  String get dateRange;

  /// No description provided for @dataStatistic.
  ///
  /// In zh, this message translates to:
  /// **'数据统计'**
  String get dataStatistic;

  /// No description provided for @shiftStatistic.
  ///
  /// In zh, this message translates to:
  /// **'班次统计'**
  String get shiftStatistic;

  /// No description provided for @staticErrorHint.
  ///
  /// In zh, this message translates to:
  /// **'数据对账有些小失败'**
  String get staticErrorHint;

  /// No description provided for @reload.
  ///
  /// In zh, this message translates to:
  /// **'重新加载'**
  String get reload;

  /// No description provided for @noShiftStatHint.
  ///
  /// In zh, this message translates to:
  /// **'本月暂无排班统计数据哦~'**
  String get noShiftStatHint;

  /// No description provided for @totalDays.
  ///
  /// In zh, this message translates to:
  /// **'总天数'**
  String get totalDays;

  /// No description provided for @day.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get day;

  /// No description provided for @weightStat.
  ///
  /// In zh, this message translates to:
  /// **'体重趋势'**
  String get weightStat;

  /// No description provided for @day1.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get day1;

  /// No description provided for @weightStatError.
  ///
  /// In zh, this message translates to:
  /// **'体重曲线绘制失败'**
  String get weightStatError;

  /// No description provided for @weightStatHint.
  ///
  /// In zh, this message translates to:
  /// **'本月还没有记录体重数据'**
  String get weightStatHint;

  /// No description provided for @workTimeStat.
  ///
  /// In zh, this message translates to:
  /// **'工时统计'**
  String get workTimeStat;

  /// No description provided for @hour.
  ///
  /// In zh, this message translates to:
  /// **'小时'**
  String get hour;

  /// No description provided for @workStatError.
  ///
  /// In zh, this message translates to:
  /// **'工时统计加载失败'**
  String get workStatError;

  /// No description provided for @workStatHint.
  ///
  /// In zh, this message translates to:
  /// **'本月还没有登记工时数据哦~'**
  String get workStatHint;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @noShiftConfigHint.
  ///
  /// In zh, this message translates to:
  /// **'暂无班次配置，点击右下角+添加'**
  String get noShiftConfigHint;

  /// No description provided for @deleteConfigConfirmContent.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除【{configName}】吗？'**
  String deleteConfigConfirmContent(String configName);

  /// No description provided for @clearHint.
  ///
  /// In zh, this message translates to:
  /// **'确定清空所有数据吗？'**
  String get clearHint;

  /// No description provided for @sync.
  ///
  /// In zh, this message translates to:
  /// **'同步'**
  String get sync;

  /// No description provided for @syncHint.
  ///
  /// In zh, this message translates to:
  /// **'确定同步到系统日历吗?'**
  String get syncHint;

  /// No description provided for @syncData.
  ///
  /// In zh, this message translates to:
  /// **'同步数据'**
  String get syncData;

  /// No description provided for @syncSuccess.
  ///
  /// In zh, this message translates to:
  /// **'同步数据成功!'**
  String get syncSuccess;

  /// No description provided for @syncFailCheck.
  ///
  /// In zh, this message translates to:
  /// **'同步数据失败，请检查数据是否完整或APP是否具有系统日历读取权限'**
  String get syncFailCheck;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
