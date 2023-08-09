import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';

//todo invalidace cache

class RenderParagraphDescriptor extends VisibleElementDescriptor {
  RenderParagraphDescriptor();

  final Map<int, CachedTextInfo> lineMetricsCache = {};

  @override
  List<Skeleton> createSkeletons(
    Element element,
    Rect elementRect,
    Rect? parentRect,
  ) {
    final double leftPaddingElement = elementRect.left;
    final double topPaddingElement = elementRect.top;
    final List<Skeleton> textSkeletons = [];
    final text = (element.renderObject as dynamic).text as TextSpan;
    double leftPosition = 0;
    double topPosition = 0;
    int lineCounter = 0;
    final Map<int, double> lineAscent = {};
    final Map<int, double> lineDescent = {};
    final Map<int, List<TextRect>> textRows = {};

    void createTextSkeleton(TextSpan iterateText, TextStyle? rootStyle) {
      late final List<ui.LineMetrics>? lines;
      late final TextSpan theText;
      final int hashcode = iterateText.hashCode;
      final cacheData = lineMetricsCache[hashcode];
      if (cacheData != null) {
        lines = cacheData.lines;
        theText = cacheData.textSpan;
      } else {
        if (lineMetricsCache.length > 800) {
          for (int i = 0; i < 500; i++)
            lineMetricsCache.remove(lineMetricsCache);
        }
        theText = TextSpan(text: iterateText.text, style: iterateText.style);
        final textPainter = TextPainter(
          text: theText,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
        );
        textPainter.layout();
        final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle());
        theText.build(paragraphBuilder, textScaleFactor: 1.0); //todo scale
        final paragraph = paragraphBuilder.build();
        paragraph.layout(ui.ParagraphConstraints(
          width: element.size?.width ?? double.infinity,
        ));
        lines = paragraph.computeLineMetrics();
        lineMetricsCache[hashcode] = CachedTextInfo(lines, theText);
      }
      for (final line in lines) {
        int lastLine = 0;

        if (lastLine < line.lineNumber) {
          lineCounter++;
          lastLine++;
        } else if (elementRect.width < leftPosition + line.width) {
          lineCounter++;
        }
        lineDescent[lineCounter] ??= line.descent;
        lineDescent[lineCounter] = max(lineDescent[lineCounter]!, line.descent);
        lineAscent[lineCounter] ??= line.ascent.floorToDouble();
        lineAscent[lineCounter] =
            max(lineAscent[lineCounter]!, line.ascent.floorToDouble());
        if (line.width == 0 || line.height == 0) continue;
        if (textRows[lineCounter] == null) {
          leftPosition = 0;
          topPosition += lineDescent[lineCounter - 1] ?? 0;
          topPosition += lineAscent[lineCounter - 1] ?? 0;
          textRows[lineCounter] = [];
        }
        textRows[lineCounter]!.add(textRectFromLine(
          line,
          theText.style?.color ?? rootStyle?.color,
          leftPosition,
          topPosition,
        ));
        leftPosition += line.width;
      }
    }

    void iterateTextSpan(TextSpan theText) {
      for (final child in theText.children ?? <InlineSpan>[]) {
        if (child is TextSpan) {
          if ((child.style?.color ?? theText.style?.color) != null &&
              child.text != null) {
            createTextSkeleton(child, theText.style);
          }
          iterateTextSpan(child);
        }
      }
    }

    createTextSkeleton(text, null);
    iterateTextSpan(text);

    textRows.forEach((key, value) {
      for (final textRect in value) {
        if (lineAscent[key] == null) {
          continue;
        }
        if (textRect.color != null) {
          final Skeleton? skeleton = skeletonFromTextRect(
            textRect,
            leftPaddingElement,
            topPaddingElement,
            elementRect,
            lineAscent[key]!,
            elementRect,
          );
          if (skeleton != null) {
            textSkeletons.add(skeleton);
          }
        }
      }
    });

    return textSkeletons;
  }

  TextRect textRectFromLine(
    LineMetrics line,
    Color? color,
    double leftPosition,
    double topPosition,
  ) {
    return TextRect(
      color: color,
      leftPosition: leftPosition,
      topPosition: topPosition,
      lineLeft: line.left,
      lineDescent: line.descent,
      lineWidth: line.width,
      lineAscent: line.height - line.descent,
    );
  }

  Skeleton? skeletonFromTextRect(
    TextRect textRect,
    double leftPaddingElement,
    double topPaddingElement,
    Rect mainRect,
    double lineAscent,
    Rect elementRect,
  ) {
    final topValue = textRect.topPosition + topPaddingElement + lineAscent;
    final leftValue =
        leftPaddingElement + textRect.leftPosition + textRect.lineLeft;

    final Rect rect = Rect.fromLTRB(
      leftValue,
      topValue + textRect.lineDescent - textRect.lineAscent,
      leftValue + textRect.lineWidth,
      topValue + textRect.lineDescent,
    );

    final Rect intersectedRect =
        rect.intersect(mainRect).intersect(elementRect);

    if (intersectedRect.height < 0.0) {
      return null;
    }

    return Skeleton(
      rect: intersectedRect,
      color: textRect.color!,
      opacity: textRect.color!.alpha / 0xFF,
      isText: true,
    );
  }
}

class CachedTextInfo {
  final List<LineMetrics> lines;
  final TextSpan textSpan;

  CachedTextInfo(this.lines, this.textSpan);
}

class TextRect {
  final Color? color;
  final double leftPosition;
  final double topPosition;
  final double lineLeft;
  final double lineDescent;
  final double lineWidth;
  final double lineAscent;

  TextRect({
    required this.color,
    required this.leftPosition,
    required this.topPosition,
    required this.lineLeft,
    required this.lineDescent,
    required this.lineWidth,
    required this.lineAscent,
  });
}
