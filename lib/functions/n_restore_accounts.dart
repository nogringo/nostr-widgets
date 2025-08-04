import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/data_layer/data_sources/amber_flutter.dart';
import 'package:ndk_amber/data_layer/repositories/signers/amber_event_signer.dart';
import 'package:nip01/nip01.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';
import 'package:nip19/nip19.dart';
import 'package:nostr_widgets/models/accounts.dart';

Future<void> nRestoreAccounts(Ndk ndk) async {
  final storage = FlutterSecureStorage();

  final storedAccounts = await storage.read(key: "nostr_widgets_accounts");
  print(storedAccounts);

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
    final amber = Amberflutter();
    final amberFlutterDS = AmberFlutterDS(amber);

    final amberResponse = await amber.getPublicKey();

    final npub = amberResponse['signature'];
    final pubkey = Nip19.npubToHex(npub);

    final signer = AmberEventSigner(
      publicKey: pubkey,
      amberFlutterDS: amberFlutterDS,
    );
    ndk.accounts.addAccount(
      pubkey: pubkey,
      type: AccountType.externalSigner,
      signer: signer,
    );
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
