import 'abstract_widget_scraper.dart';
import 'widget_scraper_factory_web.dart'
    if (dart.library.io) 'widget_scraper_factory_mobile.dart';

AbstractWidgetScraper createWidgetScraper() {
  return WidgetScraperFactoryMobile().createWidgetScraper();
}
