import 'dart:math';

import 'package:flutter/material.dart';

/// Parses a hex color string (with or without a leading '#') into a [Color].
/// The hex string is expected to be 6 characters long (RGB, no alpha); the
/// resulting [Color] will be fully opaque (alpha = 0xFF).
Color? parseHexColor(String hex) {
  if (hex.isEmpty) {
    return null;
  }
  final sanitized = hex.replaceAll("#", "");
  return Color(int.parse("FF$sanitized", radix: 16));
}

/// Returns true if [foreground] is readable against [background] using the
/// WCAG relative luminance formula. The minimum contrast ratio defaults to
/// 3.0, which is the WCAG AA threshold for large text.
///
/// Returns false if either [foreground] or [background] is null.
bool isColorReadable(
  Color? foreground,
  Color? background, {
  double minContrastRatio = 3.0,
}) {
  if (foreground == null || background == null) {
    return false;
  }
  final l1 = _relativeLuminance(foreground);
  final l2 = _relativeLuminance(background);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05) >= minContrastRatio;
}

double _relativeLuminance(Color color) {
  double linearize(int channel) {
    final c = channel / 255.0;
    return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(color.clampedRed) +
      0.7152 * linearize(color.clampedGreen) +
      0.0722 * linearize(color.clampedBlue);
}

extension ColorExt on Color {
  int get clampedRed => (r * 255.0).round().clamp(0, 255);

  int get clampedGreen => (g * 255.0).round().clamp(0, 255);

  int get clampedBlue => (b * 255.0).round().clamp(0, 255);

  int get clampedAlpha => (a * 255.0).round().clamp(0, 255);
}
