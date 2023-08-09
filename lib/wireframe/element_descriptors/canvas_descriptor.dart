import 'dart:math';
import 'dart:ui';

import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/utils.dart';

class CustomCanvas extends Canvas {
  final Function(Rect, Color?) addSkeleton;

  CustomCanvas(
    PictureRecorder recorder,
    this.addSkeleton,
  ) : super(recorder);

  @override
  void drawRect(Rect rect, Paint paint) async {
    super.drawRect(rect, paint);
    addSkeleton(rect, paint.color);
    if (paint.shader is Gradient) {
      final Color? color = await getColorFromPaint(paint);
      addSkeleton(rect, color);
    }
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    super.drawCircle(c, radius, paint);
    addSkeleton(Rect.fromLTWH(c.dx, c.dy, radius, radius), paint.color);
  }

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) {
    super.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    addSkeleton(rect, paint.color);
  }

  @override
  void drawPath(Path path, Paint paint) {
    super.drawPath(path, paint);
    if (paint.style == PaintingStyle.fill) {
      addSkeleton(path.getBounds(), paint.color);
    } else {
      final List<Skeleton>? skeletons = WireframeUtils.skeletonsFromBorderRect(
        path.getBounds(),
        paint.color,
        paint.strokeWidth,
      );
      if (skeletons == null) {
        return;
      }
      for (final Skeleton skeleton in skeletons) {
        addSkeleton(skeleton.rect, skeleton.color);
      }
    }
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    super.drawLine(p1, p2, paint);
    addSkeleton(
      Rect.fromLTWH(
        0,
        0,
        max(p1.dx, p2.dx) - min(p1.dx, p2.dx),
        max(p1.dy, p2.dy) -
            min(
              p1.dy,
              p2.dy,
            ),
      ),
      paint.color,
    );
  }

  Color mixColors(List<Color> colors) {
    final int colorCount = colors.length;

    double red = 0;
    double green = 0;
    double blue = 0;
    double alpha = 0;

    for (final Color color in colors) {
      red += color.red;
      green += color.green;
      blue += color.blue;
      alpha += color.alpha;
    }

    return Color.fromARGB(
      (alpha / colorCount).round(),
      (red / colorCount).round(),
      (green / colorCount).round(),
      (blue / colorCount).round(),
    );
  }

  Future<Color?> getColorFromPaint(Paint paint) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    canvas.save();
    canvas.drawPaint(paint);
    canvas.restore();
    final picture = pictureRecorder.endRecording();
    final Image image = await picture.toImage(2, 2);
    final byteData = await image.toByteData();

    if (byteData == null) {
      return null;
    }

    return WireframeUtils.createColorFromByteData(
      byteData,
      image.height,
      image.width,
    );
  }
}
