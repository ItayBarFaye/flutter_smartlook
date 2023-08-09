import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/not_visible_element_descriptor.dart';

class RenderOpacityDescriptor extends NotVisibleElementDescriptor {
  const RenderOpacityDescriptor();

  @override
  ElementDataNullable describe(Element element, Rect? parentRect) {
    final opacity = (element.renderObject as RenderOpacity).opacity;
    if (opacity == 1.0) {
      return const ElementDataNullable();
    }

    final elementRect = createIntersectedRect(element, parentRect);
    if (elementRect == null) {
      return const ElementDataNullable();
    }
    if (elementRect.height < 0.0 || elementRect.width < 0.0) {
      return const ElementDataNullable(doNotRecordWireframeChildren: true);
    }

    final thisElementData = ElementData(
      id: "_${element.hashCode.toString()}",
      type: element.widget.runtimeType.toString(),
      rect: elementRect,
      opacity: opacity,
    );

    return ElementDataNullable(elementData: thisElementData);
  }
}
