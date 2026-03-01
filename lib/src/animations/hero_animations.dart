import '../../common_designs.dart';import 'package:flutter/material.dart';

// ============================================================
// HERO ANIMATIONS (Shared Element Transitions)
// ============================================================

/// Animated hero for images with proper fade transition
class AnimatedHero extends StatelessWidget {
  final String tag;
  final Widget child;
  final Duration? duration;

  const AnimatedHero({
    super.key,
    required this.tag,
    required this.child,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return FadeTransition(
          opacity: animation,
          child: toHeroContext.widget,
        );
      },
      child: child,
    );
  }
}

/// Hero image that scales and fades smoothly
class HeroImage extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const HeroImage({
    super.key,
    required this.tag,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATED ICON MORPHING
// ============================================================

/// Animated icon that morphs between two icons
class MorphingIcon extends StatefulWidget {
  final IconData startIcon;
  final IconData endIcon;
  final bool showEnd;
  final Color? color;
  final double size;
  final Duration duration;

  const MorphingIcon({
    super.key,
    required this.startIcon,
    required this.endIcon,
    required this.showEnd,
    this.color,
    this.size = 24,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<MorphingIcon> createState() => _MorphingIconState();
}

class _MorphingIconState extends State<MorphingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.showEnd) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MorphingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showEnd != oldWidget.showEnd) {
      if (widget.showEnd) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 1 - _controller.value,
              child: Transform.scale(
                scale: 1 - (_controller.value * 0.5),
                child: Icon(
                  widget.startIcon,
                  size: widget.size,
                  color: widget.color,
                ),
              ),
            ),
            Opacity(
              opacity: _controller.value,
              child: Transform.scale(
                scale: 0.5 + (_controller.value * 0.5),
                child: Icon(
                  widget.endIcon,
                  size: widget.size,
                  color: widget.color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// ANIMATED COUNTER
// ============================================================

/// Number counter that animates to a new value
class AnimatedCounter extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Curve curve;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimation(widget.value);
    _controller.forward();
  }

  void _setupAnimation(int newValue) {
    _animation = IntTween(
      begin: _previousValue,
      end: newValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation(widget.value);
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

// ============================================================
// ANIMATED PROGRESS INDICATOR
// ============================================================

/// Linear progress bar that animates to a value
class AnimatedProgressBar extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final Duration duration;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimation(widget.value);
    _controller.forward();
  }

  void _setupAnimation(double newValue) {
    _animation = Tween<double>(
      begin: _previousValue,
      end: newValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfigs.decelerate,
    ));
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation(widget.value);
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey.shade200,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color ?? Theme.of(context).primaryColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Circular progress indicator with percentage
class AnimatedCircularProgress extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final Duration duration;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;
  final bool showPercentage;
  final TextStyle? textStyle;

  const AnimatedCircularProgress({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.color,
    this.backgroundColor,
    this.size = 100,
    this.strokeWidth = 8,
    this.showPercentage = true,
    this.textStyle,
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimation(widget.value);
    _controller.forward();
  }

  void _setupAnimation(double newValue) {
    _animation = Tween<double>(
      begin: _previousValue,
      end: newValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfigs.decelerate,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation(widget.value);
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  color: widget.color ?? Theme.of(context).primaryColor,
                  backgroundColor: widget.backgroundColor ?? Colors.grey.shade200,
                ),
              ),
              if (widget.showPercentage)
                Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: widget.textStyle ??
                      TextStyle(
                        fontSize: widget.size * 0.2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// ANIMATED SIZE BOX
// ============================================================

/// Box that animates its size smoothly
class AnimatedSizeBox extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedSizeBox({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

// ============================================================
// USAGE EXAMPLES
// ============================================================

/// Example: Hero animation
/// ```dart
/// // On list screen
/// HeroImage(
///   tag: 'product-${product.id}',
///   imageUrl: product.imageUrl,
/// );
///
/// // On detail screen
/// HeroImage(
///   tag: 'product-${product.id}',
///   imageUrl: product.imageUrl,
///   height: 300,
/// );
/// ```
///
/// Example: Morphing icon (favorite/unfavorite)
/// ```dart
/// MorphingIcon(
///   startIcon: Icons.favorite_border,
///   endIcon: Icons.favorite,
///   showEnd: isFavorite,
///   color: Colors.red,
/// );
/// ```
///
/// Example: Animated counter (likes, views)
/// ```dart
/// AnimatedCounter(
///   value: likesCount,
///   suffix: ' likes',
///   style: TextStyle(fontSize: 16),
/// );
/// ```
///
/// Example: Progress indicators
/// ```dart
/// AnimatedProgressBar(
///   value: uploadProgress, // 0.0 to 1.0
///   color: Colors.blue,
/// );
///
/// AnimatedCircularProgress(
///   value: downloadProgress,
///   size: 120,
///   showPercentage: true,
/// );
/// ```