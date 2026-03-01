import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'animations_config.dart';

// ============================================================
// PRESSABLE WIDGET (Button Press Animation)
// ============================================================

/// Widget that scales down on press with haptic feedback
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double scaleAmount;
  final Duration duration;
  final bool enableHaptics;
  final bool enabled;

  const Pressable({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.scaleAmount = AnimationConfigs.pressScale,
    this.duration = AnimationConfigs.fast,
    this.enableHaptics = true,
    this.enabled = true,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationConfigs.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.enabled ? widget.onPressed : null,
      onLongPress: widget.enabled ? widget.onLongPress : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// ANIMATED ICON BUTTON
// ============================================================

/// Icon button with press and ripple animation
class AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24.0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color,
      tooltip: tooltip,
    );

    return Pressable(
      onPressed: onPressed,
      child: button,
    );
  }
}

// ============================================================
// LIKE BUTTON (Heart Animation)
// ============================================================

/// Heart animation button (like the one in your screenshots)
class LikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onTap;
  final Color? likedColor;
  final Color? unlikedColor;
  final double size;

  const LikeButton({
    super.key,
    required this.isLiked,
    this.onTap,
    this.likedColor,
    this.unlikedColor,
    this.size = 24.0,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfigs.medium,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked != oldWidget.isLiked && widget.isLiked) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.isLiked
              ? (widget.likedColor ?? Colors.red)
              : (widget.unlikedColor ?? Colors.grey),
          size: widget.size,
        ),
      ),
    );
  }
}

// ============================================================
// SHIMMER BUTTON (Loading State)
// ============================================================

/// Button with shimmer loading state
class ShimmerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ShimmerButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : child,
    );

    if (isLoading) {
      button = button.animate(
        onPlay: (controller) => controller.repeat(),
      ).shimmer(
        duration: const Duration(milliseconds: 1500),
        color: Colors.white.withValues(alpha:0.3),
      );
    }

    return button;
  }
}

// ============================================================
// BOUNCING WIDGET
// ============================================================

/// Widget that bounces when tapped
class BouncingWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final Duration duration;

  const BouncingWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.9,
    this.duration = AnimationConfigs.fast,
  });

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.scaleFactor),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.scaleFactor, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// SHAKE WIDGET (Error Animation)
// ============================================================

/// Widget that shakes (useful for form errors)
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;
  final Duration duration;
  final double offset;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shake = false,
    this.duration = AnimationConfigs.medium,
    this.offset = 10.0,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: widget.offset), weight: 1),
      TweenSequenceItem(tween: Tween(begin: widget.offset, end: -widget.offset), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -widget.offset, end: widget.offset), weight: 1),
      TweenSequenceItem(tween: Tween(begin: widget.offset, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ============================================================
// RIPPLE EFFECT
// ============================================================

/// Custom ripple effect widget
class RippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final BorderRadius? borderRadius;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: rippleColor?.withValues(alpha:0.3) ??
            Theme.of(context).primaryColor.withValues(alpha:0.3),
        highlightColor: rippleColor?.withValues(alpha:0.1) ??
            Theme.of(context).primaryColor.withValues(alpha:0.1),
        child: child,
      ),
    );
  }
}