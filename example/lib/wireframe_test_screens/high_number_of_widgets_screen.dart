import 'package:flutter/material.dart';

class HighNumberOfWidgetsScreen extends StatelessWidget {
  const HighNumberOfWidgetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 50,
        crossAxisSpacing: 5,
        children: List<Widget>.generate(25, (int index) {
          return Center(
            child: InkWell(
              onTap: () {
                debugPrint("another high number of widgets screen");
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const HighNumberOfWidgetsScreen(),
                  ),
                );
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('App $index'),
                  actions: const <Widget>[
                    Icon(Icons.help),
                    Icon(Icons.add),
                    Icon(Icons.ac_unit),
                  ],
                ),
                body: Column(
                  children: const <Widget>[
                    Text('Item 1'),
                    Text('Item 2'),
                    Text('Item 3'),
                    Text('Item 4'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
