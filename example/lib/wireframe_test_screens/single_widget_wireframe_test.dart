import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';

class WireframeSingleWidgetTestScreen extends StatefulWidget {
  const WireframeSingleWidgetTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeSingleWidgetTestScreen> createState() =>
      _WireframeSingleWidgetTestScreenState();
}

class _WireframeSingleWidgetTestScreenState
    extends State<WireframeSingleWidgetTestScreen> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Smartlook.instance.preferences
                        .setRenderingMode(RenderingMode.no_rendering);
                  },
                  icon: const Icon(Icons.no_accounts),
                ),
                IconButton(
                  onPressed: () {
                    Smartlook.instance.preferences
                        .setRenderingMode(RenderingMode.native);
                  },
                  icon: const Icon(Icons.account_balance),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      title: const Text(
        'Premium Account',
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
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

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);

      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRepaint(Sky oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
