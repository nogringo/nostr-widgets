import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:nip01/nip01.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';
import 'package:nostr_widgets/models/accounts.dart';

Future<void> nRestoreAccounts(Ndk ndk) async {
  final storage = FlutterSecureStorage();

  final storedAccounts = await storage.read(key: "nostr_widgets_accounts");

  if (storedAccounts == null) return;

  final accounts = NostrWidgetsAccounts.fromJson(jsonDecode(storedAccounts));

  if (accounts.nip07) {
    final signer = Nip07EventSigner();
    await signer.getPublicKeyAsync();
    ndk.accounts.addAccount(
      pubkey: signer.getPublicKey(),
      type: AccountType.externalSigner,
      signer: signer,
    );
  }

  if (accounts.amber) {
    // TODO
  }

  for (var pubkey in accounts.pubkeys) {
    ndk.accounts.addAccount(
      pubkey: pubkey,
      type: AccountType.publicKey,
      signer: Bip340EventSigner(privateKey: null, publicKey: pubkey),
    );
  }

  for (var privkey in accounts.privkeys) {
    final keyPair = KeyPair.fromPrivateKey(privateKey: privkey);
    ndk.accounts.addAccount(
      pubkey: keyPair.publicKey,
      type: AccountType.privateKey,
      signer: Bip340EventSigner(
        privateKey: privkey,
        publicKey: keyPair.publicKey,
      ),
    );
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
