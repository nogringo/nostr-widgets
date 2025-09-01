import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/data_layer/repositories/signers/nip46_event_signer.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/data_layer/data_sources/amber_flutter.dart';
import 'package:ndk_amber/data_layer/repositories/signers/amber_event_signer.dart';
import 'package:nip01/nip01.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';
import 'package:nostr_widgets/constants/storage_keys.dart';
import 'package:nostr_widgets/models/accounts.dart';

Future<void> nRestoreAccounts(Ndk ndk) async {
  final storage = FlutterSecureStorage();

  final storedAccounts = await storage.read(key: StorageKeys.nostrWidgetsAccounts);

  if (storedAccounts == null) return;

  final accounts = NostrWidgetsAccounts.fromJson(jsonDecode(storedAccounts));

  for (var account in accounts.accounts) {
    if (account.kind == AccountKinds.nip07) {
      ndk.accounts.addAccount(
        pubkey: account.pubkey,
        type: AccountType.externalSigner,
        signer: Nip07EventSigner(),
      );
      continue;
    }

    if (account.kind == AccountKinds.amber) {
      final amber = Amberflutter();
      final amberFlutterDS = AmberFlutterDS(amber);

      ndk.accounts.addAccount(
        pubkey: account.pubkey,
        type: AccountType.externalSigner,
        signer: AmberEventSigner(
          publicKey: account.pubkey,
          amberFlutterDS: amberFlutterDS,
        ),
      );
      continue;
    }

    if (account.kind == AccountKinds.bunker) {
      ndk.accounts.addAccount(
        pubkey: account.pubkey,
        type: AccountType.externalSigner,
        signer: Nip46EventSigner(
          connection: BunkerConnection.fromJson(
            jsonDecode(account.signerSeed!),
          ),
          requests: ndk.requests,
          broadcast: ndk.broadcast,
        ),
      );
      continue;
    }

    if (account.kind == AccountKinds.pubkey) {
      ndk.accounts.addAccount(
        pubkey: account.pubkey,
        type: AccountType.publicKey,
        signer: Bip340EventSigner(privateKey: null, publicKey: account.pubkey),
      );
      continue;
    }

    if (account.kind == AccountKinds.privkey) {
      final keyPair = KeyPair.fromPrivateKey(privateKey: account.signerSeed!);
      ndk.accounts.addAccount(
        pubkey: keyPair.publicKey,
        type: AccountType.privateKey,
        signer: Bip340EventSigner(
          privateKey: keyPair.privateKey,
          publicKey: keyPair.publicKey,
        ),
      );
      continue;
    }
  }

  if (accounts.loggedAccount != null) {
    ndk.accounts.switchAccount(pubkey: accounts.loggedAccount!);
  }

  if (ndk.accounts.getLoggedAccount() == null &&
      ndk.accounts.accounts.isNotEmpty) {
    final pubkey = ndk.accounts.accounts.values.first.pubkey;
    ndk.accounts.switchAccount(pubkey: pubkey);
  }
}
