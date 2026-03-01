import 'package:common_utils2/common_utils2.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerEffect extends StatelessWidget {
  const CommonShimmerEffect(
      {super.key,
      required this.height,
      required this.width,
      this.radius = 15,
      this.baseColor,
      this.highlightColor,
      this.color});

  final double height, width, radius;
  final Color? color, baseColor, highlightColor;
  @override
  Widget build(BuildContext context) {
    final isDark = ResponsiveHelper.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[850]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
