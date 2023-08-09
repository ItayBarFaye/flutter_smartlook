import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class EventListeners {
  final userListeners = <Function(String)>[];
  final sessionListeners = <Function(String)>[];

  EventListeners() {
    setUpNativeListeners();
  }

  void registerUserChangedListener(Function(String) callback) {
    userListeners.add(callback);
  }

  void unregisterUserChangedListener(Function(String) callback) {
    userListeners.remove(callback);
  }

  void registerSessionChangedListener(Function(String) callback) {
    sessionListeners.add(callback);
  }

  void unregisterSessionChangedListener(Function(String) callback) {
    sessionListeners.remove(callback);
  }

  void setUpNativeListeners() {
    if(kIsWeb) {
      return;
    }

    Channels.eventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event == null) {
              return;
            }
            final String theEvent = event as String;
            if (theEvent.contains('visitor')) {
              for (final userListener in userListeners) {
                userListener(theEvent);
              }
            } else {
              for (final sessionListener in sessionListeners) {
                sessionListener(theEvent);
              }
            }
          } as void Function(dynamic event)?,
        );
  }
}
