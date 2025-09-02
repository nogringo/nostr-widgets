import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/controllers/n_switch_account_controller.dart';
import 'package:nostr_widgets/functions/n_save_accounts_state.dart';
import 'package:nostr_widgets/widgets/widgets.dart';

class NSwitchAccount extends StatelessWidget {
  final Ndk ndk;
  final void Function(String pubkey)? onAccountSwitch;
  final void Function(String pubkey)? onAccountRemove;
  final void Function()? onAddAccount;
  final void Function(String pubkey)? beforeAccountSwitch;
  final void Function(String pubkey)? beforeAccountRemove;

  const NSwitchAccount({
    super.key,
    required this.ndk,
    this.onAccountSwitch,
    this.onAccountRemove,
    this.onAddAccount,
    this.beforeAccountSwitch,
    this.beforeAccountRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NSwitchAccountController>(
      init: NSwitchAccountController(),
      builder: (c) {
        final pubkeys = ndk.accounts.accounts.keys.toList();
        final loggedPubkey = ndk.accounts.getPublicKey();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...pubkeys.map((pubkey) {
              final isLoggedAccount = loggedPubkey == pubkey;

              Widget? subtitle;
              Widget? trailing;
              void Function()? onTap;
              if (isLoggedAccount) {
                trailing = Icon(
                  Icons.radio_button_checked,
                  color: Theme.of(context).colorScheme.primary,
                );
              } else {
                subtitle = Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      beforeAccountRemove?.call(pubkey);
                      ndk.accounts.removeAccount(pubkey: pubkey);
                      nSaveAccountsState(ndk);
                      c.update();
                      onAccountRemove?.call(pubkey);
                    },
                    child: Text("Logout"),
                  ),
                );

                onTap = () {
                  beforeAccountSwitch?.call(pubkey);
                  ndk.accounts.switchAccount(pubkey: pubkey);
                  nSaveAccountsState(ndk);
                  c.update();
                  onAccountSwitch?.call(pubkey);
                };
              }

              return ListTile(
                leading: NPicture(ndk: ndk, pubkey: pubkey),
                title: NName(ndk: ndk, pubkey: pubkey),
                subtitle: subtitle,
                trailing: trailing,
                onTap: onTap,
              );
            }),
            if (onAddAccount != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton.icon(
                  onPressed: onAddAccount,
                  label: Text("Add account"),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ),
          ],
        );
      },
    );
  }
}
