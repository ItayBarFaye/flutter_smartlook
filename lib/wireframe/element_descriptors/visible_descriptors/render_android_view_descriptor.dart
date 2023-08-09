import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';

class RenderAndroidViewDescriptor extends VisibleElementDescriptor {
  const RenderAndroidViewDescriptor();

  @override
  ElementDataNullable describe(Element element, Rect? parentRect) {
    final Rect? elementRect = createIntersectedRect(element, parentRect);
    if (elementRect == null) {
      return const ElementDataNullable(doNotRecordWireframeChildren: false);
    }
    if (elementRect.height < 0.0 || elementRect.width < 0.0) {
      return const ElementDataNullable(doNotRecordWireframeChildren: true);
    }
    final androidView = element.renderObject as RenderAndroidView;
    final androidViewId = androidView.controller.viewId;
    final thisElementData = ElementData(
      id: "id_0x${androidViewId.toRadixString(16)}",
      type: element.widget.runtimeType.toString(),
      rect: elementRect,
      nativeViewId: androidViewId,
    );

    return ElementDataNullable(elementData: thisElementData);
  }
}
