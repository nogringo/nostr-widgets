import 'package:amberflutter/amberflutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_amber/ndk_amber.dart';
import 'package:nip19/nip19.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart';
import 'package:nostr_widgets/widgets/nostr_connect_dialog_view.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class NLoginController extends GetxController {
  static NLoginController get to => Get.find();

  Ndk ndk;
  void Function()? onLoggedIn;

  final nip05FieldController = TextEditingController();
  RxBool isFetchingNip05 = false.obs;
  RxInt nip05LoginError = 0.obs;

  final bunkerFieldController = TextEditingController();
  RxBool isBunkerLoading = false.obs;
  NostrConnect? nostrConnect;
  bool isNostrConnectDialogOpen = false;
  List<ToastificationItem> challengeToasts = [];

  RxBool isWaitingForAmber = false.obs;

  bool get isValidBunkerUrl {
    final bunkerText = bunkerFieldController.text.trim();

    try {
      final uri = Uri.parse(bunkerText);

      // Check if scheme is bunker
      if (uri.scheme != 'bunker') return false;

      // Check if host (pubkey) is valid hex (64 characters)
      if (uri.host.length != 64) return false;
      if (!RegExp(r'^[a-fA-F0-9]+$').hasMatch(uri.host)) return false;

      // Check if at least one relay parameter exists
      if (!uri.queryParameters.containsKey('relay')) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  NLoginController({required this.ndk, this.onLoggedIn, this.nostrConnect});

  Future<void> loginWithBunkerUrl() async {
    isBunkerLoading.value = true;

    try {
      final bunkerConnection = await ndk.accounts.loginWithBunkerUrl(
        bunkerUrl: bunkerFieldController.text.trim(),
        bunkers: ndk.bunkers,
        authCallback: (challenge) => showBunkerAuthToast(challenge),
      );

      isBunkerLoading.value = false;

      if (bunkerConnection == null) return;

      loggedIn();
    } catch (e) {
      // 
    }
  }

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
    for (var toast in challengeToasts) {
      toastification.dismiss(toast);
    }
    challengeToasts.clear();

    if (onLoggedIn != null) onLoggedIn!();
  }

  void showNostrConnectQrcode() async {
    if (nostrConnect == null) return;

    openNostrConnectDialog();

    try {
      final bunkerSettings = await ndk.accounts.loginWithNostrConnect(
        nostrConnect: nostrConnect!,
        bunkers: ndk.bunkers,
        // authCallback: (challenge) => showBunkerAuthToast(challenge),
      );

      if (isNostrConnectDialogOpen) {
        Get.back();
        isNostrConnectDialogOpen = false;
      }

      if (bunkerSettings == null) return;

      loggedIn();
    } catch (e) {
      if (isNostrConnectDialogOpen) {
        Get.back();
        isNostrConnectDialogOpen = false;
      }
    }
  }

  void openNostrConnectDialog() async {
    if (nostrConnect == null) return;

    isNostrConnectDialogOpen = true;
    await Get.dialog(
      NostrConnectDialogView(nostrConnectURL: nostrConnect!.nostrConnectURL),
    );
    isNostrConnectDialogOpen = false;
  }

  void showBunkerAuthToast(String challenge) {
    final newToast = toastification.show(
      context: Get.context!,
      title: Text(AppLocalizations.of(Get.context!)!.bunkerAuthentication),
      description: Text(AppLocalizations.of(Get.context!)!.tapToOpen(challenge)),
      alignment: Alignment.bottomRight,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      showProgressBar: true,
      closeOnClick: false,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => launchUrl(Uri.parse(challenge)),
      ),
    );

    challengeToasts.add(newToast);
  }
}
