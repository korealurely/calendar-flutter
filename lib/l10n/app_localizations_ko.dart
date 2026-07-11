// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get myPageTitle => '내 정보';

  @override
  String get clearCache => '캐시 삭제';

  @override
  String get darkMode => '다크 모드';

  @override
  String get currentVersion => '현재 버전';

  @override
  String get homePage => '홈';

  @override
  String get shift => '근무표';

  @override
  String get statistic => '통계';

  @override
  String get my => '내 정보';

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
  String get mon => '월';

  @override
  String get tue => '화';

  @override
  String get wed => '수';

  @override
  String get thu => '목';

  @override
  String get fri => '금';

  @override
  String get sat => '토';

  @override
  String get sun => '일';

  @override
  String get detail => '상세';

  @override
  String get noShift => '근무표 없음';

  @override
  String get noShiftHint => '오늘은 근무 일정이 없습니다. 푹 쉬세요~';

  @override
  String get startShift => '출근 시간';

  @override
  String get endWork => '퇴근 시간';

  @override
  String get editShift => '근무표 수정';

  @override
  String get selectShiftType => '근무 유형 선택';

  @override
  String get clearShift => '비움/휴식';

  @override
  String get confirm => '확인';

  @override
  String get loadErr => '불러오기 실패:';

  @override
  String get weight => '체중';

  @override
  String get noData => '데이터 없음';

  @override
  String get noWeightHint => '오늘은 아직 체중을 기록하지 않았어요. 클릭해서 기록해보세요~';

  @override
  String get shiftManagement => '근무표 관리';

  @override
  String get pattern => '패턴';

  @override
  String get addShift => '근무표 추가';

  @override
  String get shiftNameHint => '근무표 이름 (예: 오전근무)';

  @override
  String get shiftLabelHint => '달력 칸 라벨 (예: 오)';

  @override
  String get to => '~';

  @override
  String get customColor => '전용 색상';

  @override
  String get setColor => '클릭하여 색상 설정';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String get shiftErrMsg => '근무표 이름과 라벨을 모두 입력해주세요!';

  @override
  String get setShiftColor => '근무표 색상 선택';

  @override
  String get patternManagement => '주기 패턴 관리';

  @override
  String get noPatternHint => '패턴 설정이 없습니다. 아래 버튼을 클릭하여 추가하세요.';

  @override
  String get addPattern => '주기 패턴 추가';

  @override
  String get weekPattern => '고정 주';

  @override
  String get custom => '사용자 정의';

  @override
  String get confirmDel => '삭제 확인';

  @override
  String get confirmDelHint => '정말 삭제하시겠습니까?';

  @override
  String get generateShifts => '근무표 생성';

  @override
  String get generatePattern => '패턴 생성';

  @override
  String get weekSetLabel => '일주일 7일 순환 근무표 설정';

  @override
  String get mon1 => '월요일';

  @override
  String get tue1 => '화요일';

  @override
  String get wed1 => '수요일';

  @override
  String get thu1 => '목요일';

  @override
  String get fri1 => '금요일';

  @override
  String get sat1 => '토요일';

  @override
  String get sun1 => '일요일';

  @override
  String get customShiftLabel => '근무 순서 자유 정의 (왼쪽에서 오른쪽 순서대로 순환)';

  @override
  String get unknownShift => '알 수 없는 근무표';

  @override
  String get add => '추가';

  @override
  String get dateRange => '적용 기간';

  @override
  String get dataStatistic => '데이터 통계';

  @override
  String get shiftStatistic => '근무표 통계';

  @override
  String get staticErrorHint => '데이터 정산에 약간의 오류가 있습니다.';

  @override
  String get reload => '다시 불러오기';

  @override
  String get noShiftStatHint => '이번 달에는 근무표 통계 데이터가 없습니다~';

  @override
  String get totalDays => '총 일수';

  @override
  String get day => '일';

  @override
  String get weightStat => '체중 추세';

  @override
  String get day1 => '일';

  @override
  String get weightStatError => '체중 그래프 그리기 실패';

  @override
  String get weightStatHint => '이번 달에는 아직 체중 데이터가 없습니다.';

  @override
  String get workTimeStat => '근무 시간 통계';

  @override
  String get hour => '시간';

  @override
  String get workStatError => '근무 시간 통계 불러오기 실패';

  @override
  String get workStatHint => '이번 달에는 아직 근무 시간 데이터가 없습니다~';

  @override
  String get language => '언어';

  @override
  String get noShiftConfigHint => '근무표 설정이 없습니다. 오른쪽 아래 +를 클릭하여 추가하세요.';

  @override
  String deleteConfigConfirmContent(String configName) {
    return '정말로 【$configName】을(를) 삭제하시겠습니까?';
  }

  @override
  String get clearHint => '정말 모든 데이터를 삭제하시겠습니까?';

  @override
  String get sync => '동기화';

  @override
  String get syncHint => '시스템 캘린더에 동기화하시겠습니까?';

  @override
  String get syncData => '데이터 동기화';

  @override
  String get syncSuccess => '데이터 동기화 성공!';

  @override
  String get syncFailCheck =>
      '데이터 동기화에 실패했습니다. 데이터가 완전한지 또는 앱에 시스템 캘린더 읽기 권한이 있는지 확인해 주세요.';
}
