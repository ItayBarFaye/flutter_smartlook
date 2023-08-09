import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/abstract_widget_scraper.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';

class DummyWidgetScraper extends AbstractWidgetScraper {
  @override
  ElementData? scrapeRenderTree(
      BuildContext context, Map<Type, bool> sensitiveWidgetsTypes,) {
    return null;
  }
}
