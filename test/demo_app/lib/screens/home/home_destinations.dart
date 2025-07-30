import 'package:demo_app/screens/home/tabs/blossom_tab_view.dart';
import 'package:demo_app/screens/home/tabs/feed_tab_view.dart';
import 'package:flutter/material.dart';

List<AppNavigationTab> homeDestinations = [
  AppNavigationTab(
    icon: Icon(Icons.home),
    label: "Feed",
    destination: FeedTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.local_florist),
    label: "Blossom",
    destination: BlossomTabView(),
  ),
];

class AppNavigationTab {
  final Widget icon;
  final String label;
  final Widget destination;

  AppNavigationTab({
    required this.icon,
    required this.label,
    required this.destination,
  });
}
