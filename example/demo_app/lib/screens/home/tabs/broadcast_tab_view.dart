import 'package:demo_app/widgets/page_wraper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk/shared/nips/nip01/bip340.dart';

class BroadcastTabView extends StatelessWidget {
  const BroadcastTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = TextEditingController();

    return PageWraper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: "Write a note",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            maxLines: 5,
          ),
          SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              final keyPair = Bip340.generatePrivateKey();
              final signer = Bip340EventSigner(
                privateKey: keyPair.privateKey,
                publicKey: keyPair.publicKey,
              );
              final event = Nip01Event(
                pubKey: keyPair.publicKey,
                kind: 1,
                tags: [],
                content: noteController.text,
              );
              signer.sign(event);
              Get.find<Ndk>().broadcast.broadcast(nostrEvent: event);
            },
            child: Text("Send this note"),
          ),
        ],
      ),
    );
  }
}
