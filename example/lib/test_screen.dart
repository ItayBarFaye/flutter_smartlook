import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook_example/test_manager.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TestManager testManager = TestManager();
  Size containerSize = const Size(50, 50);
  GlobalKey key = GlobalKey(); // declare a global key

  @override
  void initState() {
    super.initState();
    //just to make recordingMask visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeContainerSize(0);
    });
  }

  @override
  void dispose() {
    Smartlook.instance.setRecordingMask(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Screen")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await testManager.testEventTracking();
                  },
                  child: const Text('Event tracking'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await testManager.testEventProperties();
                  },
                  child: const Text('Event properties'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await testManager.testUser();
                  },
                  child: const Text('User'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await testManager.testPreferences();
                  },
                  child: const Text('Preferences'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await testManager.testState();
                  },
                  child: const Text('State'),
                ),

                ElevatedButton(
                  onPressed: () {
                    //TODO test what you need
                  },
                  child: const Text('Custom button'),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await changeContainerSize(-10);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await changeContainerSize(10);
                        setState(() {});
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                // comparison recording mask vs sensitivity
                // sensitivity is most of the cases a better solution
                // if sensitivity is not possible to set up then prefer recording mask
                Container(
                  key: key,
                  height: containerSize.height,
                  width: containerSize.width,
                  color: Colors.amber,
                ),
                SmartlookTrackingWidget(
                  isSensitive: true,
                  child: Container(
                    height: containerSize.height,
                    width: containerSize.width,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeContainerSize(int changeVal) async {
    containerSize =
        Size(containerSize.width + changeVal, containerSize.height + changeVal);
    if (key.currentContext == null) {
      return;
    }

    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final Offset position =
        box.localToGlobal(Offset.zero); //this is global position
    final double x = position.dx;
    final double y = position.dy;

    await Smartlook.instance.setRecordingMask([
      RecordingMask(
        rect: Rect.fromLTWH(
          x, //* window.devicePixelRatio,
          y, //* window.devicePixelRatio,
          containerSize.width, //* window.devicePixelRatio,
          containerSize.height,
        ), //* window.devicePixelRatio),
        maskType: RecordingMaskType.covering,
      ),
    ]);
  }
}
