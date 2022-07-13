// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  @override
  String? lookupMessage(
      String? messageText, 
      String? locale, 
      String? name,
      List<Object>? args, 
      String? meaning,
      {MessageIfAbsent? ifAbsent}) {
    MessageIfAbsent failedLookup = (String? message_str, List<Object>? args) {
      // If there's no message_str, then we are an internal lookup, e.g. an
      // embedded plural, and shouldn't fail.
      if (message_str == null) return '';
      throw UnsupportedError(
          "No translation found for message '$name',\n"
              "  original text '$message_str'");
    };
    return super.lookupMessage(messageText, locale, name, args, meaning,
        ifAbsent: ifAbsent ?? failedLookup);
  }

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {

  };
}
