import 'package:flutter/widgets.dart';
import 'animations_config.dart';

/// Custom transition page for go_router
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;
  final bool opaque;

  const CustomTransitionPage({
    required super.key,
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    super.name,
    super.arguments,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      opaque: opaque,
    );
  }
}

/// Custom page transitions for the app.
/// Use with GoRouter's pageBuilder.
class AppPageTransitions {
  AppPageTransitions._();

  // ============================================================
  // MODAL SLIDE UP (Like Shopify's bottom sheet)
  // ============================================================

  /// Smooth slide-up transition with backdrop fade
  /// Perfect for modals, bottom sheets, and detail views
  static Page<T> modalSlideUp<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
    bool opaque = true,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      opaque: opaque,
      transitionDuration: AnimationConfigs.medium,
      reverseTransitionDuration: AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;

        final slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: AnimationConfigs.modalSlideUp),
        );

        final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: AnimationConfigs.fade),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ============================================================
  // STANDARD SLIDE TRANSITIONS
  // ============================================================

  /// Slide from right (default iOS-style)
  static Page<T> slideFromRight<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: AnimationConfigs.pageTransition),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide from left
  static Page<T> slideFromLeft<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: AnimationConfigs.pageTransition),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      child: child,
    );
  }

  // ============================================================
  // FADE TRANSITION
  // ============================================================

  /// Simple fade transition
  static Page<T> fade<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
    Duration? duration,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: duration ?? AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            Tween<double>(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: AnimationConfigs.fade),
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // ============================================================
  // SCALE TRANSITION
  // ============================================================

  /// Scale transition with fade (good for dialogs)
  static Page<T> scaleWithFade<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(begin: 0.9, end: 1.0).chain(
          CurveTween(curve: AnimationConfigs.scale),
        );

        final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: AnimationConfigs.fade),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ============================================================
  // SHARED AXIS TRANSITION (Material 3)
  // ============================================================

  /// Shared axis transition (vertical)
  static Page<T> sharedAxisVertical<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: AnimationConfigs.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Forward animation (entering)
        final enterSlide = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: AnimationConfigs.emphasized,
        ));

        final enterFade = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
          ),
        );

        // Reverse animation (exiting)
        final exitSlide = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.1),
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: AnimationConfigs.emphasized,
        ));

        final exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: secondaryAnimation.status == AnimationStatus.reverse
              ? exitSlide
              : enterSlide,
          child: FadeTransition(
            opacity: secondaryAnimation.status == AnimationStatus.reverse
                ? exitFade
                : enterFade,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ============================================================
  // NO TRANSITION
  // ============================================================

  /// No animation (instant)
  static Page<T> noTransition<T>({
    required Widget child,
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      transitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      child: child,
    );
  }
}

// ============================================================
// GO ROUTER EXTENSION
// ============================================================

/// Extension to easily use page transitions with GoRouter
extension GoRouterPageTransitionExtension on Widget {
  /// Convert widget to modal slide up page
  Page<T> asModalSlideUp<T>({
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return AppPageTransitions.modalSlideUp<T>(
      child: this,
      key: key,
      name: name,
      arguments: arguments,
    );
  }

  /// Convert widget to slide from right page
  Page<T> asSlideFromRight<T>({
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return AppPageTransitions.slideFromRight<T>(
      child: this,
      key: key,
      name: name,
      arguments: arguments,
    );
  }

  /// Convert widget to fade page
  Page<T> asFadePage<T>({
    required LocalKey key,
    String? name,
    Object? arguments,
    Duration? duration,
  }) {
    return AppPageTransitions.fade<T>(
      child: this,
      key: key,
      name: name,
      arguments: arguments,
      duration: duration,
    );
  }

  /// Convert widget to scale with fade page
  Page<T> asScaleWithFade<T>({
    required LocalKey key,
    String? name,
    Object? arguments,
  }) {
    return AppPageTransitions.scaleWithFade<T>(
      child: this,
      key: key,
      name: name,
      arguments: arguments,
    );
  }
}