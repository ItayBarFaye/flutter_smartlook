import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

extension MethodChannelMobile on MethodChannel {
  Future<T?> invokeMethodOnMobile<T>(String method, [ dynamic arguments ]) {
    if(kIsWeb) {
      return Future.value(null);
    }

    return this.invokeMethod(method, arguments);
  }
}

/// Native channels.
class Channels {
  static const MethodChannel channel = MethodChannel('smartlook');
  static const EventChannel eventChannel = EventChannel('smartlookEvent');
}

