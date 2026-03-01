import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_designs/common_designs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shimmer/shimmer.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.image,
    this.width = 56,
    this.height = 56,
    this.padding = AppSpacing.xs,
    this.isNetworkImage = false,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.overLayColor,
    this.overlayColor,
    this.file,
    this.imageType = ImagesType.asset,
    this.memoryImage,
  });

  final String? image;
  final double width, height, padding;
  final bool isNetworkImage;
  final Color? backgroundColor, overlayColor;
  final File? file;
  final ImagesType imageType;
  final Uint8List? memoryImage;
  final BoxFit? fit;
  final Color? overLayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;

    switch (imageType) {
      case ImagesType.network:
        imageWidget = _buildNetworkImage();
        break;
      case ImagesType.file:
        imageWidget = _buildFileImage();
        break;
      case ImagesType.memory:
        imageWidget = _buildMemoryImage();
        break;
      case ImagesType.asset:
        imageWidget = _buildAssetImage();
        break;
    }
    // apply ClipRect to the image widget directly
    return ClipRRect(
      borderRadius: BorderRadius.circular(width >= height ? width : height),
      child: imageWidget,
    );
  }

  // build network image
  Widget _buildNetworkImage() {
    if (image != null) {
      return CachedNetworkImage(
        imageUrl: image!,
        color: overLayColor,
        fit: fit,
        height: height,
        width: width,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const CommonShimmerEffect(height: 100, width: 100, radius: 100),
      );
    } else {
      return Container();
    }
  }

  // build file image
  Widget _buildFileImage() {
    if (file != null) {
      return Image(fit: fit, image: FileImage(file!), color: overlayColor);
    } else {
      return Container();
    }
  }

  // build memory image
  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      return Image(
        fit: fit,
        image: MemoryImage(memoryImage!),
        color: overlayColor,
      );
    } else {
      return Container();
    }
  }

  // build asset image
  Widget _buildAssetImage() {
    if (image != null) {
      return Image.asset(image!, fit: fit, color: overlayColor);
    } else {
      return Container();
    }
  }
}
