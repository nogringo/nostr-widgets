import 'package:flutter/material.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/functions/get_color_from_pubkey.dart';

class NPicture extends StatelessWidget {
  final Ndk ndk;
  final String? pubkey;

  String? get _pubkey => pubkey ?? ndk.accounts.getPublicKey();

  const NPicture({super.key, required this.ndk, this.pubkey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ndk.metadata.loadMetadata(_pubkey!),
      builder: (context, snapshot) {
        return _buildPictureContent(context, snapshot);
      },
    );
  }

  Widget _buildPictureContent(
    BuildContext context,
    AsyncSnapshot<Metadata?> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildDefaultPicture(context, snapshot.data?.getName());
    }

    final picture = snapshot.data?.picture;
    if (picture == null) {
      return _buildDefaultPicture(context, snapshot.data?.getName());
    }

    return _buildImagePicture(context, picture);
  }

  Widget _buildDefaultPicture(BuildContext context, String? name) {
    final initial = name?.isNotEmpty == true ? name![0].toUpperCase() : '';
    final color = getColorFromPubkey(_pubkey!);

    return Container(
      color: color,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildImagePicture(BuildContext context, String pictureUrl) {
    return Image.network(
      pictureUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return ColoredBox(color: getColorFromPubkey(_pubkey!));
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultPicture(context, null);
      },
    );
  }
}
