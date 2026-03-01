import 'package:common_utils2/common_utils2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dropdown_controller.dart';
import 'dropdown_item.dart';
import 'dropdown_config.dart';
import 'dropdown_overlay.dart';

/// A highly customisable, searchable, modular dropdown for Flutter.
///
/// Part of the **CommonDesigns** package.
///
/// ## Basic usage
/// ```dart
/// CommonDropdown<String>(
///   label: 'Fruit',
///   hint: 'Pick one',
///   items: ['Apple', 'Banana', 'Cherry']
///       .map((e) => DropdownItem(value: e, label: e))
///       .toList(),
///   onChanged: (v) => setState(() => _fruit = v),
/// )
/// ```
///
/// ## Country picker
/// ```dart
/// CommonDropdown.countries(
///   label: 'Country',
///   value: _country,
///   onChanged: (c) => setState(() => _country = c),
/// )
/// ```
///
/// ## Dial code
/// ```dart
/// CommonDropdown.dialCode(
///   value: _dial,
///   onChanged: (c) => setState(() => _dial = c),
/// )
/// ```
class CommonDropdown<T> extends StatefulWidget {
  // ── Data ───────────────────────────────────────────────────────────────────

  /// Items to display. Ignored when [groups] is set.
  final List<DropdownItem<T>> items;

  /// Grouped items — takes precedence over [items] when set.
  final List<DropdownItemGroup<T>>? groups;

  // ── Callbacks ──────────────────────────────────────────────────────────────

  /// Called when the selected value changes (single-select mode).
  final ValueChanged<T?>? onChanged;

  /// Called when the selection list changes (multi-select mode).
  final ValueChanged<List<T>>? onMultiChanged;

  // ── Initial values ─────────────────────────────────────────────────────────

  /// Pre-selected value (single-select).
  final T? value;

  /// Pre-selected values (multi-select).
  final List<T>? values;

  // ── Labels & decoration ────────────────────────────────────────────────────

  /// Placeholder shown when nothing is selected.
  final String hint;

  /// Label rendered above the trigger.
  final String? label;

  /// Helper text rendered below the trigger.
  final String? helperText;

  /// Error message rendered below the trigger — also activates the error style.
  final String? errorText;

  /// Widget rendered at the left inside the trigger (icon, etc.).
  final Widget? prefixIcon;

  // ── Behaviour ──────────────────────────────────────────────────────────────

  /// Whether the field is interactive. Defaults to true.
  final bool enabled;

  /// Whether multiple values can be selected simultaneously.
  final bool multiSelect;

  // ── Search ─────────────────────────────────────────────────────────────────

  /// Whether the overlay has a search input. Defaults to true.
  final bool searchable;

  /// Placeholder inside the search input.
  final String searchHint;

  /// Custom filter — receives every item and the current query string.
  /// Defaults to matching [DropdownItem.label], [DropdownItem.subtitle], and
  /// [DropdownItem.searchTerms].
  final bool Function(DropdownItem<T> item, String query)? searchFilter;

  /// Async search callback — triggered on every keystroke (debounced 300 ms).
  /// When provided, [items] serves as the initial list only.
  final Future<List<DropdownItem<T>>> Function(String query)? onSearch;

  // ── Custom builders ────────────────────────────────────────────────────────

  /// Fully replaces the default item row. Receives the item and its selected
  /// state. Wrap with [InkWell] yourself if you need tap handling inside.
  final Widget Function(
          BuildContext context, DropdownItem<T> item, bool isSelected)?
      itemBuilder;

  /// Replaces what is shown inside the trigger when a value is selected.
  final Widget Function(BuildContext context, T value)? selectedBuilder;

  // ── Visual config ──────────────────────────────────────────────────────────

  /// Visual configuration. Defaults to [CommonDropdownConfig.defaults].
  final CommonDropdownConfig config;

  /// Maximum height of the dropdown overlay panel.
  final double overlayMaxHeight;

  /// Whether to show a ✕ button to clear the selection.
  final bool clearable;

  // ── Controller ─────────────────────────────────────────────────────────────

  /// Optional controller for programmatic open / close / clear.
  final CommonDropdownController<T>? controller;

