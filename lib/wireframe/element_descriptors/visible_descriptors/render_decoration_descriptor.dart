import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/utils.dart';

class RenderDecorationDescriptor extends VisibleElementDescriptor {
  const RenderDecorationDescriptor();

  @override
  List<Skeleton> createSkeletons(
    Element element,
    Rect elementRect,
    Rect? parentRect,
  ) {
    final List<Skeleton> skeletons = [];
    final BorderSide? borderSide = getBorderSide(element);
    if (borderSide == null) {
      return skeletons;
    }
    final backgroundSkeleton = createBackgroundSkeleton(
      element,
      elementRect,
      borderSide.width,
    );

    final borderSkeleton = WireframeUtils.skeletonsFromBorderRect(
      elementRect,
      borderSide.color,
      borderSide.width,
    );
    if (borderSkeleton != null) {
      skeletons.addAll(borderSkeleton);
    }

    if (backgroundSkeleton != null) {
      skeletons.add(backgroundSkeleton);
    }

    return skeletons;
  }

  Skeleton? createBackgroundSkeleton(
    Element element,
    Rect elementRect,
    double width,
  ) {
    final double lineWidth = width;
    final Rect parentRectWithBorder = Rect.fromLTWH(
      elementRect.left + lineWidth,
      elementRect.top + lineWidth,
      elementRect.width - lineWidth,
      elementRect.height - lineWidth,
    );
    final Color? color = (element.renderObject as dynamic)
        ?.decoration
        ?.container
        ?.fillColor as Color?;
    if (color == null) {
      return null;
    }

    return Skeleton(
      color: color,
      opacity: color.alpha / 0xFF,
      rect: parentRectWithBorder,
    );
  }

  BorderSide? getBorderSide(Element element) {
    return (element.renderObject as dynamic)
        ?.decoration
        ?.container
        ?.border
        ?.borderSide as BorderSide?;
  }
}
