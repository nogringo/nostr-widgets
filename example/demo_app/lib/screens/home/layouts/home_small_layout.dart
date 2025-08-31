import 'package:demo_app/controllers/repository.dart';
import 'package:demo_app/screens/home/home_destinations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSmallLayout extends StatelessWidget {
  const HomeSmallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo app")),
      body: Obx(
        () => homeDestinations[Repository.to.selectedIndex.value].destination,
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: Repository.to.selectedIndex.value,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
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
