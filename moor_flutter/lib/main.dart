import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/developer_edit_page.dart';
import 'package:moor_flutter/model/moor_database.dart';

MyDatabase database;

void main() {
  database = MyDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DeveloperPage(),
    );
  }
}

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  List<Developer> _list;
  TextEditingController _searchController;
  String _heading;

  void saveDeveloper(DevelopersCompanion dev) {
    final route = CupertinoPageRoute(
        builder: (context) => DeveloperEditPage(
              dev: dev,
              database: database,
            ));
    Navigator.push(context, route).then((result) {
      if (result ?? false) {
        findAllDevelopers();
      }
    });
  }

  void deleteDeveloper({int id, int index}) {
    database.deleteDeveloper(id);
    setState(() {
      _list.removeAt(index);
    });
  }

  void findAllDevelopers({String name, String heading}) async {
    final list = await database.findAll(name: name, heading: heading).first;
    setState(() {
      _list = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _list = List.empty(growable: true);
    _searchController = TextEditingController();
    findAllDevelopers();
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
                  findAllDevelopers(name: value, heading: _heading);
                },
                cursorColor: Colors.blue,
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
                  findAllDevelopers(
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
        backgroundColor: Colors.blue[500],
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          saveDeveloper(DevelopersCompanion());
        },
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            indent: 16,
            height: 1,
          );
        },
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
                        ),
                      ],
                    );
                  });
            },
            child: ListTile(
              onTap: () {
                saveDeveloper(DevelopersCompanion(
                    id: Value(dev.id),
                    name: Value(dev.name),
                    age: Value(dev.age),
                    heading: Value(dev.heading)));
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[700],
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
