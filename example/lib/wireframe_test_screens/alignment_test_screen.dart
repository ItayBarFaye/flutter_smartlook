import 'package:flutter/material.dart';

class WireframeAlignmentTestScreen extends StatefulWidget {
  const WireframeAlignmentTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeAlignmentTestScreen> createState() =>
      _WireframeAlignmentTestScreenState();
}

class _WireframeAlignmentTestScreenState
    extends State<WireframeAlignmentTestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alignment test Screen")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
             /* Image.asset(
                "lib/Smartlook.png",
                width: 100,
                height: 100,
              ),
              Image.asset(
                "lib/Smartlook.png",
                width: 150,
                height: 150,
                alignment: Alignment.topRight,
              ),
              Image.asset(
                "lib/Smartlook.png",
                width: 100,
                height: 100,
                alignment: Alignment.center,
              ),
              Image.asset(
                "lib/Smartlook.png",
                width: 50,
                height: 50,
                alignment: Alignment.centerRight,
              ),

              Image.asset(
                "lib/Smartlook.png",
                width: 50,
                height: 50,
                alignment: Alignment.bottomLeft,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  "lib/Smartlook.png",
                  width: 100,
                  height: 100,
                ),
              ),*/
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                width: 100.0,
                height: 100.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                width: 100.0,
                height: 100.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                width: 100.0,
                height: 100.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                width: 100.0,
                height: 100.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
