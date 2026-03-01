import 'package:flutter/material.dart';

/// Complete visual configuration for [CommonDropdown].
///
/// Every property is nullable — unset fields fall back gracefully to the
/// current [ThemeData], so the component works out-of-the-box with any
/// Material 3 theme and only needs values for things you want to override.
///
/// ## Quick start
/// ```dart
/// // Use a preset:
/// config: CommonDropdownConfig.rounded
///
/// // Customise one field on a preset:
/// config: CommonDropdownConfig.compact.copyWith(
///   focusedBorderColor: Colors.teal,
/// )
///
/// // Full custom:
/// config: const CommonDropdownConfig(
///   borderRadius: 14,
///   focusedBorderColor: Color(0xFF6C47FF),
///   selectedItemForeground: Color(0xFF6C47FF),
/// )
/// ```
@immutable
class CommonDropdownConfig {
  // ── Trigger ────────────────────────────────────────────────────────────────

  /// Background fill of the trigger field.
  final Color? backgroundColor;

  /// Border colour in the idle state.
  final Color? borderColor;

  /// Border colour when the overlay is open / field is focused.
  final Color? focusedBorderColor;

  /// Colour used for error borders, labels, and helper text.
  final Color? errorColor;

  /// Corner radius applied to both the trigger and the overlay panel.
  final double? borderRadius;

  /// Height of the trigger field. Defaults to 52.
  final double? triggerHeight;

  /// Horizontal padding inside the trigger. Defaults to 14.
  final double? horizontalPadding;

  /// Box shadow on the trigger (idle state).
  final List<BoxShadow>? boxShadow;

  // ── Text ───────────────────────────────────────────────────────────────────

  /// Style for the selected-value display inside the trigger.
  final TextStyle? selectedTextStyle;

  /// Style for the hint text when nothing is selected.
  final TextStyle? hintTextStyle;

  /// Style for item labels in the overlay list.
  final TextStyle? itemTextStyle;

  /// Style for item subtitle lines.
  final TextStyle? itemSubtitleStyle;

  /// Style for group-header labels.
  final TextStyle? groupLabelStyle;

  // ── Overlay ────────────────────────────────────────────────────────────────

  /// Background colour of the dropdown overlay panel.
  final Color? overlayColor;

  /// Shadow blur depth of the overlay panel (0 = no shadow).
  final double? overlayElevation;

  /// Corner radius of the overlay panel. Defaults to [borderRadius].
  final double? overlayBorderRadius;

  /// Gap between the bottom of the trigger and the top of the overlay.
  final double? overlayVerticalOffset;

  /// Border colour of the overlay panel.
  final Color? overlayBorderColor;

  // ── Items ──────────────────────────────────────────────────────────────────

  /// Row background colour for selected items.
  final Color? selectedItemColor;

  /// Text / icon colour for selected items.
  final Color? selectedItemForeground;

  /// Row background colour on hover / press.
  final Color? itemHoverColor;

  /// Fixed height for item rows (ignored when subtitle is present).
  final double? itemHeight;

  /// Whether to show a ✓ checkmark on selected items (default builder only).
  final bool showCheckmark;

  // ── Search field ───────────────────────────────────────────────────────────

  /// Fill colour of the search input.
  final Color? searchBackgroundColor;

  /// Border colour of the search input when focused.
  final Color? searchBorderColor;

  /// Text style inside the search input.
  final TextStyle? searchTextStyle;

  /// Corner radius of the search input. Defaults to 8.
  final double? searchBorderRadius;

  // ── States ─────────────────────────────────────────────────────────────────

  /// Widget shown when no items match the search query.
  final Widget? emptyWidget;

  /// Widget shown while an async [CommonDropdown.onSearch] is loading.
  final Widget? loadingWidget;

