import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/src/enum.dart';
import 'package:flutter_smartlook/src/event_listeners.dart';
import 'package:flutter_smartlook/src/event_properties.dart';
import 'package:flutter_smartlook/src/log.dart';
import 'package:flutter_smartlook/src/preferences/preferences.dart';
import 'package:flutter_smartlook/src/properties.dart';
import 'package:flutter_smartlook/src/sensitivity.dart';
import 'package:flutter_smartlook/src/setup_configuration.dart';
import 'package:flutter_smartlook/src/state.dart';
import 'package:flutter_smartlook/src/user/user.dart';

/// Represents places on a screen to be hidden.
/// [rect] is used to set position and size.
///
///  [maskType] has different modes of hiding element.
///  - Areas with [RecordingMaskType.covering] will not be recorded.
///  - [RecordingMaskType.erasing] will be recorded even if marked
///  as [RecordingMaskType.covering] before in the list.
class RecordingMask {
  final Rect rect;
  final RecordingMaskType maskType;

  RecordingMask({required this.rect, required this.maskType});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'rect': _rectToJson(rect),
        'isCovering': maskType == RecordingMaskType.covering,
      };

  Map<String, double> _rectToJson(Rect rect) {
    return {
      'left': rect.left,
      'top': rect.top,
      'width': rect.width,
      'height': rect.height,
    };
  }
}

/// Smartlook SDK API is here and can be used with [Smartlook.instance].
class Smartlook {
  static final Smartlook _singleton = Smartlook._internal();

  /// Gets the only running instance of Smartlook SDK.
  static Smartlook get instance {
    return _singleton;
  }

  Smartlook._internal();

  final Sensitivity sensitivity = Sensitivity();
  final EventListeners eventListeners = EventListeners();
  final EventProperties eventProperties = const EventProperties();
  final SmartlookUser user = const SmartlookUser();
  final SmartlookPreferences preferences = SmartlookPreferences();
  final SmartlookState state = const SmartlookState();
  final SmartlookSetupConfiguration setupConfiguration =
      const SmartlookSetupConfiguration();
  final SmartlookLog log = const SmartlookLog();

  /// Sets a list of recording masks that disable recording specific areas.
  ///
  /// [recordingMaskList] is always set only one at the moment.
  /// Gets reset every time this method is called.
  /// [recordingMaskList] values description:
  ///  - Null which sets a mask to record everything.
  ///  - [List<RecordingMask>?] that takes elements which should be hidden
  ///  or visible. The order of elements is important!!!
  ///  For example if you hide a part with [RecordingMaskType.covering] and then
  ///  put another element on it with [RecordingMaskType.erasing]
  ///  it will be visible.
  Future<void> setRecordingMask(List<RecordingMask>? recordingMaskList) async {
    await Channels.channel.invokeListMethod<void>('setRecordingMask', {
      'maskList':
          recordingMaskList == null ? null : jsonEncode(recordingMaskList),
    });
  }

  /// Starts recording even without project key.
  Future<void> start() async {
    await Channels.channel.invokeMethodOnMobile<void>('start');
  }

  /// Stops recording.
  Future<void> stop() async {
    await Channels.channel.invokeMethodOnMobile<void>('stop');
  }

  /// Stops recording and resets preferences and
  /// setupConfiguration into the default state.
  /// Used for testing or special cases.
  Future<void> reset() async {
    await Channels.channel.invokeMethodOnMobile<void>('reset');
  }

  /// Add a custom event with custom [name] being used as id.
  ///
  /// [properties] are stored as a key and value.
  /// [properties] can be used for tracking a state of an app
  /// when event was tracked.
  Future<void> trackEvent(
    String name, {
    Properties? properties,
  }) async {
    await Channels.channel.invokeMethodOnMobile<void>(
      'trackEvent',
      {
        'name': name,
        'properties': properties?.toJson(),
      },
    );
  }

  /// Add a custom navigation event on enter to a screen and track its [name].
  ///
  /// [properties] are stored as a key and value.
  /// [properties] can be used for tracking a state of an app
  /// when event was tracked.
  Future<void> trackNavigationEnter(
    String name, {
    Properties? properties,
  }) async {
    await Channels.channel.invokeMethodOnMobile<void>(
      'trackNavigationEnter',
      {
        'name': name,
        'properties': properties?.toJson(),
      },
    );
  }

  /// Add a custom navigation event on exit from a screen and track its [name].
  ///
  /// [properties] are stored as a key and value.
  /// [properties] can be used for tracking a state of an app
  /// when event was tracked.
  Future<void> trackNavigationExit(
    String name, {
    Properties? properties,
  }) async {
    await Channels.channel.invokeMethodOnMobile<void>(
      'trackNavigationExit',
      {
        'name': name,
        'properties': properties?.toJson(),
      },
    );
  }

  /// Set the application installation source.
  ///
  /// is Android only
  /// When an application is installed from the Google Play Store,
  /// Smartlook SDK automatically tracks install referrer
  /// A custom referrer can also be set by using the following
  /// Referrer value and source of installation are stored per visitor
  /// and can be viewed in the Smartlook Dashboard.
  Future<void> setReferrer(String referrer, String source) async {
    await Channels.channel.invokeMethodOnMobile<void>(
      'setReferrer',
      {'referrer': referrer, 'source': source},
    );
  }
}
