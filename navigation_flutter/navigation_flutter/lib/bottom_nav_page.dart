import 'package:flutter/material.dart';

class BottomNavPage extends StatelessWidget {
  final String text;

  const BottomNavPage({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
