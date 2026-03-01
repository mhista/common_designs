// ============================================================
// SPACING & SIZING SYSTEM
// ============================================================
import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  // ============================================================
  // CORE SPACING VALUES
  // ============================================================
  
  /// 4px
  static const double xxxs = 4.0;
  /// 8px
  static const double xxs = 8.0;
  /// 12px
  static const double xs = 12.0;
  /// 16px - Most common spacing
  static const double sm = 16.0;
  /// 20px
  static const double md = 20.0;
  /// 24px
  static const double lg = 24.0;
  /// 32px
  static const double xl = 32.0;
  /// 40px
  static const double xxl = 40.0;
  /// 48px
  static const double xxxl = 48.0;
  /// 64px
  static const double huge = 64.0;

  // ============================================================
  // ICON SIZES
  // ============================================================
  
  /// 12px - Extra small icons
  static const double iconXS = 12.0;
  /// 16px - Small icons
  static const double iconSM = 16.0;
  /// 20px - Regular icons
  static const double iconMD = 20.0;
  /// 24px - Default icon size
  static const double iconLG = 24.0;
  /// 32px - Large icons
  static const double iconXL = 32.0;
  /// 48px - Extra large icons (app bar, avatars)
  static const double iconXXL = 48.0;

  // ============================================================
  // FONT SIZES
  // ============================================================
  
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;

  // ============================================================
  // BUTTON DIMENSIONS
  // ============================================================
  
  static const double buttonHeight = 18.0;
  static const double buttonRadius = 10.0;
  static const double buttonWidth = 130.0;
  static const double buttonElevation = 4.0;

  // ============================================================
  // BORDER RADIUS
  // ============================================================
  
  static const double borderRadiusSM = 4.0;
  static const double borderRadiusMD = 8.0;
  static const double borderRadiusLG = 12.0;

  // ============================================================
  // CARD DIMENSIONS
  // ============================================================
  
  static const double cardRadiusXS = 6.0;
  static const double cardRadiusSM = 10.0;
  static const double cardRadiusMD = 12.0;
  static const double cardRadiusLG = 16.0;
  static const double cardElevation = 2.0;

  // ============================================================
  // COMPONENT SPECIFIC SIZES
  // ============================================================
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// Image thumbnail size
  static const double imageThumbSize = 80.0;
  
  /// Product image size
  static const double productImageSize = 120.0;
  static const double productImageRadius = 16.0;
  static const double productItemHeight = 160.0;
  
  /// Image carousel height
  static const double imageCarouselHeight = 200.0;
  
  /// Loading indicator size
  static const double loadingIndicatorSize = 36.0;
  
  /// Divider height
  static const double dividerHeight = 1.0;

  // ============================================================
  // LAYOUT SPACING
  // ============================================================
  
  /// Default spacing between sections
  static const double defaultSpace = 24.0;
  
  /// Spacing between items
  static const double spaceBtwItems = 16.0;
  
  /// Spacing between sections
  static const double spaceBtwSections = 20.0;
  
  /// Grid view spacing
  static const double gridViewSpacing = 16.0;

  // ============================================================
  // INPUT FIELD
  // ============================================================
  
  static const double inputFieldRadius = 12.0;
  static const double spaceBtwInputFields = 15.0;

  // ============================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================
  
  static const double desktopScreenSize = 1366;
  static const double tabletScreenSize = 768;
  static const double mobileScreenSize = 360;
  static const double customScreenSize = 1100;

  // ============================================================
  // EDGE INSETS PRESETS
  // ============================================================
  
  /// All sides - 4px
  static const EdgeInsets allXXXS = EdgeInsets.all(xxxs);
  /// All sides - 8px
  static const EdgeInsets allXXS = EdgeInsets.all(xxs);
  /// All sides - 12px
  static const EdgeInsets allXS = EdgeInsets.all(xs);
  /// All sides - 16px (Most common)
  static const EdgeInsets allSM = EdgeInsets.all(sm);
  /// All sides - 20px
  static const EdgeInsets allMD = EdgeInsets.all(md);
  /// All sides - 24px
  static const EdgeInsets allLG = EdgeInsets.all(lg);
  /// All sides - 32px
  static const EdgeInsets allXL = EdgeInsets.all(xl);
  
  /// Horizontal - 16px
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  /// Horizontal - 24px
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  
  /// Vertical - 16px
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  /// Vertical - 24px
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  
  /// Page padding (horizontal: 24px, vertical: 16px)
  static const EdgeInsets page = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  
  /// Card padding
  static const EdgeInsets card = EdgeInsets.all(sm);
  
  /// List item padding
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );
  
  /// Button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xs,
  );
}