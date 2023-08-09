import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/src/enum.dart';
import 'package:flutter_smartlook/src/preferences/event_tracking.dart';

/// Preferred configuration. The entered values represent
/// only the preferred configuration.
/// The resulting state may be different according to your account settings.
class SmartlookPreferences {
  SmartlookPreferences();
  final EventTracking eventTracking = const EventTracking();

  /// Sets a [projectKey] of your project.
  Future<void> setProjectKey(String projectKey) async {
    await Channels.channel.invokeMethodOnMobile<void>('setProjectKey', {
      "projectKey": projectKey,
    });
  }

  /// Set preferred [frameRate] for a recording.
  Future<void> setFrameRate(int frameRate) async {
    await Channels.channel.invokeMethodOnMobile<void>('setFrameRate', {
      "frameRate": frameRate,
    });
  }

  /// Get preferred frame rate of a recording.
  Future<int?> getFrameRate() async {
    final int? frameRate =
        await Channels.channel.invokeMethodOnMobile<int?>('getPreferencesFrameRate');

    return frameRate;
  }

  /// Set rendering mode: [RenderingMode.native], [RenderingMode.no_rendering].
  Future<void> setRenderingMode(RenderingMode renderingMode) async {
    await Channels.channel.invokeMethodOnMobile<void>('setRenderingMode', {
      "renderingMode": renderingMode.index,
    });
  }

  /// Already set to false, should not be changed.
  Future<void> setAdaptiveFrameRateEnabled(bool value) async {
    await Channels.channel.invokeMethodOnMobile<void>('setAdaptiveFrameRateEnabled', {
      "adaptiveStatus": value,
    });
  }

  /// Already set to true, should not be changed.
  /// only for Android
  Future<void> setSurfaceCaptureEnabled(bool value) async {
    await Channels.channel.invokeMethodOnMobile<void>('setSurfaceCaptureEnabled', {
      "surfaceStatus": value,
    });
  }
}
