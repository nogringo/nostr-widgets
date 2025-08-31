import 'package:demo_app/controllers/repository.dart';
import 'package:demo_app/screens/home/home_destinations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLargeLayout extends StatelessWidget {
  const HomeLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo app")),
      body: Obx(() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        extended: true,
                        selectedIndex: Repository.to.selectedIndex.value,
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
                    ),
                  ),
                );
              },
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
