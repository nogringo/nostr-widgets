import 'dart:convert';
import 'package:http/http.dart' as http;

class Nip05Result {
  final String? pubkey;
  final List<String>? relays;
  final String? error;

  Nip05Result({this.pubkey, this.relays, this.error});
}

Future<Nip05Result> fetchNip05(String nip05) async {
  await Future.delayed(Duration(seconds: 2));

  try {
    final parts = nip05.split('@');
    if (parts.length != 2) {
      return Nip05Result(
        error: 'Invalid NIP-05 format. Expected format: name@domain.com',
      );
    }

    final name = parts[0];
    final domain = parts[1];

    final uri = Uri.https(domain, '/.well-known/nostr.json', {"name": name});
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return Nip05Result(
        error: 'Failed to fetch NIP-05 data: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final names = json['names'] as Map<String, dynamic>?;
    final relays = json['relays'] as Map<String, dynamic>?;

    if (names == null || !names.containsKey(name)) {
      return Nip05Result(error: 'Name not found in NIP-05 data');
    }

    final pubkey = names[name] as String;
    final userRelays = relays?[pubkey] as List<dynamic>?;

    return Nip05Result(pubkey: pubkey, relays: userRelays?.cast<String>());
  } catch (e) {
    return Nip05Result(error: 'Error fetching NIP-05: $e');
  }
}
