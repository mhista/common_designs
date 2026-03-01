import 'package:flutter/material.dart';

// Animation configuration model
class ContainerAnimation {
  final Duration duration;
  final Curve curve;
  final bool enabled;

  const ContainerAnimation({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
    this.enabled = true,
  });

  static const none = ContainerAnimation(enabled: false);
  static const fast = ContainerAnimation(duration: Duration(milliseconds: 200));
  static const slow = ContainerAnimation(duration: Duration(milliseconds: 500));
  static const bouncy = ContainerAnimation(curve: Curves.elasticOut, duration: Duration(milliseconds: 600));
}

// Hover animation configuration
class HoverAnimation {
  final double scaleOnHover;
  final double elevationOnHover;
  final Color? colorOnHover;
  final bool enabled;

  const HoverAnimation({
    this.scaleOnHover = 1.02,
    this.elevationOnHover = 8,
    this.colorOnHover,
    this.enabled = true,
  });

  static const none = HoverAnimation(enabled: false);
  static const subtle = HoverAnimation(scaleOnHover: 1.01, elevationOnHover: 4);
  static const strong = HoverAnimation(scaleOnHover: 1.05, elevationOnHover: 12);
}

// Main animated container widget
class TAnimatedRoundedContainer extends StatefulWidget {
  const TAnimatedRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = 16,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE5E7EB),
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.showBorder = false,
    this.showShadow = false,
    this.onTap,
    this.gradient,
    this.animation = const ContainerAnimation(),
    this.hoverAnimation = const HoverAnimation(),
    this.pulseOnTap = false,
    this.rotateOnHover = false,
    this.shakeOnError = false,
  });

  final double? width, height;
  final double radius;
  final Color? backgroundColor, borderColor;
  final Widget? child;
  final EdgeInsetsGeometry? margin, padding;
  final bool showBorder, showShadow;
  final void Function()? onTap;
  final Gradient? gradient;
  final ContainerAnimation animation;
  final HoverAnimation hoverAnimation;
  final bool pulseOnTap;
  final bool rotateOnHover;
  final bool shakeOnError;

  @override
  State<TAnimatedRoundedContainer> createState() => _TAnimatedRoundedContainerState();
}

class _TAnimatedRoundedContainerState extends State<TAnimatedRoundedContainer>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isTapped = false;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shake animation controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.pulseOnTap) {
      _pulseController.forward().then((_) => _pulseController.reverse());
    }
    widget.onTap?.call();
  }

  void triggerShake() {
    if (widget.shakeOnError) {
      _shakeController.forward().then((_) => _shakeController.reset());
    }
  }

  double _calculateRotation() {
    if (!widget.rotateOnHover || !_isHovered) return 0;
    return 0.01; // Slight tilt (about 0.5 degrees)
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.hoverAnimation.enabled && _isHovered
        ? widget.hoverAnimation.scaleOnHover
        : 1.0;

    final elevation = widget.showShadow
        ? (widget.hoverAnimation.enabled && _isHovered
            ? widget.hoverAnimation.elevationOnHover
            : 4.0)
        : 0.0;

    final effectiveBackgroundColor = widget.hoverAnimation.enabled &&
            _isHovered &&
            widget.hoverAnimation.colorOnHover != null
        ? widget.hoverAnimation.colorOnHover!
        : widget.backgroundColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _shakeAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: widget.pulseOnTap ? _pulseAnimation.value * scale : scale,
              child: Transform.rotate(
                angle: _calculateRotation() + (_shakeAnimation.value * 0.05 * ((_shakeAnimation.value * 4).floor() % 2 == 0 ? 1 : -1)),
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: widget.animation.enabled
                ? widget.animation.duration
                : Duration.zero,
            curve: widget.animation.curve,
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(widget.radius),
              color: widget.gradient == null ? effectiveBackgroundColor : null,
              border: widget.showBorder
                  ? Border.all(
                      color: widget.borderColor ?? const Color(0xFFE5E7EB),
                    )
                  : null,
              boxShadow: _buildBoxShadows(elevation),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.radius),
                onTap: widget.onTap != null ? _handleTap : null,
                child: AnimatedPadding(
                  duration: widget.animation.enabled
                      ? widget.animation.duration
                      : Duration.zero,
                  curve: widget.animation.curve,
                  padding: widget.padding ?? EdgeInsets.zero,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _buildBoxShadows(double elevation) {
    if (!widget.showShadow && elevation == 0) return [];

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.1 * (elevation / 4)),
        spreadRadius: elevation / 4,
        blurRadius: elevation * 1.5,
        offset: Offset(0, elevation / 2),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha:0.15 * (elevation / 4)),
        spreadRadius: 0,
        blurRadius: elevation / 2,
        offset: Offset(0, elevation / 4),
      ),
    ];
  }
}

