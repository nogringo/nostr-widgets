import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BunkerChallengeDialogView extends StatelessWidget {
  final String challengeUrl;

  const BunkerChallengeDialogView({super.key, required this.challengeUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Challenge required"),
      content: Text(challengeUrl),
      actions: [
        FilledButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: challengeUrl));
          },
          child: Text("Copy"),
        ),
      ],
    );
  }
}
