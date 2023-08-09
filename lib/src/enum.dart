/// Used for [trackNavigationEvent]
enum SmartlookNavigationEventType { enter, exit }

/// Used to choose [RenderingMode] for a recording
enum RenderingMode { no_rendering, native, wireframe }

/// Used for creating [RecordingMask]
enum RecordingMaskType {
  covering,
  erasing,
}

/// These are the statuses of recording that can occur
/// either [recording], [stopped], [not_started] or some failure
enum RecordingStatus {
  recording,
  not_started,
  stopped,
  below_min_sdk_version,
  project_limit_reached,
  storage_limit_reached,
  internal_error,
}

/// sensitivity classes for Android and iOS elements
enum SmartlookNativeClassSensitivity {
  EditText,
  WebView,
  UITextView,
  UITextField,
  WKWebView,
}

/// Checks from the enums if is [RecordingStatus.recording]
/// if is recording and return [true] otherwise [false]
extension RecordingStatusExt on RecordingStatus {
  bool get isRecording {
    if (this == RecordingStatus.recording) {
      return true;
    }

    return false;
  }
}
