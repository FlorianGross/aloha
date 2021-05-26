import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  var data = ["Hi", "Abc"];
  final streamController = StreamController<List<String>>();

  @override
  Widget build(BuildContext context) {
    streamController.add(data);

    return MaterialApp(
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                data.add(Random().nextInt(12345).toString());
                streamController.add(data);
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                data.removeAt(Random().nextInt(data.length - 1));
                streamController.add(data);
              },
            ),
          ],
        ),
        body: Center(
          child: StreamBuilder<List<String>>(
            initialData: data,
            stream: streamController.stream,
            builder: (context, content) {
              if (content.hasData) {
                return Text(content.data.toString());
              } else {
                return Text("No data");
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
