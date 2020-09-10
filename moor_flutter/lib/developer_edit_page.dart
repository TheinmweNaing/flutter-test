import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as m;
import 'package:moor_flutter/model/moor_database.dart';

const languages = [
  "Java",
  "Kotlin",
  "Swift",
  "Python",
  "Dart",
  "C",
  "C++",
  "JavaScript",
  "Matlab",
  "C#",
  "Ruby"
];

class DeveloperEditPage extends StatefulWidget {
  final DevelopersCompanion dev;
  final MyDatabase database;

  const DeveloperEditPage({
    Key key,
    this.dev,
    this.database,
  }) : super(key: key);

  @override
  _DeveloperEditPageState createState() => _DeveloperEditPageState();
}

class _DeveloperEditPageState extends State<DeveloperEditPage> {
  TextEditingController _nameController;
  TextEditingController _ageController;
  String _heading;

  Widget _buildChoiceChip() {
    final position = languages.indexOf(_heading);
    final controller = ScrollController(initialScrollOffset: position * 50.0);
    return Container(
      height: 46,
      child: ListView.separated(
          controller: controller,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 8,
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final selected = languages[index] == _heading;
            return ChoiceChip(
              avatar: selected
                  ? Icon(Icons.check_circle, color: Colors.white)
                  : null,
              selectedColor: Theme.of(context).primaryColor,
              label: Text(
                languages[index],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
              selected: selected,
              onSelected: (selected) {
                setState(() {
                  _heading = languages[index];
                });
              },
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dev.name.value);
    _ageController =
        TextEditingController(text: "${widget.dev.age.value ?? ""}");
    _heading = widget.dev.heading.value ?? languages[0];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(widget.dev.id.value == null ? "Create" : "Update"),
      actions: [
        FlatButton(
          shape: CircleBorder(),
          child: Text(
            "SAVE",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (widget.dev.id.value == null) {
              widget.database
                  .insert(DevelopersCompanion(
                name: m.Value(_nameController.text),
                age: m.Value(int.parse(_ageController.text)),
                heading: m.Value(_heading),
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
            } else {
              print("Update");
              widget.database
                  .updateDeveloper(Developer(
                id: widget.dev.id.value,
                name: _nameController.text,
                age: int.parse(_ageController.text),
                heading: _heading,
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
            }
          },
        )
      ],
    );

    final widgets = [
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Name",
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Age",
        ),
      ),
      SizedBox(
        height: 10,
      ),
      _buildChoiceChip(),
    ];

    if (widget.dev.id.value != null) {
      widgets.add(SizedBox(
        height: 16,
      ));
      widgets.add(RaisedButton(
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        color: Color(0xffd50002),
        onPressed: () {
          widget.database.deleteDeveloper(widget.dev.id.value).whenComplete(() {
            Navigator.of(context).pop(true);
          });
        },
        child: Text(
          "DELETE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }
}
