import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/canvas_descriptor.dart';

class RenderCustomPaintDescriptor extends VisibleElementDescriptor {
  final Map<int, List<Skeleton>> painterSkeletonCache = {};

  RenderCustomPaintDescriptor();

  @override
  List<Skeleton> createSkeletons(
    Element element,
    Rect elementRect,
    Rect? parentRect,
  ) {
    if (!(element.renderObject as RenderBox).hasSize) {
      return [];
    }
    final int hashcode = element.renderObject.hashCode;

    final List<Skeleton> skeletons = [];
    final CustomPainter? painter =
        (element.renderObject as RenderCustomPaint).painter;

    if (painter != null) {
      skeletons.addAll(
        createSkeletonsFromPainter(element, parentRect, painter, hashcode),
      );
    }

    final CustomPainter? foregroundPainter =
        (element.renderObject as RenderCustomPaint).foregroundPainter;

    if (foregroundPainter != null &&
        foregroundPainter.runtimeType.toString() != "_InputBorderPainter") {
      skeletons.addAll(
        createSkeletonsFromPainter(
          element,
          parentRect,
          foregroundPainter,
          hashcode,
        ),
      );
    }

    return skeletons;
  }

  List<Skeleton> createSkeletonsFromPainter(
    Element element,
    Rect? parentRect,
    CustomPainter painter,
    int hashcode,
  ) {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.PictureRecorder picRec2 = ui.PictureRecorder();

    if (painterSkeletonCache[hashcode] == null) {
      painterSkeletonCache[hashcode] = [];
      final Canvas _canvas = CustomCanvas(pictureRecorder, (rect, color) {
        if (color != null) {
          painterSkeletonCache[hashcode]!.add(
            Skeleton(rect: rect, color: color, opacity: color.alpha / 0xFF),
          );
        }
      });
      final Canvas anotherCanvas = Canvas(picRec2);
      _canvas.save();
      painter.paint(_canvas, (element.renderObject as RenderCustomPaint).size);
      _canvas.restore();
      final picture = pictureRecorder.endRecording();
      anotherCanvas.drawPicture(picture);
    }

    return skeletonsWithOffset(
      element.renderObject as RenderBox,
      parentRect,
      hashcode,
    );
  }

  List<Skeleton> skeletonsWithOffset(
    RenderBox renderBox,
    Rect? parentRect,
    int hashcode,
  ) {
    final offset = renderBox.localToGlobal(Offset.zero);
    final List<Skeleton> skeletonsWithOffset = [];

    for (final skeleton in painterSkeletonCache[hashcode]!) {
      skeletonsWithOffset
          .add(Skeleton.withOffsetAndCrop(skeleton, parentRect, offset));
    }

    return skeletonsWithOffset;
  }
}
