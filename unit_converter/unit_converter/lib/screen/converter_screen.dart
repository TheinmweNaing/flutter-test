import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unit_converter/model/models.dart';
import 'package:unit_converter/screen/home_screen.dart';

class ConverterPage extends StatefulWidget {
  final String title;
  final Conversions conversions;

  const ConverterPage({
    Key key,
    this.title,
    this.conversions,
  }) : super(key: key);

  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  Unit _selectedFrom;
  Unit _selectedTo;
  TextEditingController _editingController;
  Brain _brain;
  String _result = "";
  NumberFormat _format = NumberFormat("###.#######", "en_US");

  Widget _createDropDown(bool from) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade700,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Unit>(
            value: from ? _selectedFrom : _selectedTo,
            onChanged: (value) {
              setState(() {
                if (from) {
                  _selectedFrom = value;
                } else {
                  _selectedTo = value;
                }
                _convert();
              });
            },
            isExpanded: true,
            items: _brain.units.map((e) {
              return DropdownMenuItem<Unit>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  _convert() {
    var text = _editingController.value.text;
    var ans = _brain.calculate(
        _selectedFrom, _selectedTo, text.isEmpty ? 0.0 : double.parse(text));
    _result = _format.format(ans);
  }

  Widget _createTextField() {
    return TextField(
      onSubmitted: (value) {
        setState(() {
          _convert();
        });
      },
      controller: _editingController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        labelText: "Value",
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _brain = Brain();

    switch (widget.conversions) {
      case Conversions.VOLUME:
        _brain.initUnits(Conversions.VOLUME);
        break;
      case Conversions.LENGTH:
        _brain.initUnits(Conversions.LENGTH);
        break;
      case Conversions.WEIGHT:
        _brain.initUnits(Conversions.WEIGHT);
        break;
      case Conversions.DISTANCE:
        _brain.initUnits(Conversions.DISTANCE);
        break;
    }
    _selectedFrom = _brain.units[0];
    _selectedTo = _brain.units[0];
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        widget.title,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _createDropDown(true),
                    SizedBox(
                      height: 16,
                    ),
                    _createTextField(),
                    InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        setState(() {
                          var tmp = _selectedFrom;
                          _selectedFrom = _selectedTo;
                          _selectedTo = tmp;
                          _convert();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.swap_vert,
                          size: 24,
                        ),
                      ),
                    ),
                    _createDropDown(false),
                    Container(
                      margin: EdgeInsets.only(
                        top: 16,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade700,
                          )),
                      child: Text(
                        _result,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _createDropDown(true),
                              SizedBox(
                                height: 32,
                              ),
                              _createTextField(),
                            ],
                          ),
                        ),
                        InkWell(
                          customBorder: CircleBorder(),
                          onTap: () {
                            setState(() {
                              var tmp = _selectedFrom;
                              _selectedFrom = _selectedTo;
                              _selectedTo = tmp;
                              _convert();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.swap_horiz,
                              size: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _createDropDown(false),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 32,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade700,
                                    )),
                                child: Text(
                                  _result,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
