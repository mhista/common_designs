import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../common_designs.dart';

/// List animation utilities for staggered entrance effects
class ListAnimations {
  ListAnimations._();

  // ============================================================
  // STAGGERED FADE + SLIDE
  // ============================================================

  /// Applies staggered fade and slide animation to list items
  /// Use this as a wrapper around ListView.builder items
  static Widget staggeredFadeSlide({
    required Widget child,
    required int index,
    Duration? delay,
    Duration? duration,
    double? slideDistance,
    Axis direction = Axis.vertical,
    Key? key,
  }) {
    final itemDelay = (delay ?? AnimationConfigs.staggerDelay) * index;
    final animDuration = duration ?? AnimationConfigs.medium;
    final distance = slideDistance ?? AnimationConfigs.listSlideDistance;

    final _ = direction == Axis.vertical
        ? Offset(0, distance)
        : Offset(distance, 0);

    return child
        .animate(delay: itemDelay)
        .fadeIn(duration: animDuration, curve: AnimationConfigs.fade)
        .slideY(
          begin: direction == Axis.vertical ? distance / 100 : 0,
          end: 0,
          duration: animDuration,
          curve: AnimationConfigs.decelerate,
        )
        .slideX(
          begin: direction == Axis.horizontal ? distance / 100 : 0,
          end: 0,
          duration: animDuration,
          curve: AnimationConfigs.decelerate,
        );
  }

  // ============================================================
  // STAGGERED SCALE
  // ============================================================

  /// Applies staggered scale animation (good for grid items)
  static Widget staggeredScale({
    required Widget child,
    required int index,
    Duration? delay,
    Duration? duration,
    double scaleFrom = 0.8,
  }) {
    final itemDelay = (delay ?? AnimationConfigs.staggerDelay) * index;
    final animDuration = duration ?? AnimationConfigs.medium;

    return child
        .animate(delay: itemDelay)
        .fadeIn(duration: animDuration)
        .scale(
          begin: Offset(scaleFrom, scaleFrom),
          end: const Offset(1.0, 1.0),
          duration: animDuration,
          curve: AnimationConfigs.scale,
        );
  }

  // ============================================================
  // HORIZONTAL REVEAL
  // ============================================================

  /// Horizontal reveal animation (good for cards)
  static Widget horizontalReveal({
    required Widget child,
    required int index,
    Duration? delay,
    Duration? duration,
  }) {
    final itemDelay = (delay ?? AnimationConfigs.staggerDelay) * index;
    final animDuration = duration ?? AnimationConfigs.medium;

    return child
        .animate(delay: itemDelay)
        .fadeIn(duration: animDuration)
        .slideX(
          begin: 0.2,
          end: 0,
          duration: animDuration,
          curve: AnimationConfigs.emphasized,
        );
  }

  // ============================================================
  // SHIMMER (Loading State)
  // ============================================================

  /// Shimmer effect for loading states
  static Widget shimmer({
    required Widget child,
    bool enabled = true,
    Duration? duration,
  }) {
    if (!enabled) return child;

    return child.animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: duration ?? const Duration(milliseconds: 1500),
      color: Colors.white.withValues(alpha:0.3),
      angle: 0,
    );
  }
}

// ============================================================
// ANIMATED LIST VIEW WRAPPER
// ============================================================

/// A ListView that automatically animates its children
class AnimatedListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final Duration? staggerDelay;
  final Duration? animationDuration;
  final bool enableAnimation;

  const AnimatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.staggerDelay,
    this.animationDuration,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final child = itemBuilder(context, index);

        if (!enableAnimation || AnimationConfigs.shouldReduceAnimations) {
          return child;
        }

        return ListAnimations.staggeredFadeSlide(
          index: index,
          delay: staggerDelay,
          duration: animationDuration,
          direction: scrollDirection,
          child: child,
        );
      },
    );
  }
}

// ============================================================
// ANIMATED GRID VIEW WRAPPER
// ============================================================

/// A GridView that automatically animates its children
class AnimatedGridView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Duration? staggerDelay;
  final Duration? animationDuration;
  final bool enableAnimation;

  const AnimatedGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.staggerDelay,
    this.animationDuration,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final child = itemBuilder(context, index);

        if (!enableAnimation || AnimationConfigs.shouldReduceAnimations) {
          return child;
        }

        return ListAnimations.staggeredScale(
          index: index,
          delay: staggerDelay,
          duration: animationDuration,
          child: child,
        );
      },
    );
  }
}

// ============================================================
// SLIVER ANIMATED LIST
// ============================================================

/// Sliver version of AnimatedListView for CustomScrollView
class SliverAnimatedList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration? staggerDelay;
  final Duration? animationDuration;
  final bool enableAnimation;

  const SliverAnimatedList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay,
    this.animationDuration,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = itemBuilder(context, index);

          if (!enableAnimation || AnimationConfigs.shouldReduceAnimations) {
            return child;
          }

          return ListAnimations.staggeredFadeSlide(
            index: index,
            delay: staggerDelay,
            duration: animationDuration,
            child: child,
          );
        },
        childCount: itemCount,
      ),
    );
  }
}

// ============================================================
// REORDERABLE LIST ANIMATIONS
// ============================================================

/// Wrapper for ReorderableListView with smooth animations
class AnimatedReorderableListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ReorderCallback onReorder;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final Duration? staggerDelay;
  final Duration? animationDuration;

  const AnimatedReorderableListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onReorder,
    this.controller,
    this.padding,
    this.staggerDelay,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollController: controller,
      padding: padding,
      itemCount: itemCount,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final item = itemBuilder(context, index);
        return ListAnimations.staggeredFadeSlide(
          key: ValueKey(index),
          index: index,
          delay: staggerDelay,
          duration: animationDuration,
          child: item,
        );
      },
    );
  }
}