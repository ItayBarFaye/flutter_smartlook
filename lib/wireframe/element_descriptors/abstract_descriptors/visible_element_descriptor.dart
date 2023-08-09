import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/default_element_descriptor.dart';

abstract class VisibleElementDescriptor extends DefaultElementDescriptor {
  const VisibleElementDescriptor();

  @override
  ElementDataNullable describe(Element element, Rect? parentRect) {
    final elementRect = createIntersectedRect(element, parentRect);
    if (elementRect == null) {
      return const ElementDataNullable(doNotRecordWireframeChildren: false);
    }
    if (elementRect.height < 0.0 || elementRect.width < 0.0) {
      return const ElementDataNullable(doNotRecordWireframeChildren: true);
    }

    final thisElementData = ElementData(
      id: "_${element.hashCode.toString()}",
      type: element.widget.runtimeType.toString(),
      rect: elementRect,
      skeletons: createSkeletons(element, elementRect, parentRect),
    );

    return ElementDataNullable(elementData: thisElementData);
  }

  List<Skeleton> createSkeletons(
    Element element,
    Rect elementRect,
    Rect? parentRect,
  ) {
    final Color? color = createColor(element);
    if (color == null) {
      return [];
    }

    return [
      Skeleton(color: color, rect: elementRect, opacity: color.alpha / 0xFF),
    ];
  }

  Color? createColor(Element element) {
    return (element.renderObject as dynamic)?.color as Color?;
  }
}
