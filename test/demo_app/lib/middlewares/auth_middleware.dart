import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:demo_app/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final ndk = Get.find<Ndk>();
    final isLoggedIn = ndk.accounts.getPublicKey() != null;

    if (route == AppRoutes.signIn && isLoggedIn) {
      return const RouteSettings(name: AppRoutes.profile);
    }

    if (route == AppRoutes.profile && !isLoggedIn) {
      return const RouteSettings(name: AppRoutes.signIn);
    }

    return null;
  }
}