import 'package:demo_app/widgets/page_wraper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class WidgetsTabView extends StatelessWidget {
  const WidgetsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ndk = Get.find<Ndk>();
    final style = Theme.of(context).textTheme.titleLarge!.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );
    return PageWraper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("NBanner", style: style),
          NBanner(
            ndk: ndk,
            pubkey:
                "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
          ),
          SizedBox(height: 30),
          Text("NPicture", style: style),
          NPicture(
            ndk: ndk,
            pubkey:
                "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
          ),
          SizedBox(height: 30),
          Text("NName", style: style),
          NName(
            ndk: ndk,
            pubkey:
                "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
          ),
          SizedBox(height: 30),
          Text("NUserProfile", style: style),
          NUserProfile(
            ndk: ndk,
            pubkey:
                "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
          ),
          SizedBox(height: 30),
          Text("NLogin", style: style),
          NLogin(
            ndk: ndk,
            nostrConnect: NostrConnect(
              relays: ["wss://relay.nsec.app"],
              appName: "Demo app",
            ),
            onLoggedIn: () {
              print("logged in");
            },
          ),
          SizedBox(height: kToolbarHeight),
        ],
      ),
    );
  }
}
