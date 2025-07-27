// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get createAccount => 'Créer votre compte';

  @override
  String get newHere => 'Êtes-vous nouveau ici?';

  @override
  String get nostrAddress => 'Adresse Nostr';

  @override
  String get publicKey => 'Clé publique';

  @override
  String get privateKey => 'Clé privée';

  @override
  String get browserExtension => 'Extension de navigateur';

  @override
  String get connect => 'Se connecter';

  @override
  String get install => 'Installer';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get nostrAddressHint => 'nom@exemple.com';

  @override
  String get invalidAddress => 'Adresse invalide';

  @override
  String get unableToConnect => 'Impossible de se connecter';

  @override
  String get publicKeyHint => 'npub1...';

  @override
  String get privateKeyHint => 'nsec1...';

  @override
  String get newToNostr => 'Nouveau sur Nostr?';

  @override
  String get getStarted => 'Commencer';
}
