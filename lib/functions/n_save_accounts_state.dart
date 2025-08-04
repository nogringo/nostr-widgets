import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/ndk_amber.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';
import 'package:nostr_widgets/models/accounts.dart';

Future<void> nSaveAccountsState(Ndk ndk) async {
  NostrWidgetsAccounts accounts = NostrWidgetsAccounts(
    pubkeys: [],
    privkeys: [],
  );

  for (var account in ndk.accounts.accounts.values) {
    if (account.signer is Nip07EventSigner) {
      accounts.nip07 = true;
      continue;
    }

    if (account.signer is AmberEventSigner) {
      accounts.amber = true;
      continue;
    }

    if (account.type == AccountType.privateKey) {
      final signer = account.signer as Bip340EventSigner;
      if (signer.privateKey == null) continue;
      accounts.privkeys.add(signer.privateKey!);
      continue;
    }

    if (account.type == AccountType.publicKey) {
      accounts.pubkeys.add(account.signer.getPublicKey());
      continue;
    }
  }

  accounts.loggedAccount = ndk.accounts.getPublicKey();

  final storage = FlutterSecureStorage();
  await storage.write(
    key: "nostr_widgets_accounts",
    value: jsonEncode(accounts),
  );

  print(accounts.toJson());
}
