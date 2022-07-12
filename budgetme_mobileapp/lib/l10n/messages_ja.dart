// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

// Package imports:
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static m0(goalTitle) => "あなたはあなたの目標を削除したいですか？";

  static m1(currency, number) => "必要な量の${currency}${number}よりも小さい値を入力してください";

  static m2(amount) => "わずか2.99米ドルの無制限の目標のロックを解除する😆一度支払う、永遠に支払う！";

  static m3(month) => "7月の統計";

  static m4(amount) => "わずか2.99米ドルの1回限りの購入のための無制限の目標であなたの本当の自己のロックを解除してください！ 😎注：価格は他の通貨で異なる場合があります";

  static m5(percent) => "あなたはそこの道の${percent}％です！";

  static m6(versionNumber) => "バージョン1.0.0";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("約"),
    "add" : MessageLookupByLibrary.simpleMessage("追加"),
    "adjustMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("毎月の支出制限を調整します"),
    "areYouSureDelQ" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "congratulations" : MessageLookupByLibrary.simpleMessage("あなたの目標を達成しておめでとうございます！ 😆"),
    "create" : MessageLookupByLibrary.simpleMessage("作成"),
    "currentProgress" : MessageLookupByLibrary.simpleMessage("現在の進行"),
    "dashboard" : MessageLookupByLibrary.simpleMessage("ダッシュボード"),
    "days" : MessageLookupByLibrary.simpleMessage("日々"),
    "delete" : MessageLookupByLibrary.simpleMessage("消去"),
    "deleteGoal" : MessageLookupByLibrary.simpleMessage("目標を削除します"),
    "deleteGoalQ" : MessageLookupByLibrary.simpleMessage("目標を削除しますか？"),
    "device" : MessageLookupByLibrary.simpleMessage("デバイス"),
    "done" : MessageLookupByLibrary.simpleMessage("終わり"),
    "edit" : MessageLookupByLibrary.simpleMessage("編集"),
    "editGoal" : MessageLookupByLibrary.simpleMessage("目標を編集します"),
    "finish" : MessageLookupByLibrary.simpleMessage("終了"),
    "hideFrom" : MessageLookupByLibrary.simpleMessage("歴史から隠れます"),
    "hours" : MessageLookupByLibrary.simpleMessage("時間"),
    "howMuchNeededQ" : MessageLookupByLibrary.simpleMessage("どれくらいのお金が必要ですか？"),
    "howMuchSavedQ" : MessageLookupByLibrary.simpleMessage("現在どのくらいのお金が節約されていますか？"),
    "minutes" : MessageLookupByLibrary.simpleMessage("分"),
    "monthlySavings" : MessageLookupByLibrary.simpleMessage("毎月の節約"),
    "months" : MessageLookupByLibrary.simpleMessage("数ヶ月"),
    "newMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("新しい毎月の支出制限"),
    "next" : MessageLookupByLibrary.simpleMessage("次"),
    "noResults" : MessageLookupByLibrary.simpleMessage("結果がありません"),
    "noTransactions" : MessageLookupByLibrary.simpleMessage("取引は行われていません...まだ！"),
    "pleaseEnterLess" : m1,
    "pleaseNote" : MessageLookupByLibrary.simpleMessage("毎週の支出を増やすと、目標を達成するのが難しくなり、落胆していることに注意してください。"),
    "prefCurr" : MessageLookupByLibrary.simpleMessage("優先通貨を選択します"),
    "pressThePBtn" : MessageLookupByLibrary.simpleMessage("パープルボタンを押して、新しい目標を作成します！"),
    "privacyPolicy" : MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "profile" : MessageLookupByLibrary.simpleMessage("プロフィール"),
    "purchase" : MessageLookupByLibrary.simpleMessage("購入"),
    "purchasePro" : MessageLookupByLibrary.simpleMessage("Pro😎を購入します"),
    "purchaseProText" : m2,
    "remainingBalance" : MessageLookupByLibrary.simpleMessage("保たれているバランス"),
    "remove" : MessageLookupByLibrary.simpleMessage("削除する"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "savingForQ" : MessageLookupByLibrary.simpleMessage("何のために節約していますか？"),
    "savingsGoals" : MessageLookupByLibrary.simpleMessage("節約目標"),
    "search" : MessageLookupByLibrary.simpleMessage("探す"),
    "searchForImage" : MessageLookupByLibrary.simpleMessage("検索バーを使用して、Unsplashで画像を検索します"),
    "seconds" : MessageLookupByLibrary.simpleMessage("秒"),
    "seeAll" : MessageLookupByLibrary.simpleMessage("すべてを見る"),
    "selectImage" : MessageLookupByLibrary.simpleMessage("画像を選択します"),
    "settings" : MessageLookupByLibrary.simpleMessage("設定"),
    "skip" : MessageLookupByLibrary.simpleMessage("スキップ"),
    "startNewGoal" : MessageLookupByLibrary.simpleMessage("新しい目標を開始します"),
    "statistics" : m3,
    "support" : MessageLookupByLibrary.simpleMessage("サポート"),
    "timeLeft" : MessageLookupByLibrary.simpleMessage("残り時間"),
    "totalSaved" : MessageLookupByLibrary.simpleMessage("総節約"),
    "transaction" : MessageLookupByLibrary.simpleMessage("取引"),
    "transactionHistory" : MessageLookupByLibrary.simpleMessage("取引履歴"),
    "unlimitedGoals" : MessageLookupByLibrary.simpleMessage("無制限の目標"),
    "unlockText" : m4,
    "userPercentProgress" : m5,
    "vacation" : MessageLookupByLibrary.simpleMessage("休暇"),
    "version" : m6,
    "web" : MessageLookupByLibrary.simpleMessage("ウェブ"),
    "whenDeadlineQ" : MessageLookupByLibrary.simpleMessage("締め切りはいつですか？"),
    "years" : MessageLookupByLibrary.simpleMessage("年")
  };
}
