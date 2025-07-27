import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ndk/ndk.dart';

Future<void> nLogout(Ndk ndk) async {
  final storage = FlutterSecureStorage();

  await Future.wait([
    storage.delete(key: "ndk_ui_privkey"),
    storage.delete(key: "ndk_ui_pubkey"),
    storage.delete(key: "ndk_ui_login_with"),
  ]);

  ndk.accounts.logout();
}
