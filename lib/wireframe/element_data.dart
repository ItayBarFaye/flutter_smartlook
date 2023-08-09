import 'package:flutter/material.dart';

class ElementData {
  String id;
  String type;
  List<ElementData>? children;
  List<Skeleton>? skeletons;
  Rect rect;
  double opacity;
  bool isSensitive;
  bool doNotRecordWireframe;
  int? nativeViewId;

  ElementData({
    required this.id,
    required this.type,
    this.children,
    this.skeletons,
    required this.rect,
    this.opacity = 1.0,
    this.isSensitive = false,
    this.doNotRecordWireframe = false,
    this.nativeViewId,
  });

  void printElementData(ElementData elementData, {int level = 0}) {
    if (level == 0) {
      debugPrint("--------------------");
    }
    debugPrint(
      "\nElementData- id:${elementData.id}, type:${elementData.type}, ${elementData.rect} ${elementData.opacity} ${elementData.isSensitive} ${elementData.doNotRecordWireframe}",
    );
    if (elementData.children != null) {
      for (final child in elementData.children!) {
        printElementData(child, level: level + 1);
      }
    }
  }

  void addAncestorOpacity(double theOpacity) {
    this.opacity = this.opacity * theOpacity;
  }

  void addChildren(ElementData elementData) {
    if (this.children == null) {
      this.children = [];
    }
    this.children!.add(elementData);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        if (nativeViewId != null) "nativeViewId": nativeViewId,
        "type": type,
        if (children != null)
          "children": children?.map((e) => e.toMap()).toList(),
        if (skeletons != null)
          "skeletons": skeletons?.map((e) => e.toMap()).toList(),
        "top": rect.top,
        "left": rect.left,
        "width": rect.width,
        "height": rect.height,
        if (opacity != 1.0) "opacity": opacity,
        if (isSensitive) "isSensitive": isSensitive,
      };
}

class ElementDataNullable {
  final ElementData? elementData;
  final bool doNotRecordWireframeChildren;

  const ElementDataNullable({
    this.elementData,
    this.doNotRecordWireframeChildren = false,
  });
}

class Skeleton {
  late final Rect rect;
  late final Color color;
  late final double opacity;
  late final bool? isText;

  Skeleton({
    required this.rect,
    required this.color,
    this.opacity = 1.0,
    this.isText,
  });

  Skeleton.withOffsetAndCrop(
    Skeleton skeleton,
    Rect? parentRect,
    Offset offset,
  ) {
    if (parentRect != null)
      this.rect = skeleton.rect.shift(offset).intersect(parentRect);
    else
      this.rect = skeleton.rect.shift(offset);

    this.isText = skeleton.isText;
    this.color = skeleton.color;
    this.opacity = skeleton.opacity;
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "top": rect.top,
        "left": rect.left,
        "width": rect.width,
        "height": rect.height,
        "color": color.toHex(),
        if (opacity != 1.0) "opacity": opacity,
        if (isText != null) "isText": isText,
      };
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
