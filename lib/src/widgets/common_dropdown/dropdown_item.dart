import 'package:flutter/material.dart';

/// A single item in a [CommonDropdown].
///
/// [T] is the value type. [label] is used for display and default search.
/// Provide [searchTerms] for extra search matching beyond label/subtitle.
class DropdownItem<T> {
  /// The underlying value returned to [CommonDropdown.onChanged].
  final T value;

  /// Primary display text.
  final String label;

  /// Optional secondary line shown below [label].
  final String? subtitle;

  /// Optional leading widget — flag emoji, icon, avatar, etc.
  final Widget? leading;

  /// Optional trailing widget — badge, icon, price, etc.
  final Widget? trailing;

  /// Extra strings to match during search, beyond [label] and [subtitle].
  final List<String> searchTerms;

  /// When false, the item is shown but cannot be selected (header-like).
  final bool enabled;

  const DropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.trailing,
    this.searchTerms = const [],
    this.enabled = true,
  });

  /// Returns true when [query] matches any text on this item.
  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase().trim();
    if (label.toLowerCase().contains(q)) return true;
    if (subtitle?.toLowerCase().contains(q) == true) return true;
    return searchTerms.any((t) => t.toLowerCase().contains(q));
  }
}

/// A labelled group of [DropdownItem]s rendered with a section header.
class DropdownItemGroup<T> {
  /// Plain-text label — rendered as a small uppercase section header.
  final String? label;

  /// Fully custom header widget — overrides [label] when provided.
  final Widget? header;

  final List<DropdownItem<T>> items;

  const DropdownItemGroup({
    this.label,
    this.header,
    required this.items,
  });
}