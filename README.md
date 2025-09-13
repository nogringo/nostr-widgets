This package helps you to easily produce Nostr apps by providing generics Widgets and methods.

## Demo app

The demo app is available [here](https://nogringo.github.io/nostr-widgets/)

## Features

- Nostr widgets
- Login persistence

## Getting started

### Add dependencies

```bash
flutter pub add ndk
flutter pub add nostr_widgets
```

### Add internationalization

Follow https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

```dart
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;

localizationsDelegates: [
    nostr_widgets.AppLocalizations.delegate,
],
```

## Usage

By default, the logged user is used for user widgets, you can overwrite it by providing the pubkey parameter when available.

```dart
import 'package:nostr_widgets/nostr_widgets.dart';

// login page with all login methods
final loginPage = ListView(
    children: [
        NLogin(ndk),
    ],
);

// user info
final userPage = ListView(
    children: [
        NUserProfile(ndk),
    ],
);

final userBanner = NBanner(ndk);
final userPicture = NPicture(ndk);
final userName = NName(ndk);

NSwitchAccount(ndk);

// call this to connect user from local storage
nRestoreAccounts(ndk);

// call this every time the auth state change
nSaveAccountsState(ndk);
```

## TODO

- [ ] NPicture letter as big as possible
- [ ] NUserProfile optionnal show nsec and copy
- [ ] NUserProfile show the letter in the Picture and make it as big as possible

## Need more Widgets

Open an Issue or ask me on Nostr npub1kg4sdvz3l4fr99n2jdz2vdxe2mpacva87hkdetv76ywacsfq5leqquw5te
