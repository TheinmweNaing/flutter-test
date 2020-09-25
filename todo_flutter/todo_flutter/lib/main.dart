import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart' as m;
import 'package:todo_flutter/model/custom_menu.dart';
import 'package:todo_flutter/model/moor_database.dart';
import 'package:todo_flutter/todo_edit_page.dart';

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
        primarySwatch: Colors.deepOrange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _list;
  CustomPopupMenu _menuSelected;
  String _viewSelectedValue = "List";
  String _sortSelectedValue;
  bool _favourite;
  bool _gridSelected;
  bool _listSelected;
  bool _favSelected;
  DateTime _dateSelected = DateTime.now();
  TextEditingController _searchController;

  List choice = [
    CustomPopupMenu("Sort"),
    CustomPopupMenu("View"),
  ];

  List sortMenu = [
    CustomPopupMenu("Date by asc"),
    CustomPopupMenu("Date by desc"),
  ];

  List viewMenu = [
    CustomPopupMenu("Grid"),
    CustomPopupMenu("List"),
  ];

  void saveTodo(TodosCompanion todo) {
    final route = CupertinoPageRoute(
        builder: (context) => TodoEditPage(
              todo: todo,
              database: database,
            ));
    Navigator.push(context, route).then((result) {
      if (result ?? false) {
        findAllTodo();
      }
    });
  }

  void findAllTodo({String name, DateTime dateTime, bool favourite}) async {
    final list = await database
        .findAll(name: name, dateTime: dateTime, favourite: favourite)
        .first;
    setState(() {
      _list = list;
    });
  }

  void findFavourites() async {
    final list = await database.findFav();
    setState(() {
      _list = list;
    });
  }

  void findDateByAsc() async {
    final list = await database.findDateByAsc();
    setState(() {
      _list = list;
    });
  }

  void findDateByDesc() async {
    final list = await database.findDateByDesc();
    setState(() {
      _list = list;
    });
  }

  Widget _buildPopupMenu() {
    return Container(
      margin: const EdgeInsets.only(
        top: 4.0,
      ),
      child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onSelected: (select) {
            setState(() {
              _menuSelected = select;
              switch (_menuSelected.name) {
                case "Sort":
                  showMenu(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          context: context,
                          position: RelativeRect.fromLTRB(1000.0, 30.0, 0, 0),
                          items: sortMenu.map((e) {
                            return PopupMenuItem(
                              value: e,
                              child: Text(e.name),
                            );
                          }).toList())
                      .then((value) {
                    setState(() {
                      _sortSelectedValue = value.name;
                      if (_sortSelectedValue == "Date by asc") {
                        findDateByAsc();
                      } else {
                        findDateByDesc();
                      }
                    });
                  });
                  break;
                case "View":
                  showMenu(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    position: RelativeRect.fromLTRB(1000.0, 30.0, 0, 0),
                    context: context,
                    items: [
                      PopupMenuItem(
                        value: "Grid",
                        child: Row(
                          children: [
                            Text(
                              "Grid",
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            _gridSelected
                                ? Icon(
                                    Icons.check,
                                    color: Colors.deepOrange,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "List",
                        child: Row(
                          children: [
                            Text(
                              "List",
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            _listSelected
                                ? Icon(
                                    Icons.check,
                                    color: Colors.deepOrange,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    setState(() {
                      _viewSelectedValue = value;
                      if (_viewSelectedValue == "List") {
                        _listSelected = true;
                        _gridSelected = false;
                      } else {
                        _gridSelected = true;
                        _listSelected = false;
                      }
                    });
                  });
                  break;
              }
            });
          },
          itemBuilder: (context) {
            return choice.map((e) {
              return PopupMenuItem(
                value: e,
                child: Text(e.name),
              );
            }).toList();
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _list = List.empty(growable: true);
    _searchController = TextEditingController();
    _listSelected = false;
    _gridSelected = false;
    _favSelected = false;
    findAllTodo();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "ToDo",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _dateSelected,
              firstDate: DateTime(1900),
              lastDate: DateTime(2200),
            ).then((value) {
              if (value != null && value != _dateSelected) {
                setState(() {
                  _dateSelected = value;
                  findAllTodo(dateTime: _dateSelected);
                });
              } else {
                findAllTodo();
                _dateSelected = DateTime.now();
              }
            });
          },
          icon: Icon(
            Icons.calendar_today,
          ),
        ),
        IconButton(
          onPressed: () {
            if (_favSelected == false) {
              setState(() {
                _favSelected = true;
                findFavourites();
              });
            } else {
              setState(() {
                _favSelected = false;
                findAllTodo();
              });
            }
          },
          icon: _favSelected
              ? Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.white,
                )
              : Icon(
                  Icons.star_border,
                  size: 30,
                ),
        ),
        _buildPopupMenu(),
      ],
    );
    return Scaffold(
        appBar: appBar,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveTodo(TodosCompanion());
          },
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: ShapeDecoration(
                          color: Colors.grey.shade200,
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
                                onChanged: (value) {
                                  findAllTodo(name: value);
                                },
                                controller: _searchController,
                                cursorColor: Colors.deepOrange,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Search...",
                                ),
                                style: TextStyle(
                                  height: 1.5,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _viewSelectedValue == "List"
                  ? Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            indent: 16,
                            height: 1,
                            color: Colors.grey[500],
                          );
                        },
                        itemBuilder: (context, index) {
                          final todo = _list[index];
                          return InkWell(
                            onTap: () {
                              saveTodo(TodosCompanion(
                                id: m.Value(todo.id),
                                body: m.Value(todo.body),
                                favourite: m.Value(todo.favourite),
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            DateFormat.yMMMd('en_US')
                                                .add_jm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        todo.date)),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            todo.body,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _favourite = todo.favourite;
                                            if (_favourite) {
                                              _favourite = false;
                                            } else {
                                              _favourite = true;
                                            }
                                            database
                                                .updateDeveloper(TodosCompanion(
                                                  id: m.Value(todo.id),
                                                  favourite:
                                                      m.Value(_favourite),
                                                ))
                                                .whenComplete(
                                                    () => findAllTodo());
                                          });
                                        },
                                        icon: todo.favourite
                                            ? Icon(
                                                Icons.star,
                                                color: Colors.deepOrange,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        crossAxisCount: 4,
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(
                              2, index.isEven ? 1.2 : 2.4);
                        },
                        itemBuilder: (context, index) {
                          final todo = _list[index];
                          return InkWell(
                            onTap: () {
                              saveTodo(TodosCompanion(
                                id: m.Value(todo.id),
                                body: m.Value(todo.body),
                                favourite: m.Value(todo.favourite),
                              ));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            DateFormat.yMMMd('en_US')
                                                .add_jm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        todo.date)),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            todo.body,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _favourite = todo.favourite;
                                          if (_favourite) {
                                            _favourite = false;
                                          } else {
                                            _favourite = true;
                                          }
                                          database
                                              .updateDeveloper(TodosCompanion(
                                                id: m.Value(todo.id),
                                                favourite: m.Value(_favourite),
                                              ))
                                              .whenComplete(
                                                  () => findAllTodo());
                                        });
                                      },
                                      icon: todo.favourite
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.deepOrange,
                                            )
                                          : Icon(
                                              Icons.star_border,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }
}
