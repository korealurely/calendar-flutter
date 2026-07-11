// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myPageTitle => 'Me';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get currentVersion => 'Version';

  @override
  String get homePage => 'Home';

  @override
  String get shift => 'Shift';

  @override
  String get statistic => 'Statistics';

  @override
  String get my => 'Me';

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
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get detail => 'Details';

  @override
  String get noShift => 'No shift scheduled';

  @override
  String get noShiftHint => 'No shift scheduled for today. Enjoy a good sleep~';

  @override
  String get startShift => 'Start of shift';

  @override
  String get endWork => 'End of shift';

  @override
  String get editShift => 'Edit Shift';

  @override
  String get selectShiftType => 'Select Shift Type';

  @override
  String get clearShift => 'Clear/Rest';

  @override
  String get confirm => 'Confirm';

  @override
  String get loadErr => 'Failed to load configuration:';

  @override
  String get weight => 'Weight';

  @override
  String get noData => 'No data available';

  @override
  String get noWeightHint =>
      'You haven\'t weighed yourself today. Click to record it~';

  @override
  String get shiftManagement => 'Shift Management';

  @override
  String get pattern => 'Pattern';

  @override
  String get addShift => 'Add Shift';

  @override
  String get shiftNameHint => 'Shift Name (e.g.: Morning Shift)';

  @override
  String get shiftLabelHint => 'Calendar cell label (e.g.: Morn)';

  @override
  String get to => 'to';

  @override
  String get customColor => 'Custom Color';

  @override
  String get setColor => 'Click to set color';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get shiftErrMsg => 'Please complete the shift name and label!';

  @override
  String get setShiftColor => 'Select Shift Color';

  @override
  String get patternManagement => 'Cycle Pattern Management';

  @override
  String get noPatternHint =>
      'No pattern configured yet. Click the button below to add one.';

  @override
  String get addPattern => 'Add Cycle Pattern';

  @override
  String get weekPattern => 'Week';

  @override
  String get custom => 'Custom';

  @override
  String get confirmDel => 'Confirm deletion';

  @override
  String get confirmDelHint => 'Are you sure you want to delete?';

  @override
  String get generateShifts => 'Generate Shifts';

  @override
  String get generatePattern => 'Generate Pattern';

  @override
  String get weekSetLabel => 'Configure a 7-day rotating shift';

  @override
  String get mon1 => 'Mon';

  @override
  String get tue1 => 'Tue';

  @override
  String get wed1 => 'Wed';

  @override
  String get thu1 => 'Thu';

  @override
  String get fri1 => 'Fri';

  @override
  String get sat1 => 'Sat';

  @override
  String get sun1 => 'Sun';

  @override
  String get customShiftLabel =>
      'Customize shift order (cycle from left to right in sequence)';

  @override
  String get unknownShift => 'Unknown';

  @override
  String get add => 'Append';

  @override
  String get dateRange => 'Effective Date Range';

  @override
  String get dataStatistic => 'Data Statistics';

  @override
  String get shiftStatistic => 'Shift';

  @override
  String get staticErrorHint =>
      'Some minor failures occurred during data reconciliation';

  @override
  String get reload => 'Reload';

  @override
  String get noShiftStatHint => 'No shift statistics available for this month~';

  @override
  String get totalDays => 'Total Days';

  @override
  String get day => 'D';

  @override
  String get weightStat => 'Weight';

  @override
  String get day1 => 'D';

  @override
  String get weightStatError => 'Failed to plot weight curve';

  @override
  String get weightStatHint => 'No weight data recorded for this month';

  @override
  String get workTimeStat => 'Hours';

  @override
  String get hour => 'Hour';

  @override
  String get workStatError => 'Failed to load hours statistics';

  @override
  String get workStatHint => 'No work hours data recorded for this month~';

  @override
  String get language => 'Language';

  @override
  String get noShiftConfigHint =>
      'No shift configuration yet. Click the + in the bottom right to add.';

  @override
  String deleteConfigConfirmContent(String configName) {
    return 'Are you sure you want to delete [$configName]?';
  }

  @override
  String get clearHint => 'Are you sure you want to clear all data?';

  @override
  String get sync => 'Sync';

  @override
  String get syncHint =>
      'Are you sure you want to sync to the system calendar?';

  @override
  String get syncData => 'Sync Data';

  @override
  String get syncSuccess => 'Data synced successfully!';

  @override
  String get syncFailCheck =>
      'Failed to sync data. Please check if the data is complete or if the app has permission to access the system calendar.';
}
