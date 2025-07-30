import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:demo_app/screens/home/home_destinations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class HomeLargeLayout extends StatelessWidget {
  const HomeLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome Feed"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.profile);
            },
            child: NPicture(ndk: Get.find<Ndk>()),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        return Row(
          children: [
            NavigationRail(
              selectedIndex: Repository.to.selectedIndex.value,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (value) {
                Repository.to.selectedIndex.value = value;
              },
              destinations: homeDestinations
                  .map(
                    (tab) => NavigationRailDestination(
                      icon: tab.icon,
                      label: Text(tab.label),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: homeDestinations[Repository.to.selectedIndex.value]
                  .destination,
            ),
          ],
        );
      }),
    );
  }
}
