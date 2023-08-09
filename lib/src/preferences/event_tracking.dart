import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/src/preferences/interaction.dart';

/// Automatic event tracking preference.
class EventTracking {
  final Interaction interaction = const Interaction();
  const EventTracking();

  /// Enable tracking all detected events.
  Future<void> enableAll() async {
    await Channels.channel.invokeMethodOnMobile<void>('eventTrackingEnableAll');
  }

  /// Disable tracking all detected events.
  Future<void> disableAll() async {
    await Channels.channel.invokeMethodOnMobile<void>('eventTrackingDisableAll');
  }

  /// Restore default tracking.
  Future<void> restoreDefault() async {
    await Channels.channel.invokeMethodOnMobile<void>('restoreDefault');
  }
}
