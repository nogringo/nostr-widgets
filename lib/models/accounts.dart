class NostrWidgetsAccounts {
  String? loggedAccount;
  bool nip07;
  bool amber;
  List<String> pubkeys;
  List<String> privkeys;

  NostrWidgetsAccounts({
    this.loggedAccount,
    this.nip07 = false,
    this.amber = false,
    required this.pubkeys,
    required this.privkeys,
  });

  Map<String, dynamic> toJson() {
    return {
      'loggedAccount': loggedAccount,
      'nip07': nip07,
      'amber': amber,
      'pubkeys': pubkeys,
      'privkeys': privkeys,
    };
  }

  factory NostrWidgetsAccounts.fromJson(Map<String, dynamic> json) {
    return NostrWidgetsAccounts(
      loggedAccount: json['loggedAccount'],
      nip07: json['nip07'] ?? false,
      amber: json['amber'] ?? false,
      pubkeys: List<String>.from(json['pubkeys'] ?? []),
      privkeys: List<String>.from(json['privkeys'] ?? []),
    );
  }
}
