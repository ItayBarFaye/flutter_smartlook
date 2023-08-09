import 'package:flutter_smartlook/wireframe/widget_scraper/abstract_widget_scraper.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/dummy_widget_scraper.dart';

import 'package:flutter_smartlook/wireframe/widget_scraper/widget_scraper_factory.dart';

class WidgetScraperFactoryMobile implements WidgetScraperFactory {
  @override
  AbstractWidgetScraper createWidgetScraper() {
    return DummyWidgetScraper();
  }
}
