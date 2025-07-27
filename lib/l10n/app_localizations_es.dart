// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get createAccount => 'Crear tu cuenta';

  @override
  String get newHere => '¿Eres nuevo aquí?';

  @override
  String get nostrAddress => 'Dirección Nostr';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get privateKey => 'Clave privada';

  @override
  String get browserExtension => 'Extensión del navegador';

  @override
  String get connect => 'Conectar';

  @override
  String get install => 'Instalar';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get nostrAddressHint => 'nombre@ejemplo.com';

  @override
  String get invalidAddress => 'Dirección inválida';

  @override
  String get unableToConnect => 'No se puede conectar';

  @override
  String get publicKeyHint => 'npub1...';

  @override
  String get privateKeyHint => 'nsec1...';

  @override
  String get newToNostr => '¿Nuevo en Nostr?';

  @override
  String get getStarted => 'Comenzar';
}
