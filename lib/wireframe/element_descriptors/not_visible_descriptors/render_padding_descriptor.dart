import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/not_visible_element_descriptor.dart';

class RenderPaddingDescriptor extends NotVisibleElementDescriptor {
  const RenderPaddingDescriptor();

  @override
  Rect? createElementRect(Element element, Rect? parentRect) {
    final RenderPadding renderPadding = element.renderObject as RenderPadding;
    if ((!renderPadding.hasSize) || renderPadding.size.isEmpty) {
      return null;
    }

    double? leftInset;
    double? topInset;
    double? rightInset;
    double? bottomInset;

    if (renderPadding.padding is EdgeInsets) {
      final EdgeInsets insets = renderPadding.padding as EdgeInsets;
      leftInset = insets.left;
      topInset = insets.top;
      rightInset = insets.right;
      bottomInset = insets.bottom;
    } else if (renderPadding.padding is EdgeInsetsDirectional) {
      final EdgeInsetsDirectional insets =
          renderPadding.padding as EdgeInsetsDirectional;
      leftInset = insets.start;
      topInset = insets.top;
      rightInset = insets.end;
      bottomInset = insets.bottom;
    }

    if (leftInset == null ||
        topInset == null ||
        rightInset == null ||
        bottomInset == null) {
      return null;
    }

    final offset = renderPadding.localToGlobal(Offset.zero);
    final topOffset = offset.dy;
    final leftOffset = offset.dx;
    final leftWithPadding = leftOffset + leftInset;
    final topWithPadding = topOffset + topInset;

    final elementRect = Rect.fromLTWH(
      leftWithPadding,
      topWithPadding,
      (renderPadding.size.width) - rightInset - leftInset,
      (renderPadding.size.height) - bottomInset - topInset,
    );

    return elementRect;
  }
}
