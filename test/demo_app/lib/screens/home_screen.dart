import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';
import 'package:nostr_widgets/widgets/n_picture.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.profile);
            },
            child: CircleAvatar(
              child: ClipOval(child: NPicture(ndk: Get.find<Ndk>())),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                ...Repository.to.publicNotes.map(
                  (note) => NoteView(event: note),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteView extends StatelessWidget {
  final Nip01Event event;

  const NoteView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: ClipOval(
                child: NPicture(ndk: Get.find<Ndk>(), pubkey: event.pubKey),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NName(
                    ndk: Get.find<Ndk>(),
                    pubkey: event.pubKey,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(event.content.trim()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
