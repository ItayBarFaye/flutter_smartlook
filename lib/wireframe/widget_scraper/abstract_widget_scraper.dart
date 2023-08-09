import 'package:flutter/material.dart';

import '../element_data.dart';

abstract class AbstractWidgetScraper {
  ElementData? scrapeRenderTree(
      BuildContext context,
      Map<Type, bool> sensitiveWidgetsTypes,
      );
}
