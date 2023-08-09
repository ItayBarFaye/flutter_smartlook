import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/src/enum.dart';

class SmartlookState {
  const SmartlookState();

  /// Get [RecordingStatus]
  /// - [RecordingStatus.recording] is returned when recording.
  /// - [RecordingStatus.not_started] is returned when not started.
  /// - [RecordingStatus.stopped] is returned when stopped and already started.
  /// - other values indicate an issue.
  Future<RecordingStatus> getRecordingStatus() async {
    final int status =
        await Channels.channel.invokeMethodOnMobile<int>('getRecordingStatus') as int;

    return RecordingStatus.values[status];
  }

  /// Get adaptive frame rate isEnabled.
  Future<bool> getAdaptiveFrameRateEnabled() async {
    final bool isAdaptiveFrameRateEnabled = await Channels.channel
        .invokeMethodOnMobile<bool>('getAdaptiveFrameRateEnabled') as bool;

    return isAdaptiveFrameRateEnabled;
  }

  /// Get surface capture isEnabled - only for Android.
  Future<bool> getSurfaceCaptureEnabled() async {
    final bool isSurfaceCaptureEnabled = await Channels.channel
        .invokeMethodOnMobile<bool>('getSurfaceCaptureEnabled') as bool;

    return isSurfaceCaptureEnabled;
  }

  /// Get project key which is set.
  Future<String?> getProjectKey() async {
    final String? projectKey =
        await Channels.channel.invokeMethodOnMobile<String?>('getProjectKey');

    return projectKey;
  }

  /// Get used frame rate.
  Future<int> getFrameRate() async {
    final int frameRate =
        await Channels.channel.invokeMethodOnMobile<int>('getStateFrameRate') as int;

    return frameRate;
  }

  /// Get [RenderingMode] which is used.
  /// [RenderingMode.native] or [RenderingMode.no_rendering]
  Future<RenderingMode> getRenderingMode() async {
    final int renderingMode =
        await Channels.channel.invokeMethodOnMobile<int>('getRenderingMode') as int;

    return RenderingMode.values[renderingMode];
  }
}
