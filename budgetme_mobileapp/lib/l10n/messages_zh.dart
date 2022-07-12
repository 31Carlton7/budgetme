/*
BudgetMe iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static m0(goalTitle) => "您确定要删除目标吗？";

  static m1(currency, number) => "请输入一个小于您所需{货币} ${number}的数量少的值";

  static m2(amount) => "仅需2.99美元的付费一次，解锁无限目标付费一次，永远付款！";

  static m3(month) => "七月统计";

  static m4(amount) => "用无限的目标释放您的真实自我，仅一次购买2.99美元！ 😎注意：其他货币的价格可能会有所不同";

  static m5(percent) => "您是那里的{％}％！";

  static m6(versionNumber) => "版本1.0.0";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("关于"),
    "add" : MessageLookupByLibrary.simpleMessage("添加"),
    "adjustMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("调整每月支出限额"),
    "areYouSureDelQ" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "congratulations" : MessageLookupByLibrary.simpleMessage("恭喜您完成了您的目标！ 😆"),
    "create" : MessageLookupByLibrary.simpleMessage("创造"),
    "currentProgress" : MessageLookupByLibrary.simpleMessage("现在的进展"),
    "dashboard" : MessageLookupByLibrary.simpleMessage("仪表板"),
    "days" : MessageLookupByLibrary.simpleMessage("天"),
    "delete" : MessageLookupByLibrary.simpleMessage("删除"),
    "deleteGoal" : MessageLookupByLibrary.simpleMessage("删除目标"),
    "deleteGoalQ" : MessageLookupByLibrary.simpleMessage("删除目标？"),
    "device" : MessageLookupByLibrary.simpleMessage("设备"),
    "done" : MessageLookupByLibrary.simpleMessage("完毕"),
    "edit" : MessageLookupByLibrary.simpleMessage("编辑"),
    "editGoal" : MessageLookupByLibrary.simpleMessage("编辑目标"),
    "finish" : MessageLookupByLibrary.simpleMessage("结束"),
    "hideFrom" : MessageLookupByLibrary.simpleMessage("隐藏历史"),
    "hours" : MessageLookupByLibrary.simpleMessage("小时"),
    "howMuchNeededQ" : MessageLookupByLibrary.simpleMessage("需要多少钱？"),
    "howMuchSavedQ" : MessageLookupByLibrary.simpleMessage("目前节省了多少钱？"),
    "minutes" : MessageLookupByLibrary.simpleMessage("分钟"),
    "monthlySavings" : MessageLookupByLibrary.simpleMessage("每月储蓄"),
    "months" : MessageLookupByLibrary.simpleMessage("月份"),
    "newMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("新的每月支出限额"),
    "next" : MessageLookupByLibrary.simpleMessage("下一个"),
    "noResults" : MessageLookupByLibrary.simpleMessage("没有结果"),
    "noTransactions" : MessageLookupByLibrary.simpleMessage("尚未进行交易...现在！"),
    "pleaseEnterLess" : m1,
    "pleaseNote" : MessageLookupByLibrary.simpleMessage("请注意，增加您的每周支出将使实现目标变得更加困难，并且会灰心。"),
    "prefCurr" : MessageLookupByLibrary.simpleMessage("选择您的首选货币"),
    "pressThePBtn" : MessageLookupByLibrary.simpleMessage("按下紫色按钮创建一个新目标！"),
    "privacyPolicy" : MessageLookupByLibrary.simpleMessage("隐私政策"),
    "profile" : MessageLookupByLibrary.simpleMessage("轮廓"),
    "purchase" : MessageLookupByLibrary.simpleMessage("购买"),
    "purchasePro" : MessageLookupByLibrary.simpleMessage("购买pro😎"),
    "purchaseProText" : m2,
    "remainingBalance" : MessageLookupByLibrary.simpleMessage("保持平衡"),
    "remove" : MessageLookupByLibrary.simpleMessage("消除"),
    "save" : MessageLookupByLibrary.simpleMessage("节省"),
    "savingForQ" : MessageLookupByLibrary.simpleMessage("您要保存什么？"),
    "savingsGoals" : MessageLookupByLibrary.simpleMessage("储蓄目标"),
    "search" : MessageLookupByLibrary.simpleMessage("搜索"),
    "searchForImage" : MessageLookupByLibrary.simpleMessage("使用搜索栏在Unsplash上​​搜索图像"),
    "seconds" : MessageLookupByLibrary.simpleMessage("秒"),
    "seeAll" : MessageLookupByLibrary.simpleMessage("看到所有"),
    "selectImage" : MessageLookupByLibrary.simpleMessage("选择图像"),
    "settings" : MessageLookupByLibrary.simpleMessage("设置"),
    "skip" : MessageLookupByLibrary.simpleMessage("跳过"),
    "startNewGoal" : MessageLookupByLibrary.simpleMessage("开始新目标"),
    "statistics" : m3,
    "support" : MessageLookupByLibrary.simpleMessage("支持"),
    "timeLeft" : MessageLookupByLibrary.simpleMessage("剩下的时间"),
    "totalSaved" : MessageLookupByLibrary.simpleMessage("总保存"),
    "transaction" : MessageLookupByLibrary.simpleMessage("交易"),
    "transactionHistory" : MessageLookupByLibrary.simpleMessage("交易历史记录"),
    "unlimitedGoals" : MessageLookupByLibrary.simpleMessage("无限目标"),
    "unlockText" : m4,
    "userPercentProgress" : m5,
    "vacation" : MessageLookupByLibrary.simpleMessage("假期"),
    "version" : m6,
    "web" : MessageLookupByLibrary.simpleMessage("网络"),
    "whenDeadlineQ" : MessageLookupByLibrary.simpleMessage("什么时候截止日期？"),
    "years" : MessageLookupByLibrary.simpleMessage("年")
  };
}