  // ── Constructor ────────────────────────────────────────────────────────────

  const CommonDropdown({
    super.key,
    required this.items,
    this.groups,
    this.onChanged,
    this.onMultiChanged,
    this.value,
    this.values,
    this.hint = 'Select an option',
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.multiSelect = false,
    this.searchable = true,
    this.searchHint = 'Search...',
    this.searchFilter,
    this.onSearch,
    this.itemBuilder,
    this.selectedBuilder,
    this.config = const CommonDropdownConfig(),
    this.overlayMaxHeight = 320,
    this.clearable = true,
    this.controller,
  });

  // ── Convenience constructors ───────────────────────────────────────────────

  /// Country picker — shows flag + name + dial code.
  ///
  /// Search matches country name, ISO code, and dial code.
  static CommonDropdown<Country> countries({
    Key? key,
    ValueChanged<Country?>? onChanged,
    Country? value,
    String hint = 'Select country',
    String? label,
    String? helperText,
    String? errorText,
    bool enabled = true,
    bool clearable = true,
    CommonDropdownConfig config = const CommonDropdownConfig(),
    CommonDropdownController<Country>? controller,
    double overlayMaxHeight = 320,
  }) {
    return CommonDropdown<Country>(
      key: key,
      items: CountryData.all
          .map(
            (c) => DropdownItem<Country>(
              value: c,
              label: c.name,
              subtitle: c.dialCode,
              leading: Text(c.flag, style: const TextStyle(fontSize: 20)),
              searchTerms: [c.name, c.code, c.dialCode],
            ),
          )
          .toList(),
      onChanged: onChanged,
      value: value,
      hint: hint,
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      clearable: clearable,
      searchable: true,
      searchHint: 'Search countries...',
      config: config,
      controller: controller,
      overlayMaxHeight: overlayMaxHeight,
      selectedBuilder: (context, country) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(country.flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              country.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            country.dialCode,
            style: TextStyle(
              fontSize: 12,
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }

  /// Compact dial-code picker — shows flag emoji + "+234" in the trigger.
  ///
  /// Designed to sit alongside a phone-number text field.
  static CommonDropdown<Country> dialCode({
    Key? key,
    ValueChanged<Country?>? onChanged,
    Country? value,
    bool clearable = false,
    CommonDropdownConfig config = const CommonDropdownConfig(),
    double overlayMaxHeight = 320,
  }) {
    return CommonDropdown<Country>(
      key: key,
      items: CountryData.all
          .map(
            (c) => DropdownItem<Country>(
              value: c,
              label: '${c.flag}  ${c.dialCode}',
              subtitle: c.name,
              searchTerms: [c.name, c.code, c.dialCode],
            ),
          )
          .toList(),
      onChanged: onChanged,
      value: value,
      hint: '🌍  +000',
      clearable: clearable,
      searchable: true,
      searchHint: 'Search dial code...',
      config: config,
      overlayMaxHeight: overlayMaxHeight,
      selectedBuilder: (context, country) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(country.flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            country.dialCode,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<CommonDropdown<T>> createState() => _CommonDropdownState<T>();
}

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class _CommonDropdownState<T> extends State<CommonDropdown<T>>
    with SingleTickerProviderStateMixin {
  // ── Animation (chevron rotation) ───────────────────────────────────────────
  late final AnimationController _chevronAnim;
  late final Animation<double> _chevronTurns;

  // ── Overlay ────────────────────────────────────────────────────────────────
  OverlayEntry? _overlayEntry;

  /// [CompositedTransformTarget] / [CompositedTransformFollower] link.
  final _layerLink = LayerLink();

  // ── Selection ──────────────────────────────────────────────────────────────
  T? _selectedValue;
  final List<T> _selectedValues = [];

  // ── UI state ───────────────────────────────────────────────────────────────
  bool _isOpen = false;
  bool _isFocused = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.value;
    if (widget.values != null) _selectedValues.addAll(widget.values!);

    _chevronAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _chevronTurns = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _chevronAnim, curve: Curves.easeOutCubic),
    );

    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(CommonDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync external value changes.
    if (widget.value != oldWidget.value && !widget.multiSelect) {
      setState(() => _selectedValue = widget.value);
    }
    // Re-attach controller listener if it changed.
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _chevronAnim.dispose();
    _removeOverlay();
    super.dispose();
  }

  // ── Controller listener ────────────────────────────────────────────────────

  void _onControllerChanged() {
    switch (widget.controller?.lastAction) {
      case DropdownControllerAction.open:
        _open();
      case DropdownControllerAction.close:
        _close();
      case DropdownControllerAction.clear:
        _clear();
      case DropdownControllerAction.none:
      case null:
        break;
    }
  }

  // ── Open / close ───────────────────────────────────────────────────────────

  void _open() {
    if (!widget.enabled || _isOpen) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isOpen = true;
      _isFocused = true;
    });
    _chevronAnim.forward();
    _showOverlay();
  }

  void _close() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
      _isFocused = false;
    });
    _chevronAnim.reverse();
    _removeOverlay();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _clear() {
    setState(() {
      _selectedValue = null;
      _selectedValues.clear();
    });
    widget.onChanged?.call(null);
    widget.onMultiChanged?.call([]);
    _close();
  }

