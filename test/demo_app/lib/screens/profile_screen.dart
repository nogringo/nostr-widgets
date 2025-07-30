import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.home);
            },
            icon: Icon(Icons.home),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<Repository>(
                  builder: (c) {
                    return NUserProfile(
                      ndk: Get.find<Ndk>(),
                      onLogout: () {
                        // if (Get.find<Ndk>().accounts.) {
                        //   Get.offAllNamed(AppRoutes.signIn);
                        // }
                      },
                    );
                  },
                ),
                SizedBox(height: 100),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.switchAccount);
                  },
                  child: Text("Switch account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
