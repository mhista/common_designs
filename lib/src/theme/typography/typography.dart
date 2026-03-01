import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// Typography system matching the Shopify-style design
/// Based on the screenshots provided
class AppTypography {
  AppTypography._();

  // ============================================================
  // BASE FONT
  // ============================================================

  /// Base font family - using Inter for clean, modern look
  /// (Similar to what's used in the Shopify app)
  static TextStyle get baseFont => GoogleFonts.inter();

  // Alternative: If you prefer SF Pro style
  // static TextStyle get baseFont => GoogleFonts.sfProDisplay();

  // ============================================================
  // DISPLAY STYLES (Extra Large Headings)
  // ============================================================

  /// Display Large - 57px (not commonly used in mobile)
  static TextStyle displayLarge({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color,
      );

  /// Display Medium - 45px
  static TextStyle displayMedium({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 45,
        height: 1.16,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color,
      );

  /// Display Small - 36px
  static TextStyle displaySmall({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 36,
        height: 1.22,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  // ============================================================
  // HEADLINE STYLES (Page Titles)
  // ============================================================

  /// Headline Large - 32px
  /// Use for: Main page titles
  static TextStyle headlineLarge({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 32,
        height: 1.25,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color,
      );

  /// Headline Medium - 28px
  /// Use for: Section headers
  static TextStyle headlineMedium({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 28,
        height: 1.29,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Headline Small - 24px
  /// Use for: Card titles, dialog headers
  /// Example: "Track your orders every step of the way"
  static TextStyle headlineSmall({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 24,
        height: 1.33,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  // ============================================================
  // TITLE STYLES (Subsections)
  // ============================================================

  /// Title Large - 22px
  /// Use for: Important subsections
  static TextStyle titleLarge({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 22,
        height: 1.27,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Title Medium - 16px, Semi-bold
  /// Use for: List item titles, card headers
  /// Example: "Set up Shop Pay", "Minimalist Hoodie"
  static TextStyle titleMedium({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Title Small - 14px, Semi-bold
  /// Use for: Small card titles, tabs
  static TextStyle titleSmall({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  // ============================================================
  // BODY STYLES (Main Content)
  // ============================================================

  /// Body Large - 16px
  /// Use for: Important body text, descriptions
  /// Example: Product descriptions
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.5,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  /// Body Medium - 14px
  /// Use for: Standard body text
  /// Example: "Our Minimalist Hoodie features a Super Soft Combed Cotton Blend..."
  static TextStyle bodyMedium({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  /// Body Small - 12px
  /// Use for: Secondary text, captions
  static TextStyle bodySmall({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  // ============================================================
  // LABEL STYLES (Buttons, Tags)
  // ============================================================

  /// Label Large - 14px, Semi-bold
  /// Use for: Primary buttons
  /// Example: "Get Started", "Continue", "Add to cart"
  static TextStyle labelLarge({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Label Medium - 12px, Semi-bold
  /// Use for: Secondary buttons, chips
  static TextStyle labelMedium({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Label Small - 11px, Semi-bold
  /// Use for: Small tags, badges
  static TextStyle labelSmall({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  // ============================================================
  // UTILITY STYLES
  // ============================================================

  /// Overline - 10px, All Caps
  /// Use for: Section labels, categories
  static TextStyle overline({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 10,
        height: 1.6,
        letterSpacing: 1.5,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  /// Caption - 12px
  /// Use for: Hints, helper text
  /// Example: "Orders you place in Shop or sync from your emails will show up here"
  static TextStyle caption({
    Color? color,
    FontWeight? fontWeight,
  }) =>
      baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  // ============================================================
  // CUSTOM STYLES (From Screenshots)
  // ============================================================

  /// Product Price - Large, Bold
  static TextStyle price({
    Color? color,
    bool isDiscounted = false,
  }) =>
      baseFont.copyWith(
        fontSize: 24,
        height: 1.33,
        fontWeight: FontWeight.w700,
        color: color,
        decoration: isDiscounted ? TextDecoration.lineThrough : null,
      );

  /// Original Price (struck through)
  static TextStyle originalPrice({Color? color}) => baseFont.copyWith(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.grey,
        decoration: TextDecoration.lineThrough,
      );

  /// Rating Text
  static TextStyle rating({Color? color}) => baseFont.copyWith(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w500,
        color: color,
      );

  /// Tab Text
  static TextStyle tab({
    Color? color,
    bool isSelected = false,
  }) =>
      baseFont.copyWith(
        fontSize: 14,
        height: 1.43,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: color,
      );

  /// Navigation Label
  static TextStyle navLabel({
    Color? color,
    bool isSelected = false,
  }) =>
      baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: color,
      );

  /// Input Text
  static TextStyle input({Color? color}) => baseFont.copyWith(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      );

  /// Input Label
  static TextStyle inputLabel({Color? color}) => baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: color,
      );

  /// Error Text
  static TextStyle error({Color? color}) => baseFont.copyWith(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.red,
      );
}

// ============================================================
// TEXT THEME GENERATOR
// ============================================================

/// Generate Material TextTheme from AppTypography
class AppTextTheme {
  static TextTheme light({Color? color}) => TextTheme(
        displayLarge: AppTypography.displayLarge(color: color),
        displayMedium: AppTypography.displayMedium(color: color),
        displaySmall: AppTypography.displaySmall(color: color),
        headlineLarge: AppTypography.headlineLarge(color: color),
        headlineMedium: AppTypography.headlineMedium(color: color),
        headlineSmall: AppTypography.headlineSmall(color: color),
        titleLarge: AppTypography.titleLarge(color: color),
        titleMedium: AppTypography.titleMedium(color: color),
        titleSmall: AppTypography.titleSmall(color: color),
        bodyLarge: AppTypography.bodyLarge(color: color),
        bodyMedium: AppTypography.bodyMedium(color: color),
        bodySmall: AppTypography.bodySmall(color: color),
        labelLarge: AppTypography.labelLarge(color: color),
        labelMedium: AppTypography.labelMedium(color: color),
        labelSmall: AppTypography.labelSmall(color: color),
      );

  static TextTheme dark({Color? color}) => light(color: color);
}

// ============================================================
// USAGE EXAMPLE
// ============================================================

/// Example usage in your theme:
/// ```dart
/// ThemeData(
///   textTheme: AppTextTheme.light(),
/// )
/// ```
///
/// Or use directly in widgets:
/// ```dart
/// Text(
///   'Track your orders',
///   style: AppTypography.headlineSmall(),
/// )
/// ```