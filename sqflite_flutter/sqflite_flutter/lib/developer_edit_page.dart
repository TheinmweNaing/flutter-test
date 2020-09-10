import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_flutter/model/developer.dart';
import 'package:sqflite_flutter/repo/developer_repo.dart';

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
  final Developer dev;
  final DeveloperRepo repo;

  const DeveloperEditPage({
    Key key,
    this.dev,
    this.repo,
  }) : super(key: key);

  @override
  _DeveloperEditPageState createState() => _DeveloperEditPageState();
}

class _DeveloperEditPageState extends State<DeveloperEditPage> {
  TextEditingController _nameController;
  TextEditingController _ageController;
  String _heading;

  Widget _buildDropDown() {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          value: _heading,
          isExpanded: true,
          onChanged: (e) {
            setState(() {
              _heading = e;
            });
          },
          items: languages.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return InkWell(
      onTap: () {
        final controller = FixedExtentScrollController(
          initialItem: languages.indexOf(_heading),
        );
        final picker = Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ))),
          height: MediaQuery.of(context).size.height * 0.35,
          child: CupertinoPicker.builder(
            scrollController: controller,
            itemExtent: 46,
            childCount: languages.length,
            onSelectedItemChanged: (index) {
              setState(() {
                _heading = languages[index];
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  languages[index],
                ),
              );
            },
          ),
        );
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => picker,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                width: 1,
              )),
        ),
        child: Text(
          _heading,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

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
    _nameController = TextEditingController(text: widget.dev.name);
    _ageController = TextEditingController(text: "${widget.dev.age ?? ""}");
    _heading = widget.dev.heading ?? languages[0];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(widget.dev.id == null ? "Create" : "Update"),
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
            if (widget.dev.id == null) {
              widget.repo
                  .insert(Developer(
                name: _nameController.text,
                age: int.parse(_ageController.text),
                heading: _heading,
              ))
                  .whenComplete(() {
                Navigator.of(context).pop(true);
              });
            } else {
              widget.repo
                  .update(Developer(
                id: widget.dev.id,
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

    if (widget.dev.id != null) {
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
          widget.repo.delete(widget.dev.id).whenComplete(() {
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
