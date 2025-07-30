import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:toastification/toastification.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();

  RxInt selectedIndex = 0.obs;
  List<Nip01Event> publicNotes = [];

  TextEditingController nwcSecretController = TextEditingController();
  NwcConnection? nwcConnection;

  Ndk get ndk => Get.find();

  Repository() {
    initApp();
  }

  void initApp() async {
    fetchNotes();

    final storage = FlutterSecureStorage();
    final nwcSecret = await storage.read(key: "NWC_SECRET");
    if (nwcSecret != null) nwcConnect(nwcSecret);
  }

  void fetchNotes() async {
    final response = ndk.requests.query(
      filters: [
        Filter(
          kinds: [1],
          authors: [
            "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
            "30782a8323b7c98b172c5a2af7206bb8283c655be6ddce11133611a03d5f1177",
            "b22b06b051fd5232966a9344a634d956c3dc33a7f5ecdcad9ed11ddc4120a7f2",
          ],
          limit: 10,
        ),
      ],
    );

    await for (final event in response.stream) {
      publicNotes.add(event);
    }

    publicNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    update();
  }

  void nwcConnect(String nwcSecret) async {
    nwcConnection = await ndk.nwc.connect(nwcSecret.trim());
    update();
    await FlutterSecureStorage().write(
      key: "NWC_SECRET",
      value: nwcSecret.trim(),
    );
  }

  void disconnectNWC() async {
    await ndk.nwc.disconnect(nwcConnection!);
    nwcConnection = null;
    update();
    await FlutterSecureStorage().delete(key: "NWC_SECRET");
  }

  void zap(Nip01Event event) async {
    if (nwcConnection == null) return;

    final metadata = await ndk.metadata.loadMetadata(event.pubKey);

    if (metadata == null) return;
    if (metadata.lud16 == null) return;

    await ndk.zaps.zap(
      nwcConnection: nwcConnection!,
      lnurl: metadata.lud16!,
      amountSats: 10,
      comment: "Sent from dart NDK demo app",
    );

    toastification.show(
      title: Text(
        "Zap sent !",
        style: TextStyle(
          color: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
        ),
      ),
      alignment: Alignment.bottomRight,
      autoCloseDuration: Duration(seconds: 4),
      backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
      borderSide: BorderSide(
        color: Theme.of(Get.context!).colorScheme.primaryContainer,
      ),
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      icon: Icon(
        Icons.bolt,
        color: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
      ),
    );

    update();
  }
}
