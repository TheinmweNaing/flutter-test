import 'package:flutter/material.dart';

import 'converter_screen.dart';

enum Conversions { VOLUME, LENGTH, WEIGHT, DISTANCE }

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Unit Converter",
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _MenuButton(
                      icon: Icons.widgets,
                      color: Colors.amber,
                      text: "Volume",
                      conversions: Conversions.VOLUME,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    _MenuButton(
                      icon: Icons.straighten,
                      color: Colors.green,
                      text: "Length",
                      conversions: Conversions.LENGTH,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: Row(
                  children: [
                    _MenuButton(
                      icon: Icons.fitness_center,
                      color: Colors.red,
                      text: "Weight",
                      conversions: Conversions.WEIGHT,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    _MenuButton(
                      icon: Icons.directions_walk,
                      color: Colors.blue,
                      text: "Distance",
                      conversions: Conversions.DISTANCE,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  final String text;
  final Conversions conversions;

  const _MenuButton({
    Key key,
    this.icon,
    this.color,
    this.text,
    this.conversions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          var route = MaterialPageRoute(builder: (context) {
            return ConverterPage(
              title: text,
              conversions: conversions,
            );
          });
          Navigator.push(context, route);
        },
        color: color.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: color,
              size: 64,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: color.shade900,
              ),
            )
          ],
        ),
      ),
    );
  }
}
