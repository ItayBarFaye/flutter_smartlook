import 'package:flutter_smartlook/src/const_channels.dart';

/// Map of properties that are included in every event.
class EventProperties {
  const EventProperties();

  /// Put a [value] using [name] inside a map.
  Future<void> putString(String name, {String? value}) async {
    await Channels.channel.invokeMethodOnMobile<void>('putStringEventProperty', {
      "name": name,
      "value": value,
    });
  }

  /// Get a value from a map using a [name].
  Future<String?> getString(String name) async {
    final String? property =
        await Channels.channel.invokeMethodOnMobile<String?>('getStringEventProperty', {
      "name": name,
    });

    return property;
  }

  /// Remove a single value using a [name].
  Future<void> removeString(String name) async {
    await Channels.channel.invokeMethodOnMobile<void>('removeEventProperty', {
      "name": name,
    });
  }

  /// Remove all values from [EventProperties].
  Future<void> clear() async {
    await Channels.channel.invokeMethodOnMobile<void>('clearEventProperties');
  }
}
