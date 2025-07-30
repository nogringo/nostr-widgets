import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/widgets/n_login.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: NLogin(
              ndk: Get.find<Ndk>(),
              onLoggedIn: () {
                Get.offNamed(AppRoutes.profile);
                Repository.to.update();
              },
            ),
          ),
        ),
      ),
    );
  }
}
