import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook_example/wireframe_test_screens/single_widget_wireframe_test.dart';
import 'package:flutter_smartlook_example/wireframe_test_screens/text_test_screen.dart';

import 'alignment_test_screen.dart';
import 'high_number_of_widgets_screen.dart';
import 'image_test_screen.dart';
import 'infinite_scroll_wireframe_test_screen.dart';
import 'native_views_test_screen.dart';

class WireframeAllWidgetsTestScreen extends StatefulWidget {
  const WireframeAllWidgetsTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeAllWidgetsTestScreen> createState() =>
      _WireframeAllWidgetsTestScreenState();
}

class _WireframeAllWidgetsTestScreenState
    extends State<WireframeAllWidgetsTestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All widgets Test Screen")),
      backgroundColor: Colors.brown,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
              Wrap(
                children: [
                  Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const HighNumberOfWidgetsScreen(),
                          ),
                        );
                      },
                      child: const Text('Complex'),
                    );
                  }),
                  Builder(builder: (context) {
                    return SmartlookTrackingWidget(
                      isSensitive: true,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const WireframeSingleWidgetTestScreen(),
                            ),
                          );
                        },
                        child: const Text('Single'),
                      ),
                    );
                  }),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const WireframeTextTestScreen(),
                          ),
                        );
                      },
                      child: const Text('Text'),
                    );
                  }),
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const WireframeAlignmentTestScreen(),
                          ),
                        );
                      },
                      child: const Text('Alignment'),
                    );
                  }),
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const NativeViewsTestScreen(),
                          ),
                        );
                      },
                      child: const Text('Native views'),
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      _showMyDialog(context);
                    },
                    icon: const Icon(Icons.account_box_rounded),
                  ),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const WireframeImageTestScreen(),
                          ),
                        );
                      },
                      child: const Text('Image'),
                    );
                  }),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const InfiniteScrollScreen(),
                          ),
                        );
                      },
                      child: const Text('Infinite'),
                    );
                  }),
                ],
              ),
              // Containers
              Row(
                children: [
                  Tooltip(
                    message: "Test of tooltip",
                    child: Container(
                      color: Colors.pink,
                      width: 100.0,
                      height: 50.0,
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  Tooltip(
                    richMessage: TextSpan(children: [
                      WidgetSpan(
                        child: Container(
                          color: Colors.red,
                          width: 50,
                          height: 60,
                        ),
                      ),
                      const WidgetSpan(
                        child: Text(
                          "oj",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      const WidgetSpan(
                        child: Text(
                          "\nnew ",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const WidgetSpan(
                        child: Text(
                          "line",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ]),
                    child: Container(
                      color: Colors.blueAccent,
                      width: 100.0,
                      height: 50.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: showSnackBar,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              const SizedBox(height: 10.0),
              //widgets with opacitiy
              // Should check in the player
              // There is difference between putting them to stack
              // or as nested children like here the color differs
              InkWell(
                onTap: showModalBottom,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.pink,
                    width: 100.0,
                    height: 100.0,
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.green,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.white,
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.black,
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      color: Colors.blue,
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // sensitvity
              SmartlookTrackingWidget(
                isSensitive: true,
                child: Container(
                  color: Colors.orange,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              // multiple children widgets
              SizedBox(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.amberAccent,
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  SmartlookTrackingWidget(
                    isSensitive: true,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                  ),
                  Positioned(
                    child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    left: 10,
                    top: 10,
                  ),
                  Positioned(
                    child: SmartlookTrackingWidget(
                      isSensitive: false,
                      child: Container(
                        width: 80,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                    left: 10,
                    top: 10,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //text/paragraph
              const Text("test text"),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: "Ah",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: "oj",
                    style: TextStyle(color: Colors.orange),
                  ),
                  TextSpan(
                    text: "\nnew ",
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(
                    text: "line",
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
              ),
              // takhle to funguje
              RichText(
                text: const TextSpan(children: [
                  WidgetSpan(
                    child: Text(
                      "Ah",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      "oj",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      "line",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ]),
              ),

              const SmartlookTrackingWidget(
                doNotRecordWireframe: true,
                child: Icon(
                  Icons.add,
                  size: 45,
                ),
              ),
              //images

              Image.asset(
                "res/images/Smartlook.png",
                width: 100,
                height: 100,
                alignment: Alignment.center,
              ),

              //textfields and textformfiels
              const TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red,
                  border: OutlineInputBorder(borderSide: BorderSide(width: 30)),
                  labelText: "TextField",
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide(width: 30)),
                  labelText: "TextField",
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              DatePickerDialog(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now(),
              ),
              CupertinoContextMenu(
                actions: [
                  const Text("1----"),
                  const Text("2------"),
                ],
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.blueGrey,
                ),
              ),
              Checkbox(value: true, onChanged: (_) {}),
              Switch(value: true, onChanged: (val) {}),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void startingTransitionModalBottom()
  {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Your code to execute after build
      if (ModalRoute.of(context)?.isCurrent == true) {
        Smartlook.instance.sensitivity.changeTransitioningState(true);
      }
    });
  }

  void showModalBottom()
  {
    startingTransitionModalBottom();
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        Smartlook.instance.sensitivity.changeTransitioningState(false);

        return InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.orange,
            height: 300,
            child: Column(
              children: [
                Text('Modal BottomSheet'),
                TextFormField()
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      Smartlook.instance.sensitivity.changeTransitioningState(false);
    });
  }

  void showSnackBar() {
    const snackBar = SnackBar(
      content: SmartlookTrackingWidget(child: Text('Yay! A SnackBar!',),isSensitive: true,),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const TestDialog();
      },
    );
  }
}

class TestDialog extends StatelessWidget {
  const TestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      title: const SmartlookTrackingWidget(
        isSensitive: true,
        child: Text(
          'Premium Account',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
              'In order to download this movie, you need to have premium account.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Would you like to purchase it?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'PURCHASE',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
