## 0.0.3

- Add demo app
- Multi accounts support

### Breaking changes

- `nRestoreLastSession` to `nRestoreAccounts`
- `nLogout` is deleted : use `ndk.accounts.logout()` and then `nSaveAccountsState(ndk)`
- every `pubKey` was renamed to `pubkey`
