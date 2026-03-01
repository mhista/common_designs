import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../common_designs.dart';

// ============================================================
// ONBOARDING CAROUSEL (Like in your screenshots)
// ============================================================

/// Carousel with auto-rotating images and text content
/// Features:
/// - Auto-play with configurable interval
/// - Smooth page transitions
/// - Rotating product images
/// - Text crossfade animations
/// - Interactive page indicators
class OnboardingCarousel extends StatefulWidget {
  final List<OnboardingSlide> slides;
  final Duration autoPlayInterval;
  final Duration transitionDuration;
  final VoidCallback? onComplete;
  final bool autoPlay;

  const OnboardingCarousel({
    super.key,
    required this.slides,
    this.autoPlayInterval = AnimationConfigs.carouselInterval,
    this.transitionDuration = AnimationConfigs.slow,
    this.onComplete,
    this.autoPlay = true,
  });

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_currentPage < widget.slides.length - 1) {
        _pageController.nextPage(
          duration: widget.transitionDuration,
          curve: AnimationConfigs.pageTransition,
        );
      } else if (widget.autoPlay) {
        // Loop back to start
        _pageController.animateToPage(
          0,
          duration: widget.transitionDuration,
          curve: AnimationConfigs.pageTransition,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Reset auto-play timer on manual interaction
    if (widget.autoPlay) {
      _startAutoPlay();
    }

    // Call onComplete if we're on the last slide
    if (page == widget.slides.length - 1) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.slides.length,
            itemBuilder: (context, index) {
              return _CarouselSlide(
                slide: widget.slides[index],
                isActive: index == _currentPage,
              );
            },
          ),
        ),

        // Page Indicator
        const SizedBox(height: 24),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.slides.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 16,
            activeDotColor: Theme.of(context).primaryColor,
            dotColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ============================================================
// CAROUSEL SLIDE
// ============================================================

class _CarouselSlide extends StatelessWidget {
  final OnboardingSlide slide;
  final bool isActive;

  const _CarouselSlide({
    required this.slide,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rotating Images Grid
          Expanded(
            flex: 3,
            child: _RotatingImageGrid(
              images: slide.images,
              isActive: isActive,
            ),
          ),

          const SizedBox(height: 48),

          // Text Content
          Expanded(
            flex: 2,
            child: _CarouselTextContent(
              title: slide.title,
              description: slide.description,
              isActive: isActive,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ROTATING IMAGE GRID
// ============================================================

class _RotatingImageGrid extends StatefulWidget {
  final List<String> images;
  final bool isActive;

  const _RotatingImageGrid({
    required this.images,
    required this.isActive,
  });

  @override
  State<_RotatingImageGrid> createState() => _RotatingImageGridState();
}

class _RotatingImageGridState extends State<_RotatingImageGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    if (widget.isActive) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(_RotatingImageGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!widget.isActive && _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * 3.14159, // Full rotation
          child: _buildImageGrid(),
        );
      },
    );
  }

  Widget _buildImageGrid() {
    // Create a grid layout like in your screenshot
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return _ImageItem(
          imageUrl: widget.images[index],
          index: index,
        );
      },
    );
  }
}

class _ImageItem extends StatelessWidget {
  final String imageUrl;
  final int index;

  const _ImageItem({
    required this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: AnimationConfigs.medium)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          curve: AnimationConfigs.scale,
        );
  }
}

// ============================================================
// TEXT CONTENT WITH CROSSFADE
// ============================================================

class _CarouselTextContent extends StatefulWidget {
  final String title;
  final String description;
  final bool isActive;

  const _CarouselTextContent({
    required this.title,
    required this.description,
    required this.isActive,
  });

  @override
  State<_CarouselTextContent> createState() => _CarouselTextContentState();
}

class _CarouselTextContentState extends State<_CarouselTextContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        )
            .animate(
              onPlay: (controller) => controller.forward(),
            )
            .fadeIn(duration: AnimationConfigs.medium)
            .slideY(
              begin: 0.2,
              end: 0,
              duration: AnimationConfigs.medium,
              curve: AnimationConfigs.decelerate,
            ),

        const SizedBox(height: 16),

        // Description
        Text(
          widget.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
          textAlign: TextAlign.center,
        )
            .animate(
              delay: const Duration(milliseconds: 100),
              onPlay: (controller) => controller.forward(),
            )
            .fadeIn(duration: AnimationConfigs.medium)
            .slideY(
              begin: 0.2,
              end: 0,
              duration: AnimationConfigs.medium,
              curve: AnimationConfigs.decelerate,
            ),
      ],
    );
  }
}

// ============================================================
// DATA MODEL
// ============================================================

class OnboardingSlide {
  final String title;
  final String description;
  final List<String> images;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.images,
  });
}

// ============================================================
// USAGE EXAMPLE
// ============================================================

/// Example usage:
/// ```dart
/// OnboardingCarousel(
///   slides: [
///     OnboardingSlide(
///       title: 'Track your orders',
///       description: 'Track your orders every step of the way',
///       images: [
///         'assets/product1.png',
///         'assets/product2.png',
///         // ... more images
///       ],
///     ),
///     // ... more slides
///   ],
///   onComplete: () {
///     // Navigate to next screen
///   },
/// )
/// ```