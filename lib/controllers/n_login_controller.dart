import 'package:amberflutter/amberflutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/ndk_amber.dart';
import 'package:nip19/nip19.dart';
import 'package:url_launcher/url_launcher.dart';

class NLoginController extends GetxController {
  static NLoginController get to => Get.find();

  Ndk ndk;
  void Function()? onLoggedIn;

  final nip05FieldController = TextEditingController();
  RxBool isFetchingNip05 = false.obs;
  RxInt nip05LoginError = 0.obs;
  RxBool isWaitingForAmber = false.obs;

  NLoginController({required this.ndk, this.onLoggedIn});

  Future<void> loginWithAmber() async {
    isWaitingForAmber.value = true;

    final amber = Amberflutter();

    final isAmberInstalled = await amber.isAppInstalled();

    if (!isAmberInstalled) {
      launchUrl(Uri.parse('https://github.com/greenart7c3/Amber'));
      return;
    }

    final amberFlutterDS = AmberFlutterDS(amber);

    final amberResponse = await amber.getPublicKey();

    final npub = amberResponse['signature'];
    final pubkey = Nip19.npubToHex(npub);

    final amberSigner = AmberEventSigner(
      publicKey: pubkey,
      amberFlutterDS: amberFlutterDS,
    );

    ndk.accounts.loginExternalSigner(signer: amberSigner);

    isWaitingForAmber.value = false;

    loggedIn();
  }

  void loggedIn() {
    if (onLoggedIn != null) onLoggedIn!();
  }
}
