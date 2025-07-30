import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();

  List<Nip01Event> publicNotes = [];

  Ndk get ndk => Get.find();

  Repository() {
    fetchNotes();
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
}
