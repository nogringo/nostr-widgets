import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class AccountsTabView extends StatelessWidget {
  const AccountsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ndk = Get.find<Ndk>();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...ndk.accounts.accounts.values
                  .where(
                    (account) => account.pubkey != ndk.accounts.getPublicKey(),
                  )
                  .map((account) {
                    return TapView(
                      child: ListTile(
                        leading: NPicture(ndk: ndk, pubkey: account.pubkey),
                        title: NName(pubkey: account.pubkey, ndk: ndk),
                        onTap: () async {
                          ndk.accounts.switchAccount(pubkey: account.pubkey);
                          await nSaveAccountsState(ndk);
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
                ),
              ),
            ],
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
