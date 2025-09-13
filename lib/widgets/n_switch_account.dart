import 'package:flutter/material.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/functions/n_save_accounts_state.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart';
import 'package:nostr_widgets/widgets/widgets.dart';

class NSwitchAccount extends StatefulWidget {
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
  State<NSwitchAccount> createState() => _NSwitchAccountState();
}

class _NSwitchAccountState extends State<NSwitchAccount> {
  @override
  Widget build(BuildContext context) {
    final pubkeys = widget.ndk.accounts.accounts.keys.toList();
    final loggedPubkey = widget.ndk.accounts.getPublicKey();

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
                  widget.beforeAccountRemove?.call(pubkey);
                  widget.ndk.accounts.removeAccount(pubkey: pubkey);
                  nSaveAccountsState(widget.ndk);
                  setState(() {});
                  widget.onAccountRemove?.call(pubkey);
                },
                child: Text(AppLocalizations.of(context)!.logout),
              ),
            );

            onTap = () {
              widget.beforeAccountSwitch?.call(pubkey);
              widget.ndk.accounts.switchAccount(pubkey: pubkey);
              nSaveAccountsState(widget.ndk);
              setState(() {});
              widget.onAccountSwitch?.call(pubkey);
            };
          }

          return ListTile(
            leading: NPicture(ndk: widget.ndk, pubkey: pubkey),
            title: NName(ndk: widget.ndk, pubkey: pubkey),
            subtitle: subtitle,
            trailing: trailing,
            onTap: onTap,
          );
        }),
        if (widget.onAddAccount != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton.icon(
              onPressed: widget.onAddAccount,
              label: Text(AppLocalizations.of(context)!.addAccount),
              icon: Icon(Icons.add_circle_outline),
            ),
          ),
      ],
    );
  }
}
