// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static m0(goalTitle) => "목표를 삭제하고 싶습니까?";

  static m1(currency, number) => "${currency}${number}의 필수 금액보다 적은 값을 입력하십시오.";

  static m2(amount) => "2.99 USD에 대한 무제한 목표를 잠금 해제 한 번 지불하고 영원히 지불하십시오!";

  static m3(month) => "7 월 통계";

  static m4(amount) => "불과 2.99 USD의 일회성 구매에 대한 무제한 목표로 진정한 자아를 잠금 해제하십시오! 😎 참고 : 가격은 다른 통화에 따라 다를 수 있습니다";

  static m5(percent) => "당신은 거기의 ${percent}%입니다!";

  static m6(number) => "버전 ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("에 대한"),
    "add" : MessageLookupByLibrary.simpleMessage("추가하다"),
    "adjustMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("월별 지출 한도를 조정하십시오"),
    "areYouSureDelQ" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("취소"),
    "congratulations" : MessageLookupByLibrary.simpleMessage("목표를 마친 것을 축하합니다! 😆"),
    "create" : MessageLookupByLibrary.simpleMessage("만들다"),
    "currentProgress" : MessageLookupByLibrary.simpleMessage("현재 진행 상황"),
    "dashboard" : MessageLookupByLibrary.simpleMessage("계기반"),
    "days" : MessageLookupByLibrary.simpleMessage("날"),
    "delete" : MessageLookupByLibrary.simpleMessage("삭제"),
    "deleteGoal" : MessageLookupByLibrary.simpleMessage("목표 삭제"),
    "deleteGoalQ" : MessageLookupByLibrary.simpleMessage("목표 삭제?"),
    "device" : MessageLookupByLibrary.simpleMessage("장치"),
    "done" : MessageLookupByLibrary.simpleMessage("완료"),
    "edit" : MessageLookupByLibrary.simpleMessage("편집하다"),
    "editGoal" : MessageLookupByLibrary.simpleMessage("목표 편집"),
    "finish" : MessageLookupByLibrary.simpleMessage("마치다"),
    "hideFrom" : MessageLookupByLibrary.simpleMessage("역사에서 숨기십시오"),
    "hours" : MessageLookupByLibrary.simpleMessage("시간"),
    "howMuchNeededQ" : MessageLookupByLibrary.simpleMessage("얼마나 많은 돈이 필요합니까?"),
    "howMuchSavedQ" : MessageLookupByLibrary.simpleMessage("현재 얼마나 많은 돈이 저축됩니까?"),
    "minutes" : MessageLookupByLibrary.simpleMessage("분"),
    "monthlySavings" : MessageLookupByLibrary.simpleMessage("월별 저축"),
    "months" : MessageLookupByLibrary.simpleMessage("달"),
    "newMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("새로운 월별 지출 한도"),
    "next" : MessageLookupByLibrary.simpleMessage("다음"),
    "noResults" : MessageLookupByLibrary.simpleMessage("결과가 없습니다"),
    "noTransactions" : MessageLookupByLibrary.simpleMessage("아직 거래되지 않았습니다 ... 아직!"),
    "outOfTime" : MessageLookupByLibrary.simpleMessage("시간 중!"),
    "pleaseEnterLess" : m1,
    "pleaseNote" : MessageLookupByLibrary.simpleMessage("주간 지출을 늘리면 목표를 달성하기가 더 어려워지고 낙담합니다."),
    "prefCurr" : MessageLookupByLibrary.simpleMessage("선호하는 통화를 선택하십시오"),
    "pressThePBtn" : MessageLookupByLibrary.simpleMessage("자주색 버튼을 눌러 새 목표를 만들어냅니다!"),
    "privacyPolicy" : MessageLookupByLibrary.simpleMessage("개인 정보 정책"),
    "profile" : MessageLookupByLibrary.simpleMessage("프로필"),
    "purchase" : MessageLookupByLibrary.simpleMessage("구입"),
    "purchasePro" : MessageLookupByLibrary.simpleMessage("Pro purchase를 구매하십시오"),
    "purchaseProText" : m2,
    "remainingBalance" : MessageLookupByLibrary.simpleMessage("남은 균형"),
    "remove" : MessageLookupByLibrary.simpleMessage("제거하다"),
    "save" : MessageLookupByLibrary.simpleMessage("구하다"),
    "savingForQ" : MessageLookupByLibrary.simpleMessage("당신은 무엇을 위해 저축하고 있습니까?"),
    "savingsGoals" : MessageLookupByLibrary.simpleMessage("저축 목표"),
    "search" : MessageLookupByLibrary.simpleMessage("검색"),
    "searchForImage" : MessageLookupByLibrary.simpleMessage("검색 창을 사용하여 Unsplash에서 이미지를 검색하십시오"),
    "seconds" : MessageLookupByLibrary.simpleMessage("초"),
    "seeAll" : MessageLookupByLibrary.simpleMessage("모두보기"),
    "selectImage" : MessageLookupByLibrary.simpleMessage("이미지를 선택하십시오"),
    "settings" : MessageLookupByLibrary.simpleMessage("설정"),
    "skip" : MessageLookupByLibrary.simpleMessage("건너뛰다"),
    "startNewGoal" : MessageLookupByLibrary.simpleMessage("새로운 목표를 시작하십시오"),
    "statistics" : m3,
    "support" : MessageLookupByLibrary.simpleMessage("지원하다"),
    "timeLeft" : MessageLookupByLibrary.simpleMessage("시간이 남았습니다"),
    "totalSaved" : MessageLookupByLibrary.simpleMessage("총 저장"),
    "transaction" : MessageLookupByLibrary.simpleMessage("거래"),
    "transactionHistory" : MessageLookupByLibrary.simpleMessage("거래 내역"),
    "unlimitedGoals" : MessageLookupByLibrary.simpleMessage("무제한 목표"),
    "unlockText" : m4,
    "userPercentProgress" : m5,
    "vacation" : MessageLookupByLibrary.simpleMessage("휴가"),
    "version" : m6,
    "web" : MessageLookupByLibrary.simpleMessage("편물"),
    "whenDeadlineQ" : MessageLookupByLibrary.simpleMessage("마감일은 언제입니까?"),
    "years" : MessageLookupByLibrary.simpleMessage("연령")
  };
}
