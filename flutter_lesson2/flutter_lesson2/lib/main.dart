import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total Sale",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "1500000 Ks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade400,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.laptop_chromebook,
                                size: 28,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "POS",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.widgets,
                                size: 28,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Products",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.pie_chart,
                                size: 28,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Report",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        "Add New",
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _createHorizontalLists(context, "Food"),
                      _createHorizontalLists(context, "Drink"),
                      _createHorizontalLists(context, "Stationary"),
                      _createHorizontalLists(context, "Household"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Sales",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 10,
                      itemBuilder: (context, index) =>
                          _createListTile((index + 10001).toString()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _createHorizontalLists(BuildContext context, String text) {
  return Card(
    elevation: 2,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.27,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(8),
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 4,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _createListTile(String text) {
  var formattedDate = DateFormat.yMMMd('en_US').add_jm().format(DateTime.now());

  return Card(
    elevation: 2,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      title: Text(
        "#$text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text("$formattedDate"),
      trailing: Text("3000 Ks"),
    ),
  );
}
