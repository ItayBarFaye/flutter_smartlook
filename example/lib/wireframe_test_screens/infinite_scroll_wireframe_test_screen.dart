import 'package:flutter/material.dart';

class InfiniteScrollScreen extends StatelessWidget {
  const InfiniteScrollScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.6,
        children: List<Widget>.generate(500, (int index) {
          return Center(
            child: Scaffold(
              appBar: AppBar(
                title: Text('App $index'),
                actions: const <Widget>[
                  Icon(Icons.help),
                  Icon(Icons.add),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text('Item 1$index'),
                      Text('Item 2$index'),
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "oj$index",
                            style: const TextStyle(color: Colors.orange),
                          ),
                          WidgetSpan(
                            child: Text(
                              "\nnew$index ",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          WidgetSpan(
                            child: Text(
                              "line$index",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (_) {}),
                      const SizedBox(
                        width: 20.00,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    "res/images/detective_pikachu.jpeg",
                    width: 200,
                    height: 50,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
