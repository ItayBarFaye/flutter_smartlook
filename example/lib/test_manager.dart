import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';

class TestManager {
  Smartlook smartlook = Smartlook.instance;

  Future<void> testEventTracking() async {
    await smartlook.trackEvent('test_event_tracking');
    await smartlook.trackNavigationEnter('mock_screen');
    await smartlook.trackNavigationExit('mock_screen');
  }

  Future<void> testEventProperties() async {
    final eventProperties = smartlook.eventProperties;
    await eventProperties.putString('test_key', value: 'test_value');
    final String? value = await eventProperties.getString('test_key');
    assert(value == 'test_value');
    await smartlook.eventProperties.removeString('test_key');
    final String? removedValue = await eventProperties.getString('test_key');
    assert(removedValue == null);
    await smartlook.eventProperties.putString('test_key', value: 'test_value');
    await smartlook.eventProperties.clear();
    final String? removedValueAfterClear =
        await eventProperties.getString('test_key');
    assert(removedValueAfterClear == null);
  }

  Future<void> testUser() async {
    final String? userUrl = await smartlook.user.getUrl();
    final userProperties = smartlook.user.properties;
    assert(userUrl != null);
    debugPrint("User URL: $userUrl");
    await smartlook.user.setName('tester_name');
    await smartlook.user.setEmail('tester_email');
    await userProperties.putString('test_key', value: 'test_value');
    final String? value = await userProperties.getString('test_key');
    assert(value == 'test_value');
    final userSession = smartlook.user.session;
    final String? url = await userSession.getUrl();
    debugPrint("Session URL: $url");
    final String? urlWithTimestamp = await userSession.getUrlWithTimeStamp();
    debugPrint("Session URL with timestamp: $urlWithTimestamp");
  }

  Future<void> testPreferences() async {
    ///already done
    //await smartlook.preferences.setRenderingMode(RenderingMode.native);
    //await smartlook.preferences.setWebViewEnabled(true)
    final eventTracking = smartlook.preferences.eventTracking;
    await eventTracking.disableAll();
    await eventTracking.enableAll();
    await eventTracking.restoreDefault();
    await eventTracking.interaction.setRageClickEnabled(true);
    await eventTracking.interaction.setTrackUserInteraction(true);
  }

  Future<void> testState() async {
    final int usedFrameRate = await smartlook.state.getFrameRate();
    debugPrint("Used frame rate: $usedFrameRate");
    final String? usedProjectKey = await smartlook.state.getProjectKey();
    debugPrint("Project key: $usedProjectKey");
    final RenderingMode usedRenderingMode =
        await smartlook.state.getRenderingMode();
    debugPrint("Rendering mode: $usedRenderingMode");
    final recordingStatus = await smartlook.state.getRecordingStatus();
    final bool isRecording = recordingStatus.isRecording;
    debugPrint("isRecording: $isRecording");
    final RecordingStatus usedRecordingStatus = recordingStatus;
    debugPrint("Recording status: $usedRecordingStatus");
  }

  final printUserCallback = (String message) {
    debugPrint("userUrl called: $message");
  };
  final printSessionCallback = (String message) {
    debugPrint("session Url called: $message");
  };

  void registerUrlListener() {
    smartlook.eventListeners.registerUserChangedListener(printUserCallback);
    smartlook.eventListeners
        .registerSessionChangedListener(printSessionCallback);
  }

  void unregisterListeners() {
    smartlook.eventListeners.unregisterUserChangedListener(printUserCallback);
    smartlook.eventListeners
        .unregisterSessionChangedListener(printSessionCallback);
  }

  Future<void> openNewSession() async {
    await smartlook.user.session.openNew();
  }

  Future<void> openNewUser() async {
    await smartlook.user.openNew();
  }

  void testSensitivity() {
    smartlook.sensitivity
        .changeWidgetClassSensitivity(classType: Text, isSensitive: true);
  }
}
