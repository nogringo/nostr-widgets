import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:demo_app/screens/home/home_destinations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class HomeSmallLayout extends StatelessWidget {
  const HomeSmallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo app"),
        actions: [
          GetBuilder<Repository>(
            builder: (c) {
              if (c.ndk.accounts.isLoggedIn) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.profile);
                  },
                  child: NPicture(ndk: Get.find<Ndk>()),
                );
              }
              return TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.signIn);
                },
                child: Text("Sign in"),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => homeDestinations[Repository.to.selectedIndex.value].destination,
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: Repository.to.selectedIndex.value,
          onDestinationSelected: (value) {
            Repository.to.selectedIndex.value = value;
          },
          destinations: homeDestinations
              .map(
                (tab) =>
                    NavigationDestination(icon: tab.icon, label: tab.label),
              )
              .toList(),
        ),
      ),
    );
  }
}