  // ── Item selection ─────────────────────────────────────────────────────────

  void _onItemSelected(T value) {
    HapticFeedback.selectionClick();
    if (widget.multiSelect) {
      setState(() {
        if (_selectedValues.contains(value)) {
          _selectedValues.remove(value);
        } else {
          _selectedValues.add(value);
        }
      });
      widget.onMultiChanged?.call(List<T>.unmodifiable(_selectedValues));
      // Rebuild the overlay in-place so checkboxes update without re-opening.
      _overlayEntry?.markNeedsBuild();
    } else {
      setState(() => _selectedValue = value);
      widget.onChanged?.call(value);
      _close();
    }
  }

  bool _isSelected(T value) {
    if (widget.multiSelect) return _selectedValues.contains(value);
    return _selectedValue == value;
  }

  // ── Overlay ────────────────────────────────────────────────────────────────

  void _showOverlay() {
    // Read the render box size after layout.
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    _overlayEntry = OverlayEntry(
      builder: (_) => CommonDropdownOverlay<T>(
        layerLink: _layerLink,
        triggerWidth: size.width,
        triggerHeight: size.height,
        items: widget.items,
        groups: widget.groups,
        searchable: widget.searchable,
        searchHint: widget.searchHint,
        searchFilter: widget.searchFilter,
        onSearch: widget.onSearch,
        itemBuilder: widget.itemBuilder,
        isSelected: _isSelected,
        onItemSelected: _onItemSelected,
        onClose: _close,
        config: widget.config,
        maxHeight: widget.overlayMaxHeight,
        multiSelect: widget.multiSelect,
        selectedValues: _selectedValues,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get _hasValue =>
      widget.multiSelect ? _selectedValues.isNotEmpty : _selectedValue != null;

  List<DropdownItem<T>> get _allItems => widget.groups != null
      ? widget.groups!.expand((g) => g.items).toList()
      : widget.items;

  // ── Selected display builder ───────────────────────────────────────────────

  Widget _buildSelectedDisplay() {
    final cfg = widget.config;

    // Multi-select: show chip row.
    if (widget.multiSelect && _selectedValues.isNotEmpty) {
      return _MultiChipDisplay<T>(
        values: _selectedValues,
        items: _allItems,
        config: cfg,
        onRemove: (v) {
          setState(() => _selectedValues.remove(v));
          widget.onMultiChanged?.call(List<T>.unmodifiable(_selectedValues));
          _overlayEntry?.markNeedsBuild();
        },
      );
    }

    // Single-select with value.
    if (_selectedValue != null) {
      if (widget.selectedBuilder != null) {
        return widget.selectedBuilder!(context, _selectedValue as T);
      }
      final item =
          _allItems.where((i) => i.value == _selectedValue).firstOrNull;
      return Row(
        children: [
          if (item?.leading != null) ...[
            item!.leading!,
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              item?.label ?? _selectedValue.toString(),
              overflow: TextOverflow.ellipsis,
              style: cfg.selectedTextStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cfg.resolveTextColor(context),
                  ),
            ),
          ),
        ],
      );
    }

    // Hint.
    return Text(
      widget.hint,
      overflow: TextOverflow.ellipsis,
      style: cfg.hintTextStyle ??
          TextStyle(
            fontSize: 14,
            color: cfg.resolveTextColor(context).withOpacity(0.45),
          ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? cfg.errorColor ?? Theme.of(context).colorScheme.error
        : _isFocused
            ? cfg.focusedBorderColor ?? Theme.of(context).colorScheme.primary
            : cfg.borderColor ??
                Theme.of(context).colorScheme.outline.withOpacity(0.5);

    final bgColor =
        cfg.backgroundColor ?? Theme.of(context).colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ────────────────────────────────────────────────────────────
        if (widget.label != null) ...[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              fontSize: _isFocused || _hasValue ? 12 : 13,
              fontWeight: FontWeight.w500,
              color: hasError
                  ? cfg.errorColor ?? Theme.of(context).colorScheme.error
                  : _isFocused
                      ? cfg.focusedBorderColor ??
                          Theme.of(context).colorScheme.primary
                      : cfg
                          .resolveTextColor(context)
                          .withOpacity(0.65),
            ),
            child: Text(widget.label!),
          ),
          const SizedBox(height: 6),
        ],

        // ── Trigger ──────────────────────────────────────────────────────────
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.enabled ? _toggle : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: cfg.triggerHeight ?? 52,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? bgColor
                    : bgColor.withOpacity(0.6),
                borderRadius:
                    BorderRadius.circular(cfg.borderRadius ?? 12),
                border: Border.all(
                  color: borderColor,
                  width: _isFocused ? 1.5 : 1.0,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: borderColor.withOpacity(0.14),
                          blurRadius: 0,
                          spreadRadius: 3,
                        ),
                      ]
                    : cfg.boxShadow,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: cfg.horizontalPadding ?? 14),
              child: Row(
                children: [
                  // Prefix icon
                  if (widget.prefixIcon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: 18,
                        color: cfg
                            .resolveTextColor(context)
                            .withOpacity(0.5),
                      ),
                      child: widget.prefixIcon!,
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Selected value / hint
                  Expanded(child: _buildSelectedDisplay()),

                  // Clear button
                  if (_hasValue && widget.clearable && widget.enabled) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      // Stop tap from propagating to the trigger.
                      onTap: _clear,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: cfg
                              .resolveTextColor(context)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: cfg
                              .resolveTextColor(context)
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],

                  // Chevron
                  const SizedBox(width: 4),
                  RotationTransition(
                    turns: _chevronTurns,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: cfg.resolveTextColor(context).withOpacity(
                            widget.enabled ? 0.5 : 0.25,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Helper / error text ───────────────────────────────────────────────
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 5),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Row(
              key: ValueKey(widget.errorText ?? widget.helperText),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.errorText != null) ...[
                  Icon(
                    Icons.error_outline_rounded,
                    size: 12,
                    color: cfg.errorColor ??
                        Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    widget.errorText ?? widget.helperText!,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: widget.errorText != null
                          ? cfg.errorColor ??
                              Theme.of(context).colorScheme.error
                          : cfg
                              .resolveTextColor(context)
                              .withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Multi-select chip display
// ─────────────────────────────────────────────────────────────────────────────

class _MultiChipDisplay<T> extends StatelessWidget {
  final List<T> values;
  final List<DropdownItem<T>> items;
  final CommonDropdownConfig config;
  final ValueChanged<T> onRemove;

  const _MultiChipDisplay({
    required this.values,
    required this.items,
    required this.config,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const maxVisible = 2;
    final visible = values.take(maxVisible).toList();
    final overflowCount = values.length - maxVisible;

    final chipColor = config.focusedBorderColor ??
        Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...visible.map((v) {
            final item = items.where((i) => i.value == v).firstOrNull;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: chipColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: chipColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item?.label ?? v.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: chipColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => onRemove(v),
                      child: Icon(Icons.close, size: 10, color: chipColor),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (overflowCount > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: config.resolveTextColor(context).withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '+$overflowCount',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      config.resolveTextColor(context).withOpacity(0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}