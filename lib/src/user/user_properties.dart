import 'package:flutter_smartlook/src/const_channels.dart';

/// User's custom properties
class UserProperties {
  const UserProperties();

  /// Put a [value] using [key] inside a map.
  Future<void> putString(String name, {String? value}) async {
    await Channels.channel
        .invokeMethodOnMobile<void>('setUserProperty', {"name": name, "value": value});
  }

  /// Get a value from a map using a [name].
  Future<String?> getString(String name) async {
    final String? property = await Channels.channel
        .invokeMethodOnMobile<String?>('getUserProperty', {"name": name});

    return property;
  }

  /// Remove a single value using a [name].
  Future<void> removeString(String name) async {
    await Channels.channel
        .invokeMethodOnMobile<void>('removeUserProperty', {"name": name});
  }
}
