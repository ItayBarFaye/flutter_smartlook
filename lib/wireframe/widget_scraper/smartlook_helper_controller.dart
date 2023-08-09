import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';

import 'abstract_widget_scraper.dart';
import 'abstract_widget_scraper_factory.dart';

class SmartlookHelperController {
  SmartlookHelperController._privateConstructor();

  static final SmartlookHelperController instance =
      SmartlookHelperController._privateConstructor();

  static bool isTransitioningState = false;

  final GlobalKey containerKey = GlobalKey();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AbstractWidgetScraper _widgetScraper = createWidgetScraper();

  static void changeTransitioningState(bool isTransitioning) {
    if (isTransitioning == SmartlookHelperController.isTransitioningState) {
      return;
    }

    SmartlookHelperController.isTransitioningState = isTransitioning;
    Channels.channel.invokeMethod<void>(
      "changeTransitioningState",
      {"transitioningState": isTransitioning},
    );
  }

  Future<ElementData?> getWireframeTree(
    Map<Type, bool> sensitiveWidgetsTypes,
  ) async {
    final BuildContext? context = containerKey.currentContext;

    if (context == null) {
      return null;
    }

    return _widgetScraper.scrapeRenderTree(context, sensitiveWidgetsTypes);
  }
}
