#import "SmartlookPlugin.h"
#import <WebKit/WebKit.h>
#import <flutter_smartlook/flutter_smartlook-Swift.h>

@implementation SmartlookPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmartlookPlugin registerWithRegistrar:registrar];
}
@end
