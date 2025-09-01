import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/data_layer/repositories/signers/nip46_event_signer.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/ndk_amber.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';
import 'package:nostr_widgets/constants/storage_keys.dart';
import 'package:nostr_widgets/models/accounts.dart';

Future<void> nSaveAccountsState(Ndk ndk) async {
  NostrWidgetsAccounts accounts = NostrWidgetsAccounts(accounts: []);

  for (var account in ndk.accounts.accounts.values) {
    if (account.signer is Nip07EventSigner) {
      accounts.accounts.add(
        NostrAccount(kind: AccountKinds.nip07, pubkey: account.pubkey),
      );
      continue;
    }

    if (account.signer is AmberEventSigner) {
      accounts.accounts.add(
        NostrAccount(kind: AccountKinds.amber, pubkey: account.pubkey),
      );
      continue;
    }

    if (account.signer is Nip46EventSigner) {
      final signer = account.signer as Nip46EventSigner;
      accounts.accounts.add(
        NostrAccount(
          kind: AccountKinds.bunker,
          pubkey: account.pubkey,
          signerSeed: jsonEncode(signer.connection),
        ),
      );
      continue;
    }

    if (account.type == AccountType.privateKey) {
      final signer = account.signer as Bip340EventSigner;
      if (signer.privateKey == null) continue;
      accounts.accounts.add(
        NostrAccount(
          kind: AccountKinds.privkey,
          pubkey: account.pubkey,
          signerSeed: jsonEncode(signer.privateKey!),
        ),
      );
      continue;
    }

    if (account.type == AccountType.publicKey) {
      accounts.accounts.add(
        NostrAccount(kind: AccountKinds.pubkey, pubkey: account.pubkey),
      );
      continue;
    }
  }

  accounts.loggedAccount = ndk.accounts.getPublicKey();

  final storage = FlutterSecureStorage();
  await storage.write(
    key: StorageKeys.nostrWidgetsAccounts,
    value: jsonEncode(accounts),
  );
}
