import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Generates a consistent color from a Nostr public key (npub or hex format).
///
/// This implementation uses SHA-256 hashing for better distribution
/// and follows common practices in the Nostr ecosystem for visual
/// identification of users.
Color getColorFromPubkey(String pubKey) {
  if (pubKey.isEmpty) return const Color(0xFF808080);

  // Hash the pubkey using SHA-256 for better distribution
  final bytes = utf8.encode(pubKey);
  final digest = sha256.convert(bytes);

  // Use first 3 bytes of hash for RGB values
  final hashBytes = digest.bytes;
  final r = hashBytes[0];
  final g = hashBytes[1];
  final b = hashBytes[2];

  // Create color from RGB values
  final color = Color.fromARGB(255, r, g, b);

  // Convert to HSL to ensure good visibility
  final hslColor = HSLColor.fromColor(color);

  // Adjust saturation and lightness for better visibility
  // Keep hue from hash but ensure readable colors
  final adjustedHslColor = hslColor.withSaturation(0.6).withLightness(0.45);

  return adjustedHslColor.toColor();
}
