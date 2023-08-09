import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

class WireframeManager {
  final bool _isDebugMode;
  final Map<Type, bool> sensitiveWidgetsTypes = {
    TextField: true,
    TextFormField: true,
    RawMagnifier: true,
  };

  void addSensitiveWidgetsTypes(Type type, bool isSensitive) {
    sensitiveWidgetsTypes[type] = isSensitive;
  }

  WireframeManager(this._isDebugMode) {
    if (kIsWeb) {
      return;
    }

    if (!_isDebugMode) {
      Channels.channel.setMethodCallHandler(_sharedMethodCallHandler);
    } else {
      Channels.channel.setMethodCallHandler(_sharedDebugMethodCallHandler);
    }
  }

  Future<dynamic> _sharedMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getWireframe":

        final wireframeTree = await SmartlookHelperController.instance
            .getWireframeTree(sensitiveWidgetsTypes);

        final map = wireframeTree?.toMap();

        return map;

      default:
        return null;
    }
  }

  Future<dynamic> _sharedDebugMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getWireframe":
        print("------------------------------");
        final Stopwatch stopwatch = Stopwatch()..start();
        final wireframeTree = await SmartlookHelperController.instance
            .getWireframeTree(sensitiveWidgetsTypes);
        stopwatch.stop();
        print(
          "Getting wireframe tree took ${stopwatch.elapsedMilliseconds} ms",
        );
        final Stopwatch toMapStopwatch = Stopwatch()..start();
        final map = wireframeTree?.toMap();
        toMapStopwatch.stop();
        print(
          "Getting wireframe tree took ${toMapStopwatch.elapsedMilliseconds} ms",
        );

        return map;

      default:
        return null;
    }
  }
}
