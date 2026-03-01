import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common_designs.dart';

// ============================================================
// PULL TO REFRESH ANIMATION
// ============================================================

/// Custom pull-to-refresh indicator with smooth animations
class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? Theme.of(context).colorScheme.primary,
      backgroundColor: backgroundColor,
      displacement: displacement,
      strokeWidth: 2.5,
      child: child,
    );
  }
}

/// Custom pull-to-refresh with animated header
class AnimatedPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext, RefreshIndicatorMode, double)? builder;

  const AnimatedPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.builder,
  });

  @override
  State<AnimatedPullToRefresh> createState() => _AnimatedPullToRefreshState();
}

class _AnimatedPullToRefreshState extends State<AnimatedPullToRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _controller.repeat();
    try {
      await widget.onRefresh();
    } finally {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: widget.child,
    );
  }
}

// ============================================================
// SKELETON LOADER (Shimmer Effect)
// ============================================================

/// Skeleton loader with shimmer effect for loading states
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton card for list items
class SkeletonCard extends StatelessWidget {
  final double? height;
  final bool showImage;

  const SkeletonCard({
    super.key,
    this.height,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (showImage) ...[
            const SkeletonLoader(
              width: 80,
              height: 80,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                SkeletonLoader(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                SkeletonLoader(
                  width: 100,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SWIPE TO DELETE / ARCHIVE
// ============================================================

/// Swipeable list item with delete/archive actions
class SwipeableListItem extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final VoidCallback? onEdit;
  final Color deleteColor;
  final Color archiveColor;
  final IconData deleteIcon;
  final IconData archiveIcon;

  const SwipeableListItem({
    super.key,
    required this.child,
    this.onDelete,
    this.onArchive,
    this.onEdit,
    this.deleteColor = Colors.red,
    this.archiveColor = Colors.blue,
    this.deleteIcon = Icons.delete,
    this.archiveIcon = Icons.archive,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: archiveColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(archiveIcon, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: deleteColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(deleteIcon, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart && onDelete != null) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          return result ?? false;
        }
        return true;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete?.call();
        } else if (direction == DismissDirection.startToEnd) {
          onArchive?.call();
        }
      },
      child: child,
    );
  }
}

// ============================================================
// SLIDE TO REVEAL ACTIONS (iOS style)
// ============================================================

/// iOS-style slide to reveal actions
class SlideToReveal extends StatefulWidget {
  final Widget child;
  final List<SlideAction> actions;
  final double actionExtent;

  const SlideToReveal({
    super.key,
    required this.child,
    required this.actions,
    this.actionExtent = 80,
  });

  @override
  State<SlideToReveal> createState() => _SlideToRevealState();
}

class _SlideToRevealState extends State<SlideToReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfigs.fast,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-widget.actions.length * widget.actionExtent / 1000, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfigs.decelerate,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      onHorizontalDragEnd: (details) {
        if (_controller.value > 0.5) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: Stack(
        children: [
          // Actions background
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions.map((action) {
                return Container(
                  width: widget.actionExtent,
                  color: action.color,
                  child: InkWell(
                    onTap: () {
                      action.onTap?.call();
                      _controller.reverse();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(action.icon, color: Colors.white),
                        const SizedBox(height: 4),
                        if (action.label != null)
                          Text(
                            action.label!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Sliding content
          SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class SlideAction {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback? onTap;

  const SlideAction({
    required this.icon,
    this.label,
    required this.color,
    this.onTap,
  });
}

// ============================================================
// USAGE EXAMPLES
// ============================================================

/// Example: Pull to refresh
/// ```dart
/// CustomRefreshIndicator(
///   onRefresh: () async {
///     await Future.delayed(Duration(seconds: 2));
///     // Refresh your data
///   },
///   child: ListView(...),
/// );
/// ```
///
/// Example: Skeleton loader
/// ```dart
/// isLoading
///   ? ListView.builder(
///       itemCount: 5,
///       itemBuilder: (_, __) => SkeletonCard(),
///     )
///   : ListView.builder(...)
/// ```
///
/// Example: Swipe to delete
/// ```dart
/// SwipeableListItem(
///   onDelete: () => deleteItem(item.id),
///   onArchive: () => archiveItem(item.id),
///   child: ListTile(title: Text(item.name)),
/// );
/// ```