// Builder pattern for easy configuration
class AnimatedContainerBuilder {
  double? _width;
  double? _height;
  double _radius = 16;
  Color? _backgroundColor = Colors.white;
  Color? _borderColor = const Color(0xFFE5E7EB);
  Widget? _child;
  EdgeInsetsGeometry? _margin;
  EdgeInsetsGeometry? _padding = const EdgeInsets.all(16);
  bool _showBorder = false;
  bool _showShadow = false;
  VoidCallback? _onTap;
  Gradient? _gradient;
  ContainerAnimation _animation = const ContainerAnimation();
  HoverAnimation _hoverAnimation = const HoverAnimation();
  bool _pulseOnTap = false;
  bool _rotateOnHover = false;
  bool _shakeOnError = false;

  AnimatedContainerBuilder withSize({double? width, double? height}) {
    _width = width;
    _height = height;
    return this;
  }

  AnimatedContainerBuilder withRadius(double radius) {
    _radius = radius;
    return this;
  }

  AnimatedContainerBuilder withColors({Color? backgroundColor, Color? borderColor}) {
    _backgroundColor = backgroundColor;
    _borderColor = borderColor;
    return this;
  }

  AnimatedContainerBuilder withChild(Widget child) {
    _child = child;
    return this;
  }

  AnimatedContainerBuilder withSpacing({EdgeInsetsGeometry? margin, EdgeInsetsGeometry? padding}) {
    _margin = margin;
    _padding = padding;
    return this;
  }

  AnimatedContainerBuilder withBorder([bool show = true]) {
    _showBorder = show;
    return this;
  }

  AnimatedContainerBuilder withShadow([bool show = true]) {
    _showShadow = show;
    return this;
  }

  AnimatedContainerBuilder withOnTap(VoidCallback callback) {
    _onTap = callback;
    return this;
  }

  AnimatedContainerBuilder withGradient(Gradient gradient) {
    _gradient = gradient;
    return this;
  }

  AnimatedContainerBuilder withAnimation(ContainerAnimation animation) {
    _animation = animation;
    return this;
  }

  AnimatedContainerBuilder withHoverAnimation(HoverAnimation hoverAnimation) {
    _hoverAnimation = hoverAnimation;
    return this;
  }

  AnimatedContainerBuilder withPulseOnTap([bool enable = true]) {
    _pulseOnTap = enable;
    return this;
  }

  AnimatedContainerBuilder withRotateOnHover([bool enable = true]) {
    _rotateOnHover = enable;
    return this;
  }

  AnimatedContainerBuilder withShakeOnError([bool enable = true]) {
    _shakeOnError = enable;
    return this;
  }

  TAnimatedRoundedContainer build() {
    return TAnimatedRoundedContainer(
      width: _width,
      height: _height,
      radius: _radius,
      backgroundColor: _backgroundColor,
      borderColor: _borderColor,
      margin: _margin,
      padding: _padding,
      showBorder: _showBorder,
      showShadow: _showShadow,
      onTap: _onTap,
      gradient: _gradient,
      animation: _animation,
      hoverAnimation: _hoverAnimation,
      pulseOnTap: _pulseOnTap,
      rotateOnHover: _rotateOnHover,
      shakeOnError: _shakeOnError,
      child: _child,
    );
  }
}

// Example usage
class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key});

  @override
  State<AnimatedContainerExample> createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool isExpanded = false;
  final GlobalKey<_TAnimatedRoundedContainerState> errorContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Basic hover animation
              TAnimatedRoundedContainer(
                showShadow: true,
                onTap: () => debugPrint('Tapped!'),
                child: const Text('Hover & Click Me!'),
              ),
              
              const SizedBox(height: 24),
              
              // Expandable container
              TAnimatedRoundedContainer(
                width: isExpanded ? 300 : 200,
                height: isExpanded ? 200 : 100,
                showShadow: true,
                backgroundColor: const Color(0xFF6B5FCD),
                onTap: () => setState(() => isExpanded = !isExpanded),
                animation: const ContainerAnimation(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                ),
                child: Center(
                  child: Text(
                    isExpanded ? 'Click to Shrink' : 'Click to Expand',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Pulse on tap
              TAnimatedRoundedContainer(
                showShadow: true,
                pulseOnTap: true,
                backgroundColor: const Color(0xFF4A90E2),
                onTap: () => debugPrint('Pulse!'),
                child: const Text(
                  'Pulse Animation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Rotate on hover
              TAnimatedRoundedContainer(
                showShadow: true,
                rotateOnHover: true,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                ),
                hoverAnimation: HoverAnimation.strong,
                child: const Text(
                  'Rotate on Hover',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Shake on error
              TAnimatedRoundedContainer(
                key: errorContainerKey,
                showShadow: true,
                showBorder: true,
                borderColor: Colors.red,
                shakeOnError: true,
                onTap: () => errorContainerKey.currentState?.triggerShake(),
                child: const Text('Click to Shake (Error)'),
              ),
              
              const SizedBox(height: 24),
              
              // Builder pattern example
              AnimatedContainerBuilder()
                .withSize(width: 250, height: 120)
                .withColors(backgroundColor: const Color(0xFF2ECC71))
                .withShadow()
                .withRadius(20)
                .withHoverAnimation(HoverAnimation.strong)
                .withPulseOnTap()
                .withOnTap(() => debugPrint('Builder pattern!'))
                .withChild(const Center(
                  child: Text(
                    'Builder Pattern\nAll Features!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ))
                .build(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedContainerExample(),
  ));
}