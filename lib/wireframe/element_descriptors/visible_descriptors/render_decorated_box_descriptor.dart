import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';

class RenderDecoratedBoxDescriptor extends VisibleElementDescriptor {
  const RenderDecoratedBoxDescriptor();

  @override
  Rect? createElementRect(Element element, Rect? parentRect) {
    final RenderDecoratedBox renderDecoratedBox =
        element.renderObject as RenderDecoratedBox;
    if (!renderDecoratedBox.hasSize) {
      return null;
    }
    if (!(renderDecoratedBox.decoration is BoxDecoration)) {
      return null;
    }
    final BoxDecoration decoration =
        renderDecoratedBox.decoration as BoxDecoration;

    double renderBoxWidth = renderDecoratedBox.size.width;
    final double renderBoxHeight = renderDecoratedBox.size.height;
    if (decoration.shape == BoxShape.circle) {
      if (renderBoxWidth > renderBoxHeight) {
        renderBoxWidth = renderBoxHeight;
      }
    }

    final offset = renderDecoratedBox.localToGlobal(Offset.zero);
    double? top = offset.dy;
    double? left = offset.dx;

    const AlignmentGeometry? alignment = Alignment.center;

    if (alignment == Alignment.centerLeft ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.topLeft) {
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.topRight) {
      left = offset.dx + renderDecoratedBox.size.width - renderBoxWidth;
    } else {
      left = offset.dx + (renderDecoratedBox.size.width - renderBoxWidth) / 2;
    }

    if (alignment == Alignment.topLeft ||
        alignment == Alignment.topCenter ||
        alignment == Alignment.topRight) {
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomCenter) {
      top = offset.dy + renderDecoratedBox.size.height - renderBoxHeight;
    } else {
      top = offset.dy + (renderDecoratedBox.size.height - renderBoxHeight) / 2;
    }

    return Rect.fromLTWH(
      left,
      top,
      renderBoxWidth,
      renderBoxHeight,
    );
  }

  @override
  Color? createColor(Element element) {
    final decoratedBox = element.renderObject as RenderDecoratedBox;
    if (decoratedBox.decoration is BoxDecoration) {
      return (decoratedBox.decoration as BoxDecoration).color;
    }

    return null;
  }
}
