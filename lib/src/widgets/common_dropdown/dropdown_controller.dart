import 'package:flutter/foundation.dart';

/// Programmatic controller for [CommonDropdown].
///
/// Attach via [CommonDropdown.controller] to open, close, or clear the
/// dropdown from code — useful for form validation flows, tutorial
/// walkthroughs, or custom trigger widgets.
///
/// ```dart
/// final _ctrl = CommonDropdownController<String>();
///
/// // In build:
/// CommonDropdown<String>(controller: _ctrl, ...)
///
/// // From a button or lifecycle method:
/// _ctrl.open();
/// _ctrl.close();
/// _ctrl.clear();
///
/// // Always dispose when the owner widget is destroyed:
/// @override
/// void dispose() { _ctrl.dispose(); super.dispose(); }
/// ```
class CommonDropdownController<T> extends ChangeNotifier {
  /// The last action that was dispatched. Read by [CommonDropdown] listeners.
  DropdownControllerAction _lastAction = DropdownControllerAction.none;

  DropdownControllerAction get lastAction => _lastAction;

  void _dispatch(DropdownControllerAction action) {
    _lastAction = action;
    notifyListeners();
    _lastAction = DropdownControllerAction.none;
  }

  /// Opens the dropdown overlay.
  void open() => _dispatch(DropdownControllerAction.open);

  /// Closes the dropdown overlay.
  void close() => _dispatch(DropdownControllerAction.close);

  /// Closes the overlay and clears the current selection.
  void clear() => _dispatch(DropdownControllerAction.clear);
}

/// Actions that [CommonDropdownController] can dispatch.
enum DropdownControllerAction { none, open, close, clear }