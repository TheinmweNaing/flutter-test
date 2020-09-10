import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_flutter/developer_edit_page.dart';
import 'package:sqflite_flutter/model/developer.dart';
import 'package:sqflite_flutter/repo/developer_repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DevelopersPageState(
        repo: DeveloperRepo(),
      ),
    );
  }
}

class DevelopersPageState extends StatefulWidget {
  final DeveloperRepo repo;

  const DevelopersPageState({
    Key key,
    this.repo,
  }) : super(key: key);

  @override
  _DevelopersPageStateState createState() => _DevelopersPageStateState();
}

class _DevelopersPageStateState extends State<DevelopersPageState> {
  List<Developer> _list;
  TextEditingController _searchController;
  String _heading;

  void insertRandom() async {
    final random = Random();
    var dev = Developer(
      name: "Dev ${_list.length + 1}",
      heading: languages[random.nextInt(4)],
      age: random.nextInt(18),
    );

    final result = await widget.repo.insert(dev);
    setState(() {
      _list.add(result);
    });
  }

  void saveDeveloper(Developer dev) {
    final route = CupertinoPageRoute(
      builder: (context) => DeveloperEditPage(dev: dev, repo: widget.repo),
    );

    Navigator.push(context, route).then((result) {
      if (result ?? false) {
        findAllDeveloper();
      }
    });
  }

  void findAllDeveloper({String name, String heading}) async {
    final list = await widget.repo.findAll(name: name, heading: heading);
    setState(() {
      _list = list;
    });
  }

  void deleteDeveloper({int id, int index}) async {
    await widget.repo.delete(id);
    setState(() {
      _list.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _list = List.empty(growable: true);
    _searchController = TextEditingController();
    findAllDeveloper();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  findAllDeveloper(name: value, heading: _heading);
                },
                cursorColor: Colors.green,
                decoration: InputDecoration.collapsed(
                  hintText: "Search...",
                ),
              ),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(46),
        child: Container(
          color: Colors.white,
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(languages[index]),
                selected: _heading == languages[index],
                onSelected: (selected) {
                  _heading = selected ? languages[index] : null;
                  findAllDeveloper(
                    name: _searchController.text,
                    heading: _heading,
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 8,
              );
            },
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[500],
        onPressed: () {
          saveDeveloper(Developer());
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            indent: 16,
            height: 1,
          );
        },
        padding: const EdgeInsets.all(16),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final dev = _list[index];
          return Dismissible(
            key: Key(dev.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(4),
              color: Colors.red,
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
            ),
            onDismissed: (direction) {
              deleteDeveloper(id: dev.id, index: index);
            },
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "Are you sure to delete?",
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "NO",
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "YES",
                        ),
                      )
                    ],
                  );
                },
              );
            },
            child: ListTile(
              onTap: () {
                saveDeveloper(dev);
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green[700],
              ),
              title: Text(
                dev.name ?? "None",
              ),
              subtitle: Text(
                dev.heading ?? "None",
              ),
              trailing: Text("${dev.age ?? "0"}"),
            ),
          );
        },
      ),
    );
  }
}
