import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class MetadataView extends StatelessWidget {
  const MetadataView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<Ndk>().metadata.loadMetadata(
        "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d",
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final metadata = snapshot.data!;

        return Column(
          children: [
            if (metadata.banner != null) Text(metadata.banner!),
            if (metadata.picture != null) Text(metadata.picture!),
          ],
        );
      },
    );
  }
}
