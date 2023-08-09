import 'package:flutter/material.dart';

class CanvasTestScreen extends StatefulWidget {
  const CanvasTestScreen({Key? key}) : super(key: key);

  @override
  State<CanvasTestScreen> createState() => _CanvasTestScreenState();
}

class _CanvasTestScreenState extends State<CanvasTestScreen> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [const CircularProgressIndicator()],
          ),
        ),
      ),
    );
  }
}
