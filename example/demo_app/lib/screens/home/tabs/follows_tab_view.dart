import 'package:demo_app/widgets/page_wraper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class FollowsTabView extends StatelessWidget {
  const FollowsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ndk = Get.find<Ndk>();
    return FutureBuilder(
      future: ndk.follows.getContactList(
        "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d",
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return FutureBuilder(
          future: ndk.metadata.loadMetadatas(snapshot.data!.contacts, null),
          builder: (context, metadatasSnapshot) {
            if (!metadatasSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return PageWraper(
              child: Column(
                children: [
                  ...metadatasSnapshot.data!.map(
                    (e) => ListTile(
                      leading: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            e.picture ?? "https://robohash.org/${e.pubKey}",
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                "https://robohash.org/${e.pubKey}",
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(e.getName()),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
