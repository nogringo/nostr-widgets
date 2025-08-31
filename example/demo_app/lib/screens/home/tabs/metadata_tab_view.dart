import 'package:demo_app/widgets/page_wraper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class MetadataTabView extends StatelessWidget {
  const MetadataTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWraper(
      child: FutureBuilder(
        future: Get.find<Ndk>().metadata.loadMetadata(
          "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d",
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          final metadata = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (metadata.banner != null) Text("banner : ${metadata.banner!}"),
              if (metadata.picture != null)
                Text("picture : ${metadata.picture!}"),
              if (metadata.name != null) Text("name : ${metadata.name!}"),
              if (metadata.displayName != null)
                Text("displayName : ${metadata.displayName!}"),
              if (metadata.nip05 != null) Text("nip05 : ${metadata.nip05!}"),
              if (metadata.about != null) Text("about : ${metadata.about!}"),
              if (metadata.lud06 != null) Text("lud06 : ${metadata.lud06!}"),
              if (metadata.lud16 != null) Text("lud16 : ${metadata.lud16!}"),
              if (metadata.website != null)
                Text("website : ${metadata.website!}"),
            ],
          );
        },
      ),
    );
  }
}
