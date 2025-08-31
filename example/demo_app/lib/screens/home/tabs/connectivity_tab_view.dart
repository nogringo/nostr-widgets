import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class ConnectivityTabView extends StatelessWidget {
  const ConnectivityTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Get.find<Ndk>().connectivity.relayConnectivityChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...snapshot.data!.entries.map(
                    (e) => ListTile(
                      title: Text(e.key),
                      trailing: Container(
                        width: 4,
                        height: 4,
                        color: e.value.isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
