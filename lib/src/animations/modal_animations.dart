import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../common_designs.dart';

// ============================================================
// MODAL ANIMATIONS
// ============================================================

class AppModals {
  AppModals._();

  /// Show bottom sheet with margin (like in your screenshots)
  /// This creates a container that slides up with space at the bottom
  static Future<T?> showBottomSheetWithMargin<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool showHandle = true,
    double bottomMargin = 16.0,
    double horizontalMargin = 16.0,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: AnimationConfigs.medium,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: horizontalMargin,
                right: horizontalMargin,
                bottom: bottomMargin,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: borderRadius ?? AppBorderRadius.xl,
                    boxShadow: AppShadows.large,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle
                      if (showHandle) const _BottomSheetHandle(),

                      // Content
                      Flexible(
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Slide up animation
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: AnimationConfigs.modalSlideUp,
          ),
        );

        // Fade animation
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: AnimationConfigs.fade,
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Show draggable bottom sheet with margin
  static Future<T?> showDraggableBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool showHandle = true,
    double initialChildSize = 0.6,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    double bottomMargin = 16.0,
    double horizontalMargin = 16.0,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: horizontalMargin,
            right: horizontalMargin,
            bottom: bottomMargin,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: AppBorderRadius.xl,
                  boxShadow: AppShadows.large,
                ),
                child: Column(
                  children: [
                    // Handle
                    if (showHandle) const _BottomSheetHandle(),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Show alert dialog with scale animation
  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    String? title,
    String? content,
    List<Widget>? actions,
    Widget? customContent,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: AnimationConfigs.medium,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: customContent ?? (content != null ? Text(content) : null),
          actions: actions,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.lg,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: AnimationConfigs.scale,
          ),
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: AnimationConfigs.fade,
          ),
        );

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}

// ============================================================
// BOTTOM SHEET HANDLE
// ============================================================

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ============================================================
// CHAT SUGGESTION ANIMATIONS
// ============================================================

/// Chat-style suggestion chips that stagger in/out
class ChatSuggestions extends StatefulWidget {
  final List<String> suggestions;
  final bool show;
  final Function(String)? onSuggestionTapped;
  final Duration staggerDelay;
  final Duration animationDuration;

  const ChatSuggestions({
    super.key,
    required this.suggestions,
    this.show = true,
    this.onSuggestionTapped,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ChatSuggestions> createState() => _ChatSuggestionsState();
}

class _ChatSuggestionsState extends State<ChatSuggestions>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.show) {
      _animateIn();
    }
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.suggestions.length,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      ),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: AnimationConfigs.fade,
        ),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: AnimationConfigs.decelerate,
        ),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(ChatSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _animateIn();
      } else {
        _animateOut();
      }
    }

    // If suggestions changed, reinitialize
    if (widget.suggestions.length != oldWidget.suggestions.length) {
      _disposeControllers();
      _initializeAnimations();
      if (widget.show) {
        _animateIn();
      }
    }
  }

  void _animateIn() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  void _animateOut() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      Future.delayed(widget.staggerDelay * (_controllers.length - 1 - i), () {
        if (mounted) {
          _controllers[i].reverse();
        }
      });
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show && _controllers.every((c) => c.value == 0)) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        widget.suggestions.length,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: child,
              ),
            );
          },
          child: _SuggestionChip(
            label: widget.suggestions[index],
            onTap: () => widget.onSuggestionTapped?.call(
              widget.suggestions[index],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SuggestionChip({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.full,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppBorderRadius.full,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

// ============================================================                                                                            
// ANIMATED CHAT MESSAGE
// ============================================================

/// Single chat message with slide-in animation
class AnimatedChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;
  final int index;
  final Duration? delay;

  const AnimatedChatMessage({
    super.key,
    required this.message,
    required this.isUser,
    required this.index,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final itemDelay = (delay ?? AnimationConfigs.staggerDelay) * index;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      )
          .animate(delay: itemDelay)
          .fadeIn(duration: AnimationConfigs.medium)
          .slideX(
            begin: isUser ? 0.2 : -0.2,
            end: 0,
            duration: AnimationConfigs.medium,
            curve: AnimationConfigs.decelerate,
          ),
    );
  }
}


// ============================================================
// CUSTOM MODAL WIDGETS
// ============================================================

/// Pre-built modal with title and close button
class AppModalSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showCloseButton;

  const AppModalSheet({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: AppSpacing.horizontalLG,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (showCloseButton)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
        ),

        const Divider(),

        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: AppSpacing.allLG,
            child: child,
          ),
        ),

        // Actions
        if (actions != null) ...[
          const Divider(),
          Padding(
            padding: AppSpacing.allLG,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// USAGE EXAMPLES
// ============================================================

/// Example 1: Bottom sheet with margin
/// ```dart
/// AppModals.showBottomSheetWithMargin(
///   context: context,
///   child: AppModalSheet(
///     title: 'Filter Options',
///     child: FilterOptionsWidget(),
///   ),
/// );
/// ```
///
/// Example 2: Chat suggestions
/// ```dart
/// ChatSuggestions(
///   suggestions: ['Hello', 'How are you?', 'What\'s up?'],
///   show: isTextEmpty,
///   onSuggestionTapped: (suggestion) {
///     textController.text = suggestion;
///   },
/// );
/// ```
///
/// Example 3: Animated chat messages
/// ```dart
/// ListView.builder(
///   itemCount: messages.length,
///   itemBuilder: (context, index) {
///     return AnimatedChatMessage(
///       message: messages[index].text,
///       isUser: messages[index].isUser,
///       index: index,
///     );
///   },
/// );
/// ```