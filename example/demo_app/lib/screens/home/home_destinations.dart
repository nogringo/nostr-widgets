import 'package:demo_app/screens/home/tabs/accounts_tab_view.dart';
import 'package:demo_app/screens/home/tabs/broadcast_tab_view.dart';
import 'package:demo_app/screens/home/tabs/domain_verification_nip05_tab_view.dart';
import 'package:demo_app/screens/home/tabs/follows_tab_view.dart';
import 'package:demo_app/screens/home/tabs/relays_tab_view.dart';
import 'package:demo_app/screens/home/tabs/requests_tab_view.dart';
import 'package:demo_app/screens/home/tabs/metadata_tab_view.dart';
import 'package:demo_app/screens/home/tabs/widgets_tab_view.dart';
import 'package:flutter/material.dart';

List<AppNavigationTab> homeDestinations = [
  AppNavigationTab(
    icon: Icon(Icons.person),
    label: "Accounts",
    destination: AccountsTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.sell),
    label: "Metadata",
    destination: MetadataTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.rss_feed),
    label: "Relays",
    destination: RelaysTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.verified),
    label: "Domain verification (nip05)",
    destination: DomainVerificationNip05TabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.call_received),
    label: "Requests",
    destination: RequestsTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.arrow_outward),
    label: "Broadcast",
    destination: BroadcastTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.groups),
    label: "Follows",
    destination: FollowsTabView(),
  ),
  AppNavigationTab(
    icon: Icon(Icons.widgets_rounded),
    label: "Widgets",
    destination: WidgetsTabView(),
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
