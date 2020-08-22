import 'package:flutter/material.dart';

void main() {
  runApp(MyStateApp());
}

class MyStateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPageAlt(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_count",
          ),
          RaisedButton(
              child: Text(
                "Count",
              ),
              onPressed: () {
                setState(() {
                  _count++;
                });
                print("count : $_count");
              }),
        ],
      ),
    ));
  }
}

class CounterPageAlt extends StatelessWidget {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_count",
          ),
          RaisedButton(
              child: Text(
                "Count",
              ),
              onPressed: () {
                _count++;
                print("count : $_count");
              }),
        ],
      ),
    ));
  }
}
