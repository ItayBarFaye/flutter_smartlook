import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WireframeTextTestScreen extends StatefulWidget {
  const WireframeTextTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeTextTestScreen> createState() =>
      _WireframeTextTestScreenState();
}

class _WireframeTextTestScreenState extends State<WireframeTextTestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text widgets test Screen")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
              const Text(
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Et harum quidem rerum facilis est et expedita distinctio. Nunc auctor. Vivamus ac leo pretium faucibus. Proin pede metus, vulputate nec, fermentum fringilla, vehicula vitae, justo. Donec ipsum massa, ullamcorper in, auctor et, scelerisque sed, est. Nulla turpis magna, cursus sit amet, suscipit a, interdum id, felis. Nam quis nulla. Sed ac dolor sit amet purus malesuada congue. Sed elit dui, pellentesque a, faucibus vel, interdum nec, diam. Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? Curabitur ligula sapien, pulvinar a vestibulum quis, facilisis vel sapien. Donec vitae arcu. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Nulla non arcu lacinia neque faucibus fringilla. In rutrum.",
              ),
              RichText(
                text: TextSpan(children: [
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
                  const TextSpan(
                    text: "myText",
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
              ),
              const Text(
                "AhaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaAhaaaaaaaaaaaaaaaaaaaaaaaaaa",
              ),
              const Text("AAA\naaaa"),
              RichText(
                text: const TextSpan(
                  text: "oh my",
                  style: TextStyle(color: Colors.purple),
                  children: [
                    TextSpan(
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      children: [
                        TextSpan(
                          text: "line",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                          children: [
                            TextSpan(
                              text: "lineeeeeeeeeeeeee",
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                            TextSpan(
                              text: "lineeeeeeeeeeeeee",
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                            TextSpan(
                              text: "lineeeeeeeeeeeeee",
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                            TextSpan(
                              text: "     ",
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                          ],
                        ),
                        TextSpan(
                          text: "line",
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: "line",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green, fontSize: 24.0),
                    ),
                    TextSpan(
                      text: "line",
                      style: TextStyle(color: Colors.black),
                    ),
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
                      text: "line\n",
                      style: TextStyle(color: Colors.black),
                    ),
                    //edge case for whole line being filled

                    //edge case different size

                    TextSpan(
                      text: "oj",
                      style: TextStyle(color: Colors.orange, fontSize: 40),
                    ),
                    TextSpan(
                      text: "line",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "oj",
                      style: TextStyle(color: Colors.orange, fontSize: 100),
                    ),
                    //edge case newline
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),

                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "\nnew ",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "xxx",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..loadRequest(
                          Uri.parse('https://flutter.dev'),
                        ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.green,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.credit_card_off_outlined,
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                      const Icon(
                        Icons.credit_card_off_outlined,
                        color: Colors.yellow,
                        size: 50,
                      ),
                      const Icon(
                        Icons.credit_card_off_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                      const Icon(
                        Icons.credit_card_off_outlined,
                        color: Colors.black,
                        size: 50,
                      ),
                      const Icon(
                        Icons.credit_card_off_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
