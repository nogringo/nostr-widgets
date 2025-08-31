import 'package:demo_app/widgets/blossom_servers_view.dart';
import 'package:demo_app/widgets/page_wraper.dart';
import 'package:demo_app/widgets/relay_connectivity_view.dart';
import 'package:demo_app/widgets/user_relay_lists_view.dart';
import 'package:flutter/material.dart';

class RelaysTabView extends StatelessWidget {
  const RelaysTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge;
    return PageWraper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Connected relays", style: style),
          RelayConnectivityView(),
          SizedBox(height: 30),
          Text("User relays", style: style),
          UserRelayListsView(),
          SizedBox(height: 30),
          Text("Blossom servers", style: style),
          BlossomServersView(),
        ],
      ),
    );
  }
}
