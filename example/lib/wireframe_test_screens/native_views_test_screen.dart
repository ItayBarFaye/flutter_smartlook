import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart'
    as native_text_input;
import 'package:flutter_smartlook_example/wireframe_test_screens/text_test_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NativeViewsTestScreen extends StatefulWidget {
  const NativeViewsTestScreen({Key? key}) : super(key: key);

  @override
  State<NativeViewsTestScreen> createState() =>
      _NativeViewsTestScreenTestScreenState();
}

class _NativeViewsTestScreenTestScreenState
    extends State<NativeViewsTestScreen> {
  bool switchValue = false;

  HeadlessInAppWebView? headlessWebView;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          androidId: 1,
          iosId: "1",
          title: "Special",
          action: () async {
            debugPrint("Menu item Special clicked!");
            debugPrint(await webViewController?.getSelectedText());
            await webViewController?.clearFocus();
          },
        ),
      ],
      options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {
        debugPrint("onCreateContextMenu");
        debugPrint(hitTestResult.extra);
        final selectedText = await webViewController?.getSelectedText();
        debugPrint(selectedText);
      },
      onHideContextMenu: () {
        debugPrint("onHideContextMenu");
      },
      onContextMenuActionItemClicked: (contextMenuItemClicked) {
        final id = (Platform.isAndroid)
            ? contextMenuItemClicked.androidId
            : contextMenuItemClicked.iosId;
        debugPrint("onContextMenuActionItemClicked: " +
            id.toString() +
            " " +
            contextMenuItemClicked.title);
      },
    );

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
            urlRequest: URLRequest(
              url: await webViewController?.getUrl(),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}",
                  ),
                ),
                Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const WireframeTextTestScreen(),
                        ),
                      );
                    },
                    child: const Text('Alignment'),
                  );
                }),
                InkWell(
                  child: Container(
                    height: 400,
                    width: 500,
                    color: Colors.blue,
                  ),
                  onTap: () async {
                    const url = 'https://www.example.com';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                native_text_input.NativeTextInput(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  minHeightPadding: 4,
                  textCapitalization: TextCapitalization.sentences,
                  placeholder: "placeholder",
                  placeholderColor: Colors.black12,
                  iosOptions: native_text_input.IosOptions(
                    autocorrect: true,
                    cursorColor: Colors.black87,
                    keyboardAppearance: Brightness.dark,
                    placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  keyboardType: native_text_input.KeyboardType.defaultType,
                ),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: InAppWebView(
                    key: webViewKey,
                    // contextMenu: contextMenu,
                    initialUrlRequest: URLRequest(
                      url: Uri.parse("https://github.com/flutter"),
                    ),
                    // initialFile: "assets/index.html",
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      final uri = navigationAction.request.url!;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about",
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          // Launch the App
                          await launchUrl(
                            uri,
                          );

                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      debugPrint(consoleMessage as String?);
                    },
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: WebViewWidget(
                        controller: WebViewController()
                          ..loadRequest(
                            Uri.parse('https://google.com'),
                          ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: WebViewWidget(
                        controller: WebViewController()
                          ..loadRequest(
                            Uri.parse('https://flutter.dev'),
                          ),
                      ),
                    ),
                    native_text_input.NativeTextInput(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black87,
                          width: 2,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      minHeightPadding: 4,
                      textCapitalization: TextCapitalization.sentences,
                      placeholder: "placeholder",
                      placeholderColor: Colors.black12,
                      iosOptions: native_text_input.IosOptions(
                        autocorrect: true,
                        cursorColor: Colors.black87,
                        keyboardAppearance: Brightness.dark,
                        placeholderStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: native_text_input.KeyboardType.defaultType,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 300,
                  child: MapSample(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _controller.complete,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
