import 'package:flutter/animation.dart';

/// Central animation configuration for the entire app.
/// Ensures consistency across all animations and transitions.
class AnimationConfigs {
  AnimationConfigs._();

  // ============================================================
  // DURATION CONSTANTS
  // ============================================================

  /// Ultra-fast animations (e.g., ripple effects)
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// Fast animations (e.g., button presses, icon changes)
  static const Duration fast = Duration(milliseconds: 200);

  /// Medium animations (default for most UI transitions)
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow animations (e.g., page transitions, complex animations)
  static const Duration slow = Duration(milliseconds: 400);

  /// Very slow animations (e.g., special effects, onboarding)
  static const Duration verySlow = Duration(milliseconds: 600);

  /// List item stagger delay
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Carousel auto-play interval
  static const Duration carouselInterval = Duration(seconds: 3);

  // ============================================================
  // ANIMATION CURVES
  // ============================================================

  /// Standard easing for most animations
  static const Curve defaultCurve = Curves.easeInOut;

  /// Emphasized easing for important UI changes
  static const Curve emphasized = Curves.easeInOutCubic;

  /// Deceleration curve (starts fast, ends slow)
  static const Curve decelerate = Curves.decelerate;

  /// Acceleration curve (starts slow, ends fast)
  static const Curve accelerate = Curves.easeIn;

  /// Spring curve for bouncy effects
  static const Curve spring = Curves.elasticOut;

  /// Overshoot curve for playful animations
  static const Curve overshoot = Curves.easeInOutBack;

  /// Linear curve (no easing)
  static const Curve linear = Curves.linear;

  // ============================================================
  // SPECIALIZED CURVES
  // ============================================================

  /// Custom curve for bottom sheet slide-up
  static const Curve modalSlideUp = Curves.easeOutQuart;

  /// Custom curve for page transitions
  static const Curve pageTransition = Curves.easeInOutCubicEmphasized;

  /// Curve for fade animations
  static const Curve fade = Curves.easeIn;

  /// Curve for scale animations
  static const Curve scale = Curves.easeOutBack;

  // ============================================================
  // SPRING PHYSICS
  // ============================================================

  /// Standard spring simulation
  static const SpringDescription standardSpring = SpringDescription(
    mass: 1.0,
    stiffness: 100.0,
    damping: 10.0,
  );

  /// Bouncy spring for playful interactions
  static const SpringDescription bouncySpring = SpringDescription(
    mass: 0.5,
    stiffness: 100.0,
    damping: 7.0,
  );

  /// Gentle spring for subtle effects
  static const SpringDescription gentleSpring = SpringDescription(
    mass: 1.0,
    stiffness: 100.0,
    damping: 15.0,
  );

  // ============================================================
  // ANIMATION VALUES
  // ============================================================

  /// Standard scale factor for press animations
  static const double pressScale = 0.95;

  /// Standard elevation for raised elements
  static const double standardElevation = 4.0;

  /// Hover elevation
  static const double hoverElevation = 8.0;

  /// Modal backdrop opacity
  static const double backdropOpacity = 0.5;

  /// Shimmer gradient width
  static const double shimmerGradientWidth = 0.5;

  /// List item slide distance
  static const double listSlideDistance = 20.0;

  // ============================================================
  // ACCESSIBILITY
  // ============================================================

  /// Check if animations should be reduced based on system settings
  static bool shouldReduceAnimations = false;

  /// Get duration with accessibility consideration
  static Duration getDuration(Duration duration) {
    return shouldReduceAnimations ? Duration.zero : duration;
  }

  /// Get curve with accessibility consideration
  static Curve getCurve(Curve curve) {
    return shouldReduceAnimations ? Curves.linear : curve;
  }
}

/// Extension to easily apply animation configs to animation controllers
extension AnimationConfigExtension on AnimationController {
  /// Create a curved animation with default curve
  Animation<double> get curvedAnimation => CurvedAnimation(
        parent: this,
        curve: AnimationConfigs.defaultCurve,
      );

  /// Create a curved animation with custom curve
  Animation<double> curved(Curve curve) => CurvedAnimation(
        parent: this,
        curve: curve,
      );

  /// Create a spring animation
  Animation<double> get springAnimation => CurvedAnimation(
        parent: this,
        curve: AnimationConfigs.spring,
      );
}