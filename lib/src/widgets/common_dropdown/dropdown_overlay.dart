import 'dart:async';
import 'package:flutter/material.dart';
import 'dropdown_item.dart';
import 'dropdown_config.dart';

/// The dropdown panel rendered in the [Overlay] above the widget tree.
///
/// Manages its own search state, debounced async loading, list filtering,
/// and open/close animation. Consumed exclusively by [CommonDropdown] —
/// not intended for direct use.
class CommonDropdownOverlay<T> extends StatefulWidget {
  final LayerLink layerLink;
  final double triggerWidth;
  final double triggerHeight;
  final List<DropdownItem<T>> items;
  final List<DropdownItemGroup<T>>? groups;
  final bool searchable;
  final String searchHint;
  final bool Function(DropdownItem<T> item, String query)? searchFilter;
  final Future<List<DropdownItem<T>>> Function(String query)? onSearch;
  final Widget Function(BuildContext ctx, DropdownItem<T> item, bool isSelected)? itemBuilder;
  final bool Function(T value) isSelected;
  final ValueChanged<T> onItemSelected;
  final VoidCallback onClose;
  final CommonDropdownConfig config;
  final double maxHeight;
  final bool multiSelect;
  final List<T> selectedValues;

  const CommonDropdownOverlay({
    super.key,
    required this.layerLink,
    required this.triggerWidth,
    required this.triggerHeight,
    required this.items,
    this.groups,
    required this.searchable,
    required this.searchHint,
    this.searchFilter,
    this.onSearch,
    this.itemBuilder,
    required this.isSelected,
    required this.onItemSelected,
    required this.onClose,
    required this.config,
    required this.maxHeight,
    required this.multiSelect,
    required this.selectedValues,
  });

  @override
  State<CommonDropdownOverlay<T>> createState() =>
      _CommonDropdownOverlayState<T>();
}

