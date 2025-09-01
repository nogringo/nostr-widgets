import 'package:flutter/foundation.dart';

class StorageKeys {
  static String get nostrWidgetsAccounts =>
      kDebugMode ? 'dev_nostr_widgets_accounts' : 'nostr_widgets_accounts';
}
