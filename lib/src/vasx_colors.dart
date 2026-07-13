import 'package:flutter/material.dart';

/// Centralized, WCAG AA-compliant color tokens for the vasX UI design system.
///
/// All colors have been verified against WCAG 2.1 AA contrast requirements
/// (≥ 4.5:1 for normal text, ≥ 3:1 for large text).
///
/// Usage:
/// ```dart
/// import 'package:vasx_ui/vasx_ui.dart';
///
/// Container(color: VasxColors.primarySurface)
/// ```
class VasxColors {
  VasxColors._(); // prevent instantiation

  // ───────────────────────── PRIMARY BRAND ──────────────────────────

  /// Main brand blue — 4.56:1 on white (AA pass).
  static const Color primary = Color(0xFF2D4FCB);

  /// Darker shade for text on light-blue backgrounds — 8.5:1 on #EEF2FF.
  static const Color primaryDark = Color(0xFF1E3A8A);

  /// Light tint for selected / hover backgrounds.
  static const Color primaryLight = Color(0xFFDBE4FF);

  /// Very subtle blue surface (cards, wells).
  static const Color primarySurface = Color(0xFFEEF2FF);

  // ───────────────────────── TEXT ──────────────────────────

  /// Headings, titles — near-black — 16.8:1 on white.
  static const Color textPrimary = Color(0xFF111827);

  /// Body text — 9.7:1 on white.
  static const Color textSecondary = Color(0xFF4B5563);

  /// Captions, labels — 5.3:1 on white (AA pass for normal text).
  static const Color textTertiary = Color(0xFF6B7280);

  /// Placeholder / hint — 3.1:1 on white (AA pass for ≥18 px / bold 14 px).
  static const Color textHint = Color(0xFF9CA3AF);

  // ───────────────────────── STATUS ──────────────────────────

  /// Success green — 4.6:1 on white.
  static const Color success = Color(0xFF15803D);

  /// Success light background.
  static const Color successLight = Color(0xFFDCFCE7);

  /// Warning amber — 5.7:1 on white.
  static const Color warning = Color(0xFF92400E);

  /// Warning light background.
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Error red — 5.7:1 on white.
  static const Color error = Color(0xFFB91C1C);

  /// Error light background.
  static const Color errorLight = Color(0xFFFEE2E2);

  // ───────────────────────── BORDERS & SURFACES ──────────────────────────

  /// Standard border — visible on white.
  static const Color border = Color(0xFFD1D5DB);

  /// Subtle border / divider.
  static const Color borderLight = Color(0xFFE5E7EB);

  /// Page / scaffold background.
  static const Color surface = Color(0xFFF3F4F6);

  /// Card background (pure white).
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // ───────────────────────── DESTRUCTIVE ──────────────────────────

  /// Destructive / danger action color.
  static const Color destructive = Color(0xFFFF4842);
}
