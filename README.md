  # Vendor Design System

  A comprehensive, production-grade design system with robust animations for Flutter apps. Inspired by modern e-commerce interfaces like Shopify, featuring smooth transitions, interactive animations, and beautiful typography.

  [![pub package](https://img.shields.io/pub/v/common_designs.svg)](https://pub.dev/packages/common_designs)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

  ## ✨ Features

  - 🎭 **Complete Animation System** - Page transitions, list animations, interactive micro-animations
  - 🔄 **Loading States** - Pull-to-refresh, skeleton loaders, swipe actions
  - 🦸 **Hero Animations** - Smooth shared element transitions between screens
  - 📊 **Progress Tracking** - Animated progress bars and circular indicators
  - 🔔 **Notifications** - Toast messages, badges, pulsing dots, confetti celebrations
  - 🎨 **Modern Typography** - Clean, hierarchical font system with Google Fonts
  - 🌈 **Beautiful Colors** - Comprehensive color scheme with light/dark mode support
  - 📱 **Modal Animations** - Smooth bottom sheets with margins, chat suggestions
  - 🎪 **Onboarding Carousel** - Auto-rotating product showcase with text transitions
  - ⚡ **Performance Optimized** - 60fps animations with accessibility support
  - 🧩 **Modular & Composable** - SOLID principles, highly reusable components
  - 📦 **Production Ready** - Battle-tested, type-safe, null-safe

  **60+ Animation Components** covering every aspect of modern app development!

  ## 🆕 What's New in v1.1.0

  Three essential animation categories added:

  ### 1️⃣ Loading & Feedback Animations
  - Pull-to-refresh (standard for any list/feed)
  - Skeleton loaders (40% better perceived performance)
  - Swipe-to-delete/archive (iOS-style actions)
  - Slide-to-reveal multiple actions

  ### 2️⃣ Hero & Progress Animations
  - Hero transitions (shared element animations)
  - Morphing icons (play/pause, favorite, menu)
  - Animated counters (likes, views, totals)
  - Progress bars (linear & circular)

  ### 3️⃣ Notification Animations
  - Toast notifications (non-intrusive messages)
  - Animated badges (with bounce effect)
  - Pulsing dots (online status, unread)
  - Confetti (success celebrations)

  📚 **Full guide:** [NEW_ANIMATIONS.md](https://github.com/mhista/common_designs/blob/main/NEW_ANIMATIONS.md)

  ## 📸 Screenshots

  <!-- Add your screenshots here -->

  ## 🚀 Getting Started

  ### Installation

  Add this to your package's `pubspec.yaml` file:

  ```yaml
  dependencies:
    common_designs: ^1.1.0
  ```

  Then run:

  ```bash
  flutter pub get
  ```

  ### Quick Setup

  1. **Configure your theme:**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:common_designs/common_designs.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'My App',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const HomeScreen(),
      );
    }
  }
  ```

  2. **Use animations:**

  ```dart
  // Animated list
  AnimatedListView(
    itemCount: products.length,
    itemBuilder: (context, index) {
      return ProductCard(product: products[index]);
    },
  );

  // Pressable button
  Pressable(
    onPressed: () => print('Pressed!'),
    child: Container(
      padding: AppSpacing.allSM,
      child: Text('Tap me'),
    ),
  );

  // Modal with margin
  AppModals.showBottomSheetWithMargin(
    context: context,
    child: AppModalSheet(
      title: 'Options',
      child: YourContent(),
    ),
  );
  ```

  ## 📚 Components

  ### Animations

  #### Page Transitions
  ```dart
  // With GoRouter
  GoRoute(
    path: '/details',
    pageBuilder: (context, state) {
      return AppPageTransitions.modalSlideUp(
        key: state.pageKey,
        child: DetailsScreen(),
      );
    },
  );
  ```

  Available transitions:
  - `modalSlideUp` - Smooth slide from bottom (like Shopify)
  - `slideFromRight` - iOS-style horizontal slide
  - `slideFromLeft` - Reverse horizontal slide
  - `fade` - Simple fade transition
  - `scaleWithFade` - Scale + fade (good for dialogs)
  - `sharedAxisVertical` - Material 3 shared axis

  #### List Animations
  ```dart
  // Staggered fade + slide
  ListAnimations.staggeredFadeSlide(
    index: index,
    child: ListItem(),
  );

  // Grid scale animation
  ListAnimations.staggeredScale(
    index: index,
    child: GridItem(),
  );

  // Shimmer loading
  ListAnimations.shimmer(
    enabled: isLoading,
    child: SkeletonCard(),
  );
  ```

  #### Interactive Animations
  ```dart
  // Pressable button
  Pressable(
    onPressed: onTap,
    scaleAmount: 0.95,
    child: YourButton(),
  );

  // Like button with heart animation
  LikeButton(
    isLiked: isLiked,
    onTap: toggleLike,
    likedColor: AppColors.like,
  );

  // Shake for errors
  ShakeWidget(
    shake: hasError,
    child: TextField(),
  );

  // Bouncing animation
  BouncingWidget(
    onTap: onTap,
    child: Icon(Icons.favorite),
  );
  ```

  #### Loading & Feedback Animations ⭐ NEW
  ```dart
  // Pull-to-refresh
  CustomRefreshIndicator(
    onRefresh: () async => await fetchData(),
    child: ListView(...),
  );

  // Skeleton loaders
  isLoading ? SkeletonCard() : DataCard();

  // Swipe-to-delete/archive
  SwipeableListItem(
    onDelete: () => deleteItem(),
    onArchive: () => archiveItem(),
    child: ListTile(...),
  );

  // Slide-to-reveal actions (iOS style)
  SlideToReveal(
    actions: [
      SlideAction(icon: Icons.delete, color: Colors.red, onTap: delete),
      SlideAction(icon: Icons.archive, color: Colors.blue, onTap: archive),
    ],
    child: ListTile(...),
  );
  ```

  #### Hero & Progress Animations ⭐ NEW
  ```dart
  // Hero transitions
  HeroImage(
    tag: 'product-$id',
    imageUrl: product.image,
  );

  // Morphing icons
  MorphingIcon(
    startIcon: Icons.play_arrow,
    endIcon: Icons.pause,
    showEnd: isPlaying,
  );

  // Animated counter
  AnimatedCounter(
    value: likesCount,
    suffix: ' likes',
  );

  // Progress bars
  AnimatedProgressBar(value: uploadProgress);
  AnimatedCircularProgress(value: progress, showPercentage: true);
  ```

  #### Notification Animations ⭐ NEW
  ```dart
  // Toast notifications
  AppToast.success(context, 'Order placed!');
  AppToast.error(context, 'Failed to save');
  AppToast.warning(context, 'Low storage');
  AppToast.info(context, 'New update available');

  // Animated badge
  AnimatedBadge(
    count: unreadCount,
    child: Icon(Icons.notifications),
  );

  // Pulsing dot (online status, unread)
  PulsingDot(color: Colors.green);

  // Confetti celebration
  ConfettiAnimation(
    trigger: orderComplete,
    child: SuccessScreen(),
  );
  ```

  #### Modal Animations
  ```dart
  // Bottom sheet with margin (floating effect)
  AppModals.showBottomSheetWithMargin(
    context: context,
    bottomMargin: 16,
    horizontalMargin: 16,
    child: YourContent(),
  );

  // Draggable bottom sheet
  AppModals.showDraggableBottomSheet(
    context: context,
    initialChildSize: 0.6,
    child: YourContent(),
  );

  // Alert dialog
  AppModals.showAlertDialog(
    context: context,
    title: 'Confirm',
    content: 'Are you sure?',
    actions: [/* buttons */],
  );
  ```

  #### Chat Suggestions
  ```dart
  // Auto-stagger in/out
  ChatSuggestions(
    suggestions: ['Hello', 'Help', 'Support'],
    show: textIsEmpty,
    onSuggestionTapped: (suggestion) {
      controller.text = suggestion;
    },
  );

  // Chat message bubbles
  AnimatedChatMessage(
    message: 'Hello!',
    isUser: true,
    index: index,
  );
  ```

  #### Onboarding Carousel
  ```dart
  OnboardingCarousel(
    slides: [
      OnboardingSlide(
        title: 'Track your orders',
        description: 'Track every step of the way',
        images: ['assets/p1.png', 'assets/p2.png', ...],
      ),
    ],
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 3),
    onComplete: () => navigateToHome(),
  );
  ```

  ### Typography

  ```dart
  // Headings
  Text('Title', style: AppTypography.headlineSmall());
  Text('Subtitle', style: AppTypography.titleMedium());

  // Body text
  Text('Description', style: AppTypography.bodyMedium());

  // Labels
  Text('Button', style: AppTypography.labelLarge());

  // Special styles
  Text('\$55.00', style: AppTypography.price());
  Text('4.8 ★', style: AppTypography.rating());
  ```

  ### Colors

  ```dart
  // Use semantic colors
  Container(color: AppColors.primary);
  Text(style: TextStyle(color: AppColors.textPrimaryLight));

  // Or from theme
  Container(color: Theme.of(context).colorScheme.primary);

  // Gradients
  Container(
    decoration: BoxDecoration(
      gradient: AppGradients.primary,
    ),
  );
  ```

  ### Spacing

  ```dart
  // Consistent spacing
  SizedBox(height: AppSpacing.md);
  Padding(padding: AppSpacing.allSM);
  EdgeInsets.symmetric(horizontal: AppSpacing.lg);

  // Border radius
  BorderRadius: AppBorderRadius.md;
  borderRadius: AppBorderRadius.modal;

  // Shadows
  boxShadow: AppShadows.medium;
  ```

  ## 🎨 Customization

  You can customize the design system by modifying constants:

  ```dart
  // In your app
  class MyAppColors {
    static const primary = Color(0xFF YOUR_COLOR);
  }

  class MyAppTypography {
    static TextStyle get baseFont => GoogleFonts.yourFont();
  }
  ```

  ## 📱 Complete Examples

  See [USAGE_EXAMPLES.md](https://github.com/mhista/common_designs/blob/main/USAGE_EXAMPLES.md) for comprehensive examples including:
  - E-commerce product cards
  - Chat interfaces
  - Search with suggestions
  - Filter modals
  - Complete screens

  ## ⚡ Performance

  - All animations run at 60fps
  - Respects system accessibility settings
  - Optimized widget rebuilds
  - Const constructors where possible
  - Proper disposal of animation controllers

  ## 🎯 Accessibility

  The design system automatically:
  - Respects `MediaQuery.disableAnimations`
  - Provides proper contrast ratios
  - Includes semantic labels
  - Supports screen readers

  ## 🤝 Contributing

  Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) first.

  ## 📄 License

  This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

  ## 🙏 Acknowledgments

  - Inspired by Shopify's mobile design
  - Built with Flutter's Material Design 3
  - Uses Google Fonts for typography

  ## 📞 Support

  - 📧 Email: diweesomchi@gmail.com
  - 🐛 Issues: [GitHub Issues](https://github.com/mhista/common_designs/issues)
  - 💬 Discussions: [GitHub Discussions](https://github.com/mhista/common_designs/discussions)

  ---

  Made with ❤️ by [Your Name]