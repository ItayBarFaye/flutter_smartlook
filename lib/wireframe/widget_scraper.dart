import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';

import 'widget_scraper/abstract_widget_scraper.dart';
import 'element_descriptors/descriptors.dart';

class WidgetScraper extends AbstractWidgetScraper {
  final Map<String, DefaultElementDescriptor> descriptors =
      DescriptorsConst.descriptorsMap;

  late ElementData rootElementData;

  /// gets data from all visible objects inside a tree
  @override
  ElementData? scrapeRenderTree(
    BuildContext context,
    Map<Type, bool> sensitiveWidgetsTypes,
  ) {
    final firstElement = getRootElement(context);
    if (firstElement == null) {
      return null;
    }

    final firstElementData =
        getFirstElementDataFromElement(firstElement, "Root object");
    if (firstElementData == null) {
      return null;
    }

    rootElementData = firstElementData;

    scrapeAllElements(
      rootElementData,
      firstElement,
      false,
      sensitiveWidgetsTypes,
    );

    return rootElementData;
  }

  ElementData? getFirstElementDataFromElement(
    Element theElement,
    String type, {
    bool isSensitive = false,
  }) {
    final renderObject = theElement.renderObject;
    if (renderObject is RenderBox && renderObject.hasSize) {
      final offset = renderObject.localToGlobal(Offset.zero);
      final top = offset.dy;
      final left = offset.dx;

      return ElementData(
        id: theElement.hashCode.toString(),
        type: type,
        rect: Rect.fromLTWH(
          left,
          top,
          renderObject.size.width,
          renderObject.size.height,
        ),
        opacity: 1.0,
        isSensitive: isSensitive,
      );
    }

    return null;
  }

  void scrapeAllElements(
    ElementData activeElementData,
    Element element,
    bool isSensitive,
    Map<Type, bool> sensitiveWidgetsTypes,
  ) {
    //todo create option for people using something else than [RenderBox]     //if (renderObject is RenderBox) {
    ElementData? newElementData;
    bool elementIsSensitive = isSensitive;

    // element has its own render object to create skeleton from
    if (element is RenderObjectElement) {
      //do not merge ifs. [element.renderObject] getter is not instant
      final elementDataNullable =
          describeRenderObject(activeElementData, element, isSensitive, () {
        elementIsSensitive = false;
      });

      if (elementDataNullable.doNotRecordWireframeChildren) {
        return;
      }
      newElementData = elementDataNullable.elementData;
    } else if (element.widget is SmartlookTrackingWidget) {
      final trackingWidget = element.widget as SmartlookTrackingWidget;

      if (trackingWidget.doNotRecordWireframe) {
        final ElementData? elementData = getFirstElementDataFromElement(
          element,
          "doNotRecordWireframe",
          isSensitive: true,
        );

        if (elementData != null) {
          activeElementData.addChildren(elementData);
        }

        return;
      }

      if (trackingWidget.isSensitive) {
        //todo solve case when there is no render object below
        elementIsSensitive = true;
      }
    } else if (sensitiveWidgetsTypes[element.widget.runtimeType] == true) {
      elementIsSensitive = true;
    }

    element.debugVisitOnstageChildren((thisElement) {
      scrapeAllElements(
        newElementData ?? activeElementData,
        thisElement,
        elementIsSensitive,
        sensitiveWidgetsTypes,
      );
    });
  }

  ElementDataNullable describeRenderObject(
    ElementData activeElementData,
    Element element,
    bool isSensitive,
    Function() changeSensitivity,
  ) {
    if (element.renderObject is RenderBox) {
      final String dataType = element.renderObject.runtimeType.toString();
      if (descriptors.containsKey(dataType)) {
        final elementDataNullable =
            descriptors[dataType]!.describe(element, activeElementData.rect);

        if (elementDataNullable.elementData == null) {
          return elementDataNullable;
        }

        elementDataNullable.elementData!.isSensitive = isSensitive;
        changeSensitivity();
        activeElementData.addChildren(elementDataNullable.elementData!);

        return elementDataNullable;
      }
    }

    return const ElementDataNullable();
  }

  Element? getRootElement(BuildContext buildContext) {
    Element? firstElement;
    if (ModalRoute.of(buildContext)?.isActive ?? false) {
      Navigator.of(buildContext, rootNavigator: true)
          .context
          .visitChildElements((element) {
        firstElement = element;
      });
    } else {
      buildContext.visitChildElements((element) {
        firstElement = element;
      });
    }

    return firstElement;
  }
}
