import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook_example/test_screen.dart';
import 'package:flutter_smartlook_example/timer_widget.dart';
import 'package:flutter_smartlook_example/wireframe_test_screens/all_widgets_wireframe_test_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Smartlook smartlook = Smartlook.instance;
  bool isSet = false;

  @override
  void initState() {
    super.initState();
    initSmartlook();
  }

  Future<void> initSmartlook() async {
    //await smartlook.log.enableLogging();
    //TODO add your project key
    await smartlook.preferences
        .setProjectKey('');
    await smartlook.preferences.setFrameRate(2);
    await smartlook.start();

    setState(() {
      isSet = true;
    });
    smartlook.sensitivity.changeNativeClassSensitivity([
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WebView,
        isSensitive: true,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WKWebView,
        isSensitive: true,
      ),
    ]);
    /* await Smartlook.instance.setRecordingMask([
      RecordingMask(
        rect: const Rect.fromLTWH(0, 0, 200, 200),
        maskType: RecordingMaskType.covering,
      ),
    ]);*/
    Smartlook.instance.eventListeners.registerSessionChangedListener((_) {
      //TODO
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartlookRecordingWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [SmartlookObserver()],
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: !isSet
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Spacer(),
                      const TimerWidget(),
                      const SizedBox(height: 15.0),
                      FutureBuilder<RecordingStatus>(
                        future: smartlook.state.getRecordingStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == null ||
                              snapshot.data != RecordingStatus.recording) {
                            return ElevatedButton(
                              onPressed: () async {
                                await smartlook.start();
                                setState(() {});
                              },
                              child: const Text('Start recording'),
                            );
                          }

                          return ElevatedButton(
                            onPressed: () async {
                              await smartlook.stop();
                              setState(() {});
                            },
                            child: const Text('Stop recording'),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () async {
                          final Properties properties = Properties();
                          properties.putString('testKey', value: 'testValue');
                          smartlook.trackEvent(
                            'test_event',
                            properties: properties,
                          );
                          await smartlook.sensitivity
                              .changeNativeClassSensitivity(
                            [
                              SensitivityTuple(
                                classType:
                                    SmartlookNativeClassSensitivity.WebView,
                                isSensitive: false,
                              ),
                            ],
                          );
                        },
                        child: const Text('Track event'),
                      ),
                      const SizedBox(height: 15.0),
                      Builder(builder: (context) {
                        return SmartlookTrackingWidget(
                          child: ElevatedButton(
                            onPressed: () async {
                              smartlook.trackNavigationEnter('testscreen');
                              await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const TestScreen(),
                                ),
                              );
                              smartlook.trackNavigationExit('testscreen');
                            },
                            child: const Text('Navigate to TestScreen'),
                          ),
                          isSensitive: true,
                        );
                      }),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () async {
                            smartlook
                                .trackNavigationEnter('wireframe_testscreen');
                            await Navigator.push<dynamic>(
                                context,
                                PageRouteBuilder<dynamic>(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        WireframeAllWidgetsTestScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var begin = Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(seconds: 3)));

                            smartlook
                                .trackNavigationExit('wireframe_testscreen');
                          },
                          child: const Text('Navigate wireframe to TestScreen'),
                        );
                      }),
                      const Spacer(),
                      SizedBox(
                        height: 180,
                        child: WebViewWidget(
                          controller: WebViewController()
                            ..loadRequest(
                              Uri.parse('https://flutter.dev'),
                            )
                            ..setJavaScriptMode(
                              JavaScriptMode.unrestricted,
                            ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
