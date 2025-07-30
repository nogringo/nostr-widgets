This package helps you to easily produce Nostr apps by providing generics Widgets and methods.

## Features

- Nostr widgets
- Login persistence

## Getting started

```bash
flutter pub add ndk
flutter pub add nostr_widgets
```

## Usage

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

// call this to connect user from local storage
nRestoreLastSession(ndk);

// logout the user and delete his local storage
nLogout(ndk);
```

## TODO

- [ ] NPicture letter as big as possible
- [ ] NUserProfile optionnal show nsec and copy
- [ ] NUserProfile show the letter in the Picture and make it as big as possible
