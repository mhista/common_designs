import 'package:flutter/material.dart';

import '../../../common_designs.dart';


// class PSearchContainer extends StatelessWidget {
//   const PSearchContainer(
//       {super.key,
//       required this.text,
//       this.icon = Iconsax.search_normal,
//       this.showBackground = true,
//       this.showBorder = true,
//       this.onTap,
//       this.padding =
//           const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace)});
//   final String text;
//   final IconData? icon;
//   final bool showBackground, showBorder;
//   final void Function()? onTap;
//   final EdgeInsetsGeometry padding;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = PHelperFunctions.isDarkMode(context);
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: padding,
//         child: Container(
//           width: PDeviceUtils.getScreenWidth(context),
//           padding: const EdgeInsets.all(PSizes.md),
//           decoration: BoxDecoration(
//             color: showBackground
//                 ? isDark
//                     ? PColors.dark
//                     : PColors.white
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
//             border: showBorder ? Border.all(color: PColors.grey) : null,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 color: PColors.darkGrey,
//               ),
//               const SizedBox(
//                 width: (PSizes.spaceBtwItems),
//               ),
//               Text(
//                 text,
//                 style: Theme.of(context).textTheme.bodySmall,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PSearchContainer extends StatelessWidget implements PreferredSizeWidget {
  const PSearchContainer(
      {super.key,
      this.color,
      required this.text,
      this.useSuffix = false,
      this.useBorder = true,
      this.hasColor = false,
      this.inverse = false,
      this.isSmall = false,
      this.enabled = true,
      this.radius = 28,
      this.textFieldWidget,
      this.textController,
      this.usePrefixSuffix = false,
      this.onChanged,
      this.prefixWidget,
      this.focusNode,
      this.appBarHeight = kToolbarHeight,
      this.isDarkMode = false,
      this.onTap});

  // to add the background color to tabs, wrap with material widget.
  final Color? color;
  final String text;
  final bool useSuffix, useBorder, hasColor, usePrefixSuffix, inverse, isSmall, enabled, isDarkMode;
  final double? radius, appBarHeight;
  final Widget? textFieldWidget, prefixWidget;
  final TextEditingController? textController;
  final Function(String)? onChanged;
  final Function()? onTap;

  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    return TextField(
      enabled: enabled,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: onChanged,
      controller: textController,
      style: TextStyle(color: inverse ? AppColors.textPrimaryDark : null),
      decoration: InputDecoration(
          fillColor: hasColor
              ? color
              : isDark
                  ? AppColors.backgroundDark
                  : AppColors.backgroundLight,
          filled: true,
          contentPadding: useSuffix
              ? const EdgeInsets.symmetric(vertical: 15, horizontal: 10)
              : EdgeInsets.symmetric(
                  vertical: isSmall ? 20 : 15, horizontal: 8),
          hintText: text,
          hintStyle: Theme.of(context)
              .textTheme
              .labelMedium!
              .apply(color: inverse ? Colors.white : null),
          suffixIcon: useSuffix || usePrefixSuffix
              ? Padding(
                  padding: isSmall
                      ? const EdgeInsets.only(bottom: 18.0)
                      : const EdgeInsets.all(0),
                  child: textFieldWidget ?? SearchIcon(isDark: isDark),
                )
              : null,
          prefixIcon: !useSuffix ? prefixWidget : SearchIcon(isDark: isDark),
          border: inputBorder(isDark, useBorder, radius),
          focusedBorder: inputBorder(isDark, useBorder, radius),
          enabledBorder: inputBorder(isDark, useBorder, radius)),
    );
  }

  OutlineInputBorder inputBorder(bool isDark, bool useBorder, double? radius) {
    return OutlineInputBorder(
      borderSide: useBorder
          ? BorderSide(
              color: isDark ? AppColors.textSecondaryLight.withValues(alpha: 0.2) : AppColors.borderLight)
          : BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(radius ?? 14.0),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}

class SearchIcon extends StatelessWidget {
  const SearchIcon({
    super.key,
    required this.isDark,
    this.icon = Icons.search,
  });

  final bool isDark;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        icon,
        size: 20,
        // color: isDark ? PColors.black : PColors.white,

        // color: Colors.white,
      ),
    );
  }
}
