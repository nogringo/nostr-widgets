import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class SwitchAccountScreen extends StatelessWidget {
  const SwitchAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ndk = Get.find<Ndk>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Switch account"),
        actions: [
          GetBuilder<Repository>(
            builder: (c) {
              if (c.ndk.accounts.isLoggedIn) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.profile);
                  },
                  child: NPicture(ndk: Get.find<Ndk>()),
                );
              }
              return TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.signIn);
                },
                child: Text("Sign in"),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                ...ndk.accounts.accounts.values
                    .where(
                      (account) =>
                          account.pubkey != ndk.accounts.getPublicKey(),
                    )
                    .map((account) {
                      return TapView(
                        child: ListTile(
                          leading: NPicture(ndk: ndk, pubkey: account.pubkey),
                          title: NName(pubkey: account.pubkey, ndk: ndk),
                          onTap: () async {
                            ndk.accounts.switchAccount(pubkey: account.pubkey);
                            await nSaveAccountsState(ndk);
                            Get.offAllNamed(AppRoutes.profile);
                          },
                        ),
                      );
                    }),
                TapView(
                  child: ListTile(
                    leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(Icons.add),
                    ),
                    title: Text("Add an account"),
                    onTap: () {
                      Get.toNamed(AppRoutes.signIn);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TapView extends StatelessWidget {
  final Widget child;

  const TapView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(child: child),
      ),
    );
  }
}
