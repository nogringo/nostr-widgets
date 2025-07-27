import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:nip01/nip01.dart';
import 'package:nip07_event_signer/nip07_event_signer.dart';

Future<bool> nRestoreLastSession(Ndk ndk) async {
  final storage = FlutterSecureStorage();

  final loginWith = await storage.read(key: "ndk_ui_login_with");

  if (loginWith == null) return false;

  if (loginWith == "npub") {
    final pubkey = await storage.read(key: "ndk_ui_pubkey");
    ndk.accounts.loginPublicKey(pubkey: pubkey!);
    return true;
  }

  if (loginWith == "nsec") {
    final privkey = await storage.read(key: "ndk_ui_privkey");
    final keyPair = KeyPair.fromPrivateKey(privateKey: privkey!);
    ndk.accounts.loginPrivateKey(pubkey: keyPair.publicKey, privkey: privkey);
    return true;
  }

  if (loginWith == "nip07") {
    final signer = Nip07EventSigner();
    await signer.getPublicKeyAsync();
    ndk.accounts.loginExternalSigner(signer: signer);
    return true;
  }

  return false;
}
