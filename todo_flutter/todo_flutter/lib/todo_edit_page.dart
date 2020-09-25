import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:todo_flutter/model/moor_database.dart';

class TodoEditPage extends StatefulWidget {
  final TodosCompanion todo;
  final MyDatabase database;

  const TodoEditPage({
    Key key,
    this.todo,
    this.database,
  }) : super(key: key);

  @override
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  TextEditingController _noteController;
  bool _favourite;

  Widget _buildPopupMenu() {
    return Container(
      margin: const EdgeInsets.only(
        top: 4.0,
      ),
      child: PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 1:
              widget.database.deleteToDo(widget.todo.id.value).whenComplete(() {
                Navigator.of(context).pop(true);
              });
              break;
            case 2:
              if (_favourite) {
                _favourite = false;
              } else {
                _favourite = true;
              }
              widget.database
                  .updateDeveloper(TodosCompanion(
                id: Value(widget.todo.id.value),
                favourite: Value(_favourite),
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
              break;
            case 3:
              if (_favourite) {
                _favourite = false;
              } else {
                _favourite = true;
              }
              widget.database
                  .updateDeveloper(TodosCompanion(
                id: Value(widget.todo.id.value),
                favourite: Value(_favourite),
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
              break;
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
              enabled: widget.todo.id.value == null ? false : true,
              value: 1,
              child: Text(
                "Delete",
              )),
          PopupMenuItem(
              enabled: _favourite ? false : true,
              value: 2,
              child: Text(
                "Add to favourite",
              )),
          PopupMenuItem(
              enabled: _favourite ? true : false,
              value: 3,
              child: Text(
                "Remove from favourite",
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.todo.body.value);
    _favourite = widget.todo.favourite.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white.withOpacity(0.1),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.7),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(
            top: 4.0,
          ),
          onPressed: () {
            if (widget.todo.id.value == null) {
              widget.database
                  .insert(TodosCompanion(
                body: Value(_noteController.text),
                date: Value(DateTime.now().toUtc().millisecondsSinceEpoch),
                favourite: Value(_favourite),
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
            } else {
              widget.database
                  .updateDeveloper(TodosCompanion(
                id: Value(widget.todo.id.value),
                body: Value(_noteController.text),
                date: Value(DateTime.now().toUtc().millisecondsSinceEpoch),
                favourite: Value(_favourite),
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
            }
          },
          icon: Icon(
            Icons.save,
          ),
          alignment: Alignment.centerRight,
        ),
        _buildPopupMenu(),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: TextField(
            controller: _noteController,
            expands: true,
            maxLines: null,
            minLines: null,
            autofocus: true,
            cursorColor: Colors.deepOrange,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(
              height: 1.5,
            )),
      ),
    );
  }
}
