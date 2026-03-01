import 'package:flutter/material.dart';

/// App color scheme based on the Shopify design
class AppColors {
  AppColors._();

  // ============================================================
  // PRIMARY COLORS
  // ============================================================

  /// Primary brand color (Purple/Blue from the app)
  static const Color primary = Color(0xFF5D5FEF); // Shopify's primary purple
  static const Color primaryDark = Color(0xFF4547D5);
  static const Color primaryLight = Color(0xFF7E80F7);

  /// Secondary/Accent colors
  static const Color accent = Color(0xFF00C8FF);
  static const Color accentDark = Color(0xFF00A3D9);

  // ============================================================
  // NEUTRAL COLORS
  // ============================================================

  /// Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Card colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  /// Light mode text
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);

  /// Dark mode text
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF808080);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  /// Success
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Error
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Info
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================================
  // UI ELEMENT COLORS
  // ============================================================

  /// Border colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  /// Divider colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  /// Disabled colors
  static const Color disabledLight = Color(0xFFBDBDBD);
  static const Color disabledDark = Color(0xFF616161);

  /// Overlay colors
  static const Color overlayLight = Color(0x66000000);
  static const Color overlayDark = Color(0x99000000);

  // ============================================================
  // SPECIAL COLORS (From Screenshots)
  // ============================================================

  /// Like button color
  static const Color like = Color(0xFFFF3B30);

  /// Badge/notification color
  static const Color badge = Color(0xFFFF3B30);

  /// Rating star color
  static const Color ratingStar = Color(0xFFFFC107);

  /// Shimmer colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ============================================================
  // CATEGORY COLORS (From your screenshots)
  // ============================================================

  /// Women category
  static const Color categoryWomen = Color(0xFFD1D5DB);

  /// Men category
  static const Color categoryMen = Color(0xFF1E40AF);

  /// Beauty category
  static const Color categoryBeauty = Color(0xFFFF1F8C);

  /// Food & Drinks category
  static const Color categoryFood = Color(0xFFC084FC);

  /// Baby & Toddler category
  static const Color categoryBaby = Color(0xFFFBBF24);

  /// Home category
  static const Color categoryHome = Color(0xFFFB923C);

  /// Fitness & Nutrition category
  static const Color categoryFitness = Color(0xFF86EFAC);

  /// Accessories category
  static const Color categoryAccessories = Color(0xFF3B82F6);

  // transparent 
  static const Color transparent = Colors.transparent;
}

// ============================================================
// COLOR SCHEME GENERATOR
// ============================================================

class AppColorScheme {
  /// Light color scheme
  static ColorScheme light() => ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.accentDark,
        onSecondaryContainer: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.errorDark,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.backgroundLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.dividerLight,
      );

  /// Dark color scheme
  static ColorScheme dark() => ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.primaryDark,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.accent,
        onSecondary: AppColors.accentDark,
        secondaryContainer: AppColors.accentDark,
        onSecondaryContainer: AppColors.accent,
        error: AppColors.errorLight,
        onError: AppColors.errorDark,
        errorContainer: AppColors.errorDark,
        onErrorContainer: AppColors.errorLight,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.backgroundDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.dividerDark,
      );
}

// ============================================================
// GRADIENT DEFINITIONS
// ============================================================

class AppGradients {
  AppGradients._();

  /// Primary gradient
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient
  static const LinearGradient accent = LinearGradient(
    colors: [AppColors.accent, AppColors.accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Shimmer gradient (for loading states)
  static const LinearGradient shimmer = LinearGradient(
    colors: [
      AppColors.shimmerBase,
      AppColors.shimmerHighlight,
      AppColors.shimmerBase,
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );

  /// Glass morphism effect
  static LinearGradient glassMorphism({double opacity = 0.1}) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha:opacity),
          Colors.white.withValues(alpha:opacity * 0.5),
        ],
      );
}

// ============================================================
// SHADOW DEFINITIONS
// ============================================================

class AppShadows {
  AppShadows._();

  /// Small shadow (cards)
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium shadow (elevated elements)
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// Large shadow (modals, dialogs)
  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  /// Extra large shadow (floating action buttons)
  static List<BoxShadow> extraLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.16),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  /// Primary colored shadow (for primary buttons)
  static List<BoxShadow> primaryColored = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha:0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
}

// ============================================================
// BORDER RADIUS DEFINITIONS
// ============================================================

class AppBorderRadius {
  AppBorderRadius._();

  /// Extra small radius (4px)
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));

  /// Small radius (8px)
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));

  /// Medium radius (12px) - most common
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));

  /// Large radius (16px)
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));

  /// Extra large radius (24px)
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));

  /// 2XL radius (32px)
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(32));

  /// Full circle
  static const BorderRadius full = BorderRadius.all(Radius.circular(9999));

  /// Modal/Bottom sheet radius
  static const BorderRadius modal = BorderRadius.vertical(
    top: Radius.circular(24),
  );
}

// ============================================================
// EXTENSION METHODS
// ============================================================

extension ColorExtension on Color {
  /// Lighten a color by a percentage
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Darken a color by a percentage
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}