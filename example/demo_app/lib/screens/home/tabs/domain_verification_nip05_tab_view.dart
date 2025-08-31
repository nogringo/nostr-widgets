import 'package:demo_app/widgets/page_wraper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';

class DomainVerificationNip05TabView extends StatefulWidget {
  const DomainVerificationNip05TabView({super.key});

  @override
  State<DomainVerificationNip05TabView> createState() =>
      _DomainVerificationNip05TabViewState();
}

class _DomainVerificationNip05TabViewState
    extends State<DomainVerificationNip05TabView> {
  final nip05Controller = TextEditingController(text: "leo@camelus.app");
  final pubkeyController = TextEditingController(
    text: "717ff238f888273f5d5ee477097f2b398921503769303a0c518d06a952f2a75e",
  );
  bool? isValid;

  @override
  Widget build(BuildContext context) {
    return PageWraper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nip05Controller,
            decoration: InputDecoration(labelText: "Nostr address"),
          ),
          SizedBox(height: 8),
          TextField(
            controller: pubkeyController,
            decoration: InputDecoration(labelText: "Public key"),
          ),
          SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final response = await Get.find<Ndk>().nip05.check(
                nip05: nip05Controller.text,
                pubkey: pubkeyController.text,
              );

              setState(() {
                isValid = response.valid;
              });
            },
            child: Text("Verify"),
          ),
          SizedBox(height: 8),
          if (isValid != null) Text("Is valid : $isValid"),
        ],
      ),
    );
  }
}
