import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';

class WireframeUtils {
  static List<Skeleton>? skeletonsFromBorderRect(
    Rect elementRect,
    Color color,
    double width,
  ) {
    if (width.toInt() == 0) {
      return null;
    }

    return [
      Skeleton(
        rect: Rect.fromLTWH(
          elementRect.left,
          elementRect.top,
          elementRect.width,
          width,
        ),
        color: color,
      ),
      Skeleton(
        rect: Rect.fromLTWH(
          elementRect.left,
          elementRect.bottom,
          elementRect.width,
          width,
        ),
        color: color,
      ),
      Skeleton(
        rect: Rect.fromLTWH(
          elementRect.left,
          elementRect.top,
          width,
          elementRect.height,
        ),
        color: color,
      ),
      Skeleton(
        rect: Rect.fromLTWH(
          elementRect.right,
          elementRect.top,
          width,
          elementRect.height,
        ),
        color: color,
      ),
    ];
  }

  static Color createColorFromByteData(
    ByteData byteData,
    int height,
    int width,
  ) {
    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int pixelCount = 0;

    const sampleSize = 1;

    // Iterate over the rows and columns of the image
    for (int y = 0; y < height; y += sampleSize) {
      for (int x = 0; x < width; x += sampleSize) {
        // Calculate the byteOffset for the current position (x, y)
        final int byteOffset = (y * width + x) * 4;
        // Get the pixel at the current position as an ARGB int value
        final int argbInt = byteData.getInt32(byteOffset);

        // Decode the ARGB int value to its components
        final int r = (argbInt >> 32) & 0xFF;
        final int g = (argbInt >> 16) & 0xFF;
        final int b = (argbInt >> 8) & 0xFF;

        // Add the color values to the buckets and increment the pixel count
        redBucket += r;
        greenBucket += g;
        blueBucket += b;
        pixelCount++;
      }
    }

    // Calculate the average color values
    final avgRed = redBucket ~/ pixelCount;
    final avgGreen = greenBucket ~/ pixelCount;
    final avgBlue = blueBucket ~/ pixelCount;

    return Color.fromARGB(255, avgRed, avgGreen, avgBlue);
  }
}

class CachedImageInfo {
  final Color color;
  final int widthPixels;
  final int heightPixels;

  CachedImageInfo(this.color, this.widthPixels, this.heightPixels);
}