class _CommonDropdownOverlayState<T>
    extends State<CommonDropdownOverlay<T>>
    with SingleTickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  // ── Search ─────────────────────────────────────────────────────────────────
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';
  bool _loading = false;
  List<DropdownItem<T>>? _asyncResults;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 190),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

    _anim.forward();

    if (widget.searchable) {
      // Delay focus so the overlay paint settles first.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocus.requestFocus();
      });
    }

    _searchController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    final q = _searchController.text;
    if (q == _query) return;
    setState(() => _query = q);

    if (widget.onSearch != null) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), _runAsyncSearch);
    }
  }

  Future<void> _runAsyncSearch() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final results = await widget.onSearch!(_query);
      if (mounted) setState(() { _asyncResults = results; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Filtering ──────────────────────────────────────────────────────────────

  List<DropdownItem<T>> get _filteredItems {
    // When async search is wired, show its results (or original list if empty query).
    if (widget.onSearch != null) {
      return _query.isEmpty ? widget.items : (_asyncResults ?? widget.items);
    }
    if (_query.isEmpty) return widget.items;
    return widget.items.where((item) {
      return widget.searchFilter != null
          ? widget.searchFilter!(item, _query)
          : item.matchesQuery(_query);
    }).toList();
  }

  List<DropdownItemGroup<T>> get _filteredGroups {
    if (widget.groups == null) return [];
    if (_query.isEmpty) return widget.groups!;
    return widget.groups!
        .map((g) {
          final filtered = g.items.where((item) {
            return widget.searchFilter != null
                ? widget.searchFilter!(item, _query)
                : item.matchesQuery(_query);
          }).toList();
          return DropdownItemGroup<T>(
            label: g.label,
            header: g.header,
            items: filtered,
          );
        })
        .where((g) => g.items.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _anim.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final overlayBg =
        cfg.overlayColor ?? Theme.of(context).colorScheme.surface;
    final panelRadius = cfg.overlayBorderRadius ?? cfg.borderRadius ?? 12.0;
    final vOffset = cfg.overlayVerticalOffset ?? 6.0;

    return Stack(
      children: [
        // ── Dismiss barrier ──────────────────────────────────────────────────
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onClose,
            child: const SizedBox.expand(),
          ),
        ),

        // ── Positioned panel ─────────────────────────────────────────────────
        CompositedTransformFollower(
          link: widget.layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, widget.triggerHeight + vOffset),
          child: Align(
            alignment: Alignment.topLeft,
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: widget.triggerWidth,
                    constraints: BoxConstraints(maxHeight: widget.maxHeight),
                    decoration: BoxDecoration(
                      color: overlayBg,
                      borderRadius: BorderRadius.circular(panelRadius),
                      border: Border.all(
                        color: cfg.overlayBorderColor ??
                            Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: (cfg.overlayElevation ?? 8) * 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(panelRadius),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.searchable) _buildSearchField(context),
                          Flexible(child: _buildList(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Search field ───────────────────────────────────────────────────────────

  Widget _buildSearchField(BuildContext context) {
    final cfg = widget.config;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: cfg.searchTextStyle ??
            TextStyle(
              fontSize: 13.5,
              color: Theme.of(context).colorScheme.onSurface,
            ),
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: TextStyle(
            fontSize: 13.5,
            color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              Icons.search_rounded,
              size: 17,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.35),
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 36, minHeight: 36),
          // Clear search button — only shown when there is text.
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () => _searchController.clear(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 15,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.35),
                  ),
                )
              : null,
          filled: true,
          fillColor: cfg.searchBackgroundColor ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(cfg.searchBorderRadius ?? 8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(cfg.searchBorderRadius ?? 8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(cfg.searchBorderRadius ?? 8),
            borderSide: BorderSide(
              color: cfg.searchBorderColor ??
                  (cfg.focusedBorderColor ??
                          Theme.of(context).colorScheme.primary)
                      .withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  // ── Item list ──────────────────────────────────────────────────────────────

  Widget _buildList(BuildContext context) {
    if (_loading) {
      return widget.config.loadingWidget ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
    }

    // ── Grouped ──────────────────────────────────────────────────────────────
    if (widget.groups != null) {
      final groups = _filteredGroups;
      if (groups.isEmpty) return _buildEmpty(context);

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        shrinkWrap: true,
        itemCount: groups.length,
        itemBuilder: (ctx, gi) {
          final group = groups[gi];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.header != null)
                group.header!
              else if (group.label != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 3),
                  child: Text(
                    group.label!.toUpperCase(),
                    style: widget.config.groupLabelStyle ??
                        TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                  ),
                ),
              ...group.items.map((item) => _buildItemRow(context, item)),
              if (gi < groups.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withOpacity(0.08),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        },
      );
    }

    // ── Flat list ─────────────────────────────────────────────────────────────
    final items = _filteredItems;
    if (items.isEmpty) return _buildEmpty(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 6),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (ctx, i) => _buildItemRow(ctx, items[i]),
    );
  }

  // ── Individual row ─────────────────────────────────────────────────────────

  Widget _buildItemRow(BuildContext context, DropdownItem<T> item) {
    final selected = widget.isSelected(item.value);
    final cfg = widget.config;

    // Delegate to custom builder when provided.
    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: item.enabled ? () => widget.onItemSelected(item.value) : null,
        child: widget.itemBuilder!(context, item, selected),
      );
    }

    final selBg = cfg.selectedItemColor ??
        Theme.of(context).colorScheme.primary.withOpacity(0.08);
    final selFg =
        cfg.selectedItemForeground ?? Theme.of(context).colorScheme.primary;
    final normalFg = cfg.resolveTextColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.enabled ? () => widget.onItemSelected(item.value) : null,
        splashColor: selBg,
        highlightColor: cfg.itemHoverColor ??
            Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          // Use auto height when subtitle is present; otherwise fixed height.
          height: item.subtitle != null ? null : (cfg.itemHeight ?? 48),
          padding: EdgeInsets.symmetric(
            horizontal: cfg.horizontalPadding ?? 14,
            vertical: item.subtitle != null ? 10 : 0,
          ),
          color: selected ? selBg : Colors.transparent,
          child: Row(
            children: [
              // Leading widget
              if (item.leading != null) ...[
                SizedBox(width: 28, child: item.leading),
                const SizedBox(width: 10),
              ],

              // Label + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: (cfg.itemTextStyle ?? const TextStyle()).copyWith(
                        fontSize:
                            cfg.itemTextStyle?.fontSize ?? 13.5,
                        fontWeight: selected
                            ? FontWeight.w600
                            : (cfg.itemTextStyle?.fontWeight ??
                                FontWeight.w400),
                        color: selected ? selFg : normalFg,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        item.subtitle!,
                        style: cfg.itemSubtitleStyle ??
                            TextStyle(
                              fontSize: 11.5,
                              color: selected
                                  ? selFg.withOpacity(0.6)
                                  : normalFg.withOpacity(0.45),
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget
              if (item.trailing != null) ...[
                const SizedBox(width: 8),
                item.trailing!,
              ],

              // Checkmark / multi-select checkbox
              if (cfg.showCheckmark) ...[
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: widget.multiSelect
                      ? _Checkbox(
                          key: ValueKey(selected),
                          checked: selected,
                          color: selFg,
                          borderColor: normalFg.withOpacity(0.25),
                        )
                      : SizedBox(
                          key: ValueKey(selected),
                          width: 16,
                          child: selected
                              ? Icon(Icons.check_rounded,
                                  size: 16, color: selFg)
                              : null,
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmpty(BuildContext context) {
    return widget.config.emptyWidget ??
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 26,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
              const SizedBox(height: 8),
              Text(
                _query.isEmpty
                    ? 'No options available'
                    : 'No results for "$_query"',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.35),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tiny checkbox widget used for multi-select rows
// ─────────────────────────────────────────────────────────────────────────────

class _Checkbox extends StatelessWidget {
  final bool checked;
  final Color color;
  final Color borderColor;

  const _Checkbox({
    super.key,
    required this.checked,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: checked ? color : borderColor,
          width: 1.5,
        ),
        color: checked ? color : Colors.transparent,
      ),
      child: checked
          ? const Icon(Icons.check, size: 12, color: Colors.white)
          : null,
    );
  }
}