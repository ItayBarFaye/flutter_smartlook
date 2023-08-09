import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String _timeString =
      '${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'res/images/Smartlook.png',
          width: 100,
          height: 100,
        ),
        Text(
          _timeString,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  void _getCurrentTime() {
    if (mounted)
      setState(() {
        _timeString =
            '${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}';
      });
  }
}
