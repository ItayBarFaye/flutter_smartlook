import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';
import 'package:flutter_smartlook/wireframe/wireframe_manager.dart';

/**
 * The Sensitivity class provides methods to change the SDK's default class sensitivity behaviour.
 *
 * Some classes are set sensitive by default
 *
 * `Android`: `EditText, `WebView`.
 *
 * `iOS`: `UITextView`, `UITextField` and `WKWebView`.
 */
class Sensitivity {
  Sensitivity();

  final _wireframeManager = WireframeManager(false); //with false to production

  /// Pauses the recording of the screen for the moment of transition.
  /// Has to be switched off after the transition animation is finished
  void changeTransitioningState(bool isTransitioning) {
    SmartlookHelperController.changeTransitioningState(isTransitioning);
  }

  Future<void> enableDefaultNativeClassSensitivity() async {
    await changeNativeClassSensitivity([
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.EditText,
        isSensitive: true,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WebView,
        isSensitive: true,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.UITextView,
        isSensitive: true,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.UITextField,
        isSensitive: true,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WKWebView,
        isSensitive: true,
      ),
    ]);
  }

  Future<void> disableDefaultNativeClassSensitivity() async {
    await changeNativeClassSensitivity([
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.EditText,
        isSensitive: false,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WebView,
        isSensitive: false,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.UITextView,
        isSensitive: false,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.UITextField,
        isSensitive: false,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WKWebView,
        isSensitive: false,
      ),
    ]);
  }

  /**
      Smartlook.instance.sensitivity.changePlatformClassSensitivity([
      [SmartlookNativeClassSensitivity.UITextView, true],
      [SmartlookNativeClassSensitivity.UITextField, false],
      [SmartlookNativeClassSensitivity.WKWebView, false],
      [SmartlookNativeClassSensitivity.EditText, false],
      ]);
   **/
  Future<void> changeNativeClassSensitivity(
    List<SensitivityTuple> sensitivityTuples,
  ) async {
    //sensitivity is an integer 1 means it is sensitive 0 means it is not sensitive
    final List list = sensitivityTuples
        .map((e) => [e.classType.index, if (e.isSensitive) 1 else 0])
        .toList();
    await Channels.channel
        .invokeMethodOnMobile<void>('changePlatformClassSensitivity', {
      'sensitivity': list,
    });
  }

  /// Add a class to be considered sensitive or not. The class wont be visible on the recording.
  /// Classes set to sensitive by default are [TextField] and [TextFormField]
  void changeWidgetClassSensitivity({
    required Type classType,
    required bool isSensitive,
  }) {
    _wireframeManager.addSensitiveWidgetsTypes(classType, isSensitive);
  }
}
