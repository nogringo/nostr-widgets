import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class UserRelayListsView extends StatelessWidget {
  const UserRelayListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<Ndk>().userRelayLists.getSingleUserRelayList(
        "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d",
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return Column(
          children: snapshot.data!.relays.keys
              .map((relayUrl) => ListTile(title: Text(relayUrl)))
              .toList(),
        );
      },
    );
  }
}