  const CommonDropdownConfig({
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorColor,
    this.borderRadius,
    this.triggerHeight,
    this.horizontalPadding,
    this.boxShadow,
    this.selectedTextStyle,
    this.hintTextStyle,
    this.itemTextStyle,
    this.itemSubtitleStyle,
    this.groupLabelStyle,
    this.overlayColor,
    this.overlayElevation,
    this.overlayBorderRadius,
    this.overlayVerticalOffset,
    this.overlayBorderColor,
    this.selectedItemColor,
    this.selectedItemForeground,
    this.itemHoverColor,
    this.itemHeight,
    this.showCheckmark = true,
    this.searchBackgroundColor,
    this.searchBorderColor,
    this.searchTextStyle,
    this.searchBorderRadius,
    this.emptyWidget,
    this.loadingWidget,
  });

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Resolves the primary foreground colour from the ambient [Theme].
  Color resolveTextColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  /// Returns a copy of this config with the given fields overridden.
  CommonDropdownConfig copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorColor,
    double? borderRadius,
    double? triggerHeight,
    double? horizontalPadding,
    List<BoxShadow>? boxShadow,
    TextStyle? selectedTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? itemTextStyle,
    TextStyle? itemSubtitleStyle,
    TextStyle? groupLabelStyle,
    Color? overlayColor,
    double? overlayElevation,
    double? overlayBorderRadius,
    double? overlayVerticalOffset,
    Color? overlayBorderColor,
    Color? selectedItemColor,
    Color? selectedItemForeground,
    Color? itemHoverColor,
    double? itemHeight,
    bool? showCheckmark,
    Color? searchBackgroundColor,
    Color? searchBorderColor,
    TextStyle? searchTextStyle,
    double? searchBorderRadius,
    Widget? emptyWidget,
    Widget? loadingWidget,
  }) {
    return CommonDropdownConfig(
      backgroundColor:        backgroundColor        ?? this.backgroundColor,
      borderColor:            borderColor            ?? this.borderColor,
      focusedBorderColor:     focusedBorderColor     ?? this.focusedBorderColor,
      errorColor:             errorColor             ?? this.errorColor,
      borderRadius:           borderRadius           ?? this.borderRadius,
      triggerHeight:          triggerHeight          ?? this.triggerHeight,
      horizontalPadding:      horizontalPadding      ?? this.horizontalPadding,
      boxShadow:              boxShadow              ?? this.boxShadow,
      selectedTextStyle:      selectedTextStyle      ?? this.selectedTextStyle,
      hintTextStyle:          hintTextStyle          ?? this.hintTextStyle,
      itemTextStyle:          itemTextStyle          ?? this.itemTextStyle,
      itemSubtitleStyle:      itemSubtitleStyle      ?? this.itemSubtitleStyle,
      groupLabelStyle:        groupLabelStyle        ?? this.groupLabelStyle,
      overlayColor:           overlayColor           ?? this.overlayColor,
      overlayElevation:       overlayElevation       ?? this.overlayElevation,
      overlayBorderRadius:    overlayBorderRadius    ?? this.overlayBorderRadius,
      overlayVerticalOffset:  overlayVerticalOffset  ?? this.overlayVerticalOffset,
      overlayBorderColor:     overlayBorderColor     ?? this.overlayBorderColor,
      selectedItemColor:      selectedItemColor      ?? this.selectedItemColor,
      selectedItemForeground: selectedItemForeground ?? this.selectedItemForeground,
      itemHoverColor:         itemHoverColor         ?? this.itemHoverColor,
      itemHeight:             itemHeight             ?? this.itemHeight,
      showCheckmark:          showCheckmark          ?? this.showCheckmark,
      searchBackgroundColor:  searchBackgroundColor  ?? this.searchBackgroundColor,
      searchBorderColor:      searchBorderColor      ?? this.searchBorderColor,
      searchTextStyle:        searchTextStyle        ?? this.searchTextStyle,
      searchBorderRadius:     searchBorderRadius     ?? this.searchBorderRadius,
      emptyWidget:            emptyWidget            ?? this.emptyWidget,
      loadingWidget:          loadingWidget          ?? this.loadingWidget,
    );
  }

  // ── Built-in presets ───────────────────────────────────────────────────────

  /// Neutral default — works on any background colour, 12 px radius.
  static const CommonDropdownConfig defaults = CommonDropdownConfig(
    borderRadius: 12,
    triggerHeight: 52,
    showCheckmark: true,
  );

  /// Tighter, no checkmark — for toolbars, filter bars, compact forms.
  static const CommonDropdownConfig compact = CommonDropdownConfig(
    borderRadius: 8,
    triggerHeight: 38,
    itemHeight: 40,
    horizontalPadding: 10,
    showCheckmark: false,
    overlayBorderRadius: 8,
    overlayElevation: 4,
  );

  /// Generous radius and height — card / modal style.
  static const CommonDropdownConfig rounded = CommonDropdownConfig(
    borderRadius: 16,
    triggerHeight: 56,
    showCheckmark: true,
    overlayBorderRadius: 16,
    overlayElevation: 8,
  );

  /// Flat with outline, no elevation — Material 3 outlined-field look.
  static const CommonDropdownConfig outlined = CommonDropdownConfig(
    borderRadius: 12,
    triggerHeight: 52,
    showCheckmark: true,
    overlayBorderRadius: 12,
    overlayElevation: 0,
    boxShadow: [],
  );
}