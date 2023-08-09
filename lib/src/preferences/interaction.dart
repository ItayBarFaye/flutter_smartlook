import 'package:flutter_smartlook/src/const_channels.dart';

/// User interaction events like touch.
class Interaction {
  const Interaction();

  /// Enable track of user rage clicks
  Future<void> setRageClickEnabled(bool enabled) async {
    await Channels.channel
        .invokeMethodOnMobile<void>('setEventTrackingInteractionRageClickStatus', {
      "rageClick": enabled,
    });
  }

  /// Enable touch event
  Future<void> setTrackUserInteraction(bool enabled) async {
    await Channels.channel
        .invokeMethodOnMobile<void>('setEventTrackingInteractionUserStatus', {
      "track": enabled,
    });
  }
}
