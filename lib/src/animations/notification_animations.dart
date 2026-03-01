import 'package:flutter/material.dart';

import '../../common_designs.dart';

// ============================================================
// TOAST NOTIFICATIONS
// ============================================================

enum ToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  /// Show a toast notification at the top of the screen
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        onDismiss: () => overlayEntry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// Show success toast
  static void success(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.success);
  }

  /// Show error toast
  static void error(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.error);
  }

  /// Show warning toast
  static void warning(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.warning);
  }

  /// Show info toast
  static void info(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.info);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback onDismiss;
  final Duration duration;

  const _ToastWidget({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onActionPressed,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfigs.medium,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AnimationConfigs.decelerate,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AnimationConfigs.fade),
    );

    _controller.forward();

    // Start exit animation before dismiss
    Future.delayed(widget.duration - AnimationConfigs.medium, () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.error;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.info;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: AppBorderRadius.md,
                boxShadow: AppShadows.large,
              ),
              child: Row(
                children: [
                  Icon(_getIcon(), color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null) ...[
                    TextButton(
                      onPressed: () {
                        widget.onActionPressed?.call();
                        widget.onDismiss();
                      },
                      child: Text(
                        widget.actionLabel!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: widget.onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SNACKBAR (Bottom Notification)
// ============================================================

class AppSnackbar {
  AppSnackbar._();

  /// Show a snackbar at the bottom of the screen
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onActionPressed ?? () {},
              )
            : null,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
      ),
    );
  }
}

// ============================================================
// BADGE ANIMATION
// ============================================================

/// Animated badge (for notifications, cart count, etc.)
class AnimatedBadge extends StatefulWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;
  final Color? textColor;
  final bool show;

  const AnimatedBadge({
    super.key,
    required this.child,
    required this.count,
    this.badgeColor,
    this.textColor,
    this.show = true,
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfigs.fast,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != _previousCount) {
      _previousCount = widget.count;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show || widget.count == 0) {
      return widget.child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          right: -8,
          top: -8,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              decoration: BoxDecoration(
                color: widget.badgeColor ?? AppColors.badge,
                shape: BoxShape.circle,
                boxShadow: AppShadows.small,
              ),
              child: Center(
                child: Text(
                  widget.count > 99 ? '99+' : '${widget.count}',
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DOT INDICATOR (Unread, New Item, etc.)
// ============================================================

/// Pulsing dot indicator for new/unread items
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  final bool animate;

  const PulsingDot({
    super.key,
    this.color = Colors.red,
    this.size = 8,
    this.animate = true,
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size * _animation.value,
          height: widget.size * _animation.value,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// CONFETTI ANIMATION (Success celebrations)
// ============================================================

/// Confetti animation for success states
class ConfettiAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final int numberOfParticles;

  const ConfettiAnimation({
    super.key,
    required this.child,
    required this.trigger,
    this.numberOfParticles = 50,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      setState(() => _showConfetti = true);
      _controller.forward(from: 0).then((_) {
        setState(() => _showConfetti = false);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showConfetti)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      animation: _controller,
                      numberOfParticles: widget.numberOfParticles,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final int numberOfParticles;

  _ConfettiPainter({required this.animation, required this.numberOfParticles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < numberOfParticles; i++) {
      final progress = animation.value;
      final x = (i / numberOfParticles) * size.width;
      final y = size.height * (1 - progress) - (i % 3) * 20;

      paint.color = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
      ][i % 5].withValues(alpha: 1 - progress);

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

// ============================================================
// USAGE EXAMPLES
// ============================================================

/// Example: Toast notifications
/// ```dart
/// AppToast.success(context, 'Item added to cart!');
/// AppToast.error(context, 'Failed to save');
/// AppToast.warning(context, 'Low battery');
/// AppToast.info(context, 'New update available');
/// ```
///
/// Example: Badge
/// ```dart
/// AnimatedBadge(
///   count: unreadCount,
///   child: Icon(Icons.notifications),
/// );
/// ```
///
/// Example: Pulsing dot
/// ```dart
/// Stack(
///   children: [
///     Avatar(...),
///     Positioned(
///       right: 0,
///       top: 0,
///       child: PulsingDot(color: Colors.green),
///     ),
///   ],
/// );
/// ```
///
/// Example: Confetti
/// ```dart
/// ConfettiAnimation(
///   trigger: orderCompleted,
///   child: YourContent(),
/// );
/// ```
