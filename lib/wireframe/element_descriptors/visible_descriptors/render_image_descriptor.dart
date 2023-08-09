import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/utils.dart';

class RenderImageDescriptor extends VisibleElementDescriptor {
  final Map<int, CachedImageInfo?> cachedImagesInfo = {};

  RenderImageDescriptor();

  @override
  Color? createColor(Element element) {
    final Color? color =
        cachedImagesInfo[(element.renderObject as RenderImage).hashCode]?.color;

    return color;
  }

  @override
  Rect? createElementRect(Element element, Rect? parentRect) {
    final RenderImage renderImage = element.renderObject as RenderImage;
    if (!renderImage.hasSize) {
      return null;
    }

    final CachedImageInfo? imageInfo = cachedImagesInfo[renderImage.hashCode];
    if (imageInfo?.color == null) {
      calculateImageColor(renderImage);

      return null;
    }
    final BoxFit fit = renderImage.fit ?? BoxFit.scaleDown;
    final Size size = getScaledSize(
      imageInfo!.widthPixels.toDouble(),
      imageInfo.heightPixels.toDouble(),
      renderImage,
      fit,
    );
    final offset = renderImage.localToGlobal(Offset.zero);

    double? top = offset.dy;
    double? left = offset.dx;

    final AlignmentGeometry alignment = renderImage.alignment;

    left = _calculateLeftPosition(alignment, offset, renderImage, size.width);
    top = _calculateTopPosition(alignment, offset, renderImage, size.height);

    return Rect.fromLTWH(
      left,
      top,
      size.width,
      size.height,
    );
  }

  Size getScaledSize(
    double originalWidth,
    double originalHeight,
    RenderImage renderImage,
    BoxFit fit,
  ) {
    final double targetWidth = renderImage.size.width;
    final double targetHeight = renderImage.size.height;

    final double aspectRatio = originalWidth / originalHeight;
    switch (fit) {
      case BoxFit.fill:
        return Size(targetWidth, targetHeight);
      case BoxFit.contain:
        if (targetWidth / aspectRatio <= targetHeight) {
          return Size(targetWidth, targetWidth / aspectRatio);
        }
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.cover:
        if (targetWidth / aspectRatio >= targetHeight) {
          return Size(targetWidth, targetWidth / aspectRatio);
        }
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.fitWidth:
        return Size(targetWidth, targetWidth / aspectRatio);
      case BoxFit.fitHeight:
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.none:
        return Size(originalWidth, originalHeight);
      case BoxFit.scaleDown:
        if (originalWidth > targetWidth || originalHeight > targetHeight) {
          return getScaledSize(
            originalWidth,
            originalHeight,
            renderImage,
            BoxFit.contain,
          );
        }
        return Size(originalWidth, originalHeight);
    }
  }

  double _calculateLeftPosition(
    AlignmentGeometry alignment,
    Offset offset,
    RenderImage renderImage,
    double renderBoxWidth,
  ) {
    if (alignment == Alignment.centerLeft ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.topLeft) {
      return offset.dx;
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.topRight) {
      return offset.dx + renderImage.size.width - renderBoxWidth;
    }

    return offset.dx + (renderImage.size.width - renderBoxWidth) / 2;
  }

  double _calculateTopPosition(
    AlignmentGeometry alignment,
    Offset offset,
    RenderImage renderImage,
    double renderBoxHeight,
  ) {
    if (alignment == Alignment.topLeft ||
        alignment == Alignment.topCenter ||
        alignment == Alignment.topRight) {
      return offset.dy;
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomCenter) {
      return offset.dy + renderImage.size.height - renderBoxHeight;
    }

    return offset.dy + (renderImage.size.height - renderBoxHeight) / 2;
  }

  Future<CachedImageInfo?> calculateImageColor(RenderImage renderImage) async {
    if (renderImage.image == null) {
      return null;
    }

    if (cachedImagesInfo.containsKey(renderImage.hashCode)) {
      return cachedImagesInfo[renderImage.hashCode];
    }

    cachedImagesInfo[renderImage.hashCode] = null;
    final imgWidth = renderImage.image!.width;
    final imgHeight = renderImage.image!.height;
    final downscaledImage = await downscaleImage(renderImage.image!, 8, 8);

    downscaledImage.toByteData().then((byteData) {
      if (byteData == null || byteData.lengthInBytes == 0) {
        return null;
      }

      final calculatedColor = WireframeUtils.createColorFromByteData(
        byteData,
        downscaledImage.height,
        downscaledImage.width,
      );
      // Return the average color values as a list
      cachedImagesInfo[renderImage.hashCode] = CachedImageInfo(
        calculatedColor,
        imgWidth,
        imgHeight,
      );

      return cachedImagesInfo[renderImage.hashCode];
    });

    return null;
  }

  Future<ui.Image> downscaleImage(
    ui.Image image,
    int maxWidth,
    int maxHeight,
  ) async {
    final double originalWidth = image.width.toDouble();
    final double originalHeight = image.height.toDouble();
    final double aspectRatio = originalWidth / originalHeight;

    int newWidth = originalWidth.toInt();
    int newHeight = originalHeight.toInt();

    if (originalWidth > maxWidth || originalHeight > maxHeight) {
      if (originalWidth > originalHeight) {
        newWidth = maxWidth;
        newHeight = maxWidth ~/ aspectRatio;
      } else {
        newHeight = maxHeight;
        newWidth = (maxHeight * aspectRatio).toInt();
      }
    }

    // Ensure the new width and height are at least 1 pixel
    newWidth = newWidth.clamp(1, maxWidth);
    newHeight = newHeight.clamp(1, maxHeight);

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
      recorder,
      Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble()),
    );
    final Paint paint = Paint()..isAntiAlias = false;
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, originalWidth, originalHeight),
      Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble()),
      paint,
    );

    final ui.Image scaledImage =
        await recorder.endRecording().toImage(newWidth, newHeight);

    return scaledImage;
  }
}
