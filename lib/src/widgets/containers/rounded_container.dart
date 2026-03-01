import 'package:flutter/material.dart';

import '../../../common_designs.dart';


class SmoothEdgeContainer extends StatelessWidget {
  const SmoothEdgeContainer(
      {super.key,
      this.width,
      this.height,
      this.radius = AppSpacing.cardRadiusLG,
      this.backgroundColor = AppColors.cardLight,
      this.borderColor = AppColors.borderLight,
      this.child,
      this.margin,
      this.padding = const EdgeInsets.all(AppSpacing.md),
      this.showBorder = false,
      this.showShadow = false,
      this.useElevation = false,
      this.onTap,
      this.gradient});
  final double? width, height;
  final double radius;
  final Color? backgroundColor, borderColor;
  final Widget? child;
  final EdgeInsetsGeometry? margin, padding;
  final bool showBorder, showShadow, useElevation;
  final void Function()? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            color: backgroundColor,
            border: showBorder
                ? Border.all(color: borderColor ?? AppColors.transparent)
                : null,
            boxShadow: [
              if (showShadow)
                BoxShadow(
                    color: AppColors.backgroundDark.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(
                      0,
                      2,
                    )),
              if (showShadow)
                BoxShadow(
                    color: AppColors.backgroundDark.withValues(alpha: 0.15),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(
                      0,
                      1,
                    ))
            ]),
        child: child,
      ),
    );
  }
}
