import 'package:flutter/material.dart';
import 'package:ndk/ndk.dart';
import 'package:nip19/nip19.dart';

class NName extends StatelessWidget {
  final String pubkey;
  final Ndk ndk;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool displayNpub;

  const NName({
    super.key,
    required this.pubkey,
    required this.ndk,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.displayNpub = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getName(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(
            snapshot.data!,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        return Text(
          displayNpub ? _formatNpub(pubkey) : _formatPubkey(pubkey),
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  Future<String?> _getName() async {
    try {
      final userMetadata = await ndk.metadata.loadMetadata(pubkey);
      return userMetadata?.getName();
    } catch (e) {
      return null;
    }
  }

  String _formatPubkey(String pubkey) {
    return '${pubkey.substring(0, 6)}...${pubkey.substring(pubkey.length - 6)}';
  }

  String _formatNpub(String pubkey) {
    try {
      final npub = Nip19.npubFromHex(pubkey);
      return '${npub.substring(0, 6)}...${npub.substring(npub.length - 6)}';
    } catch (e) {
      return _formatPubkey(pubkey);
    }
  }
}
