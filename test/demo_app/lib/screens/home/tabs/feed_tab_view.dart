import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class FeedTabView extends StatelessWidget {
  const FeedTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: GetBuilder<Repository>(
            builder: (c) {
              return Column(
                children: [
                  ...Repository.to.publicNotes.map((note) => NoteView(event: note)),
                  SizedBox(height: 100),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class NoteView extends StatelessWidget {
  final Nip01Event event;

  const NoteView({super.key, required this.event});

  String _getTimeAgo(int createdAt) {
    final now = DateTime.now();
    final eventTime = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    final difference = now.difference(eventTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

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
            NPicture(ndk: Get.find<Ndk>(), pubkey: event.pubKey),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      NName(
                        ndk: Get.find<Ndk>(),
                        pubkey: event.pubKey,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _getTimeAgo(event.createdAt),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ],
                  ),
                  Text(event.content.trim()),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GetBuilder<Repository>(
                      builder: (c) {
                        return OutlinedButton.icon(
                          onPressed: Repository.to.nwcConnection == null
                              ? null
                              : () {
                                  Repository.to.zap(event);
                                },
                          label: Text("Zap"),
                          icon: Icon(Icons.bolt),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
