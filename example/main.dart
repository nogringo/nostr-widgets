import 'package:flutter/material.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ndk = Ndk.defaultConfig();

    return MaterialApp(
      home: Scaffold(
        body: NLogin(ndk: ndk),
      ),
    );
  }
}