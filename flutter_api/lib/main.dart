import 'package:flutter/material.dart';
import 'package:flutter_api/network/api_service.dart';
import 'package:flutter_api/ui/result_page.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

const padding = EdgeInsets.all(8.0);
const margin = EdgeInsets.all(8.0);
const height = 16.0;

void main() {
  _setUpLogging();
  runApp(Provider<ApiService>(
    create: (context) => ApiService.create(),
    child: MyApp(),
  ));
}

void _setUpLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print("${event.level.name}: ${event.time}: ${event.message}");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _artistController;
  TextEditingController _songTitleController;

  String _nameInputError;
  String _titleInputError;

  @override
  void initState() {
    _artistController = TextEditingController();
    _songTitleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _artistController.dispose();
    _songTitleController.dispose();
    super.dispose();
  }

  void _navigateToResultPage(BuildContext context) {
    if (_validInput()) {
      final route = MaterialPageRoute(
          builder: (context) => ResultPage(
                artist: _artistController.text,
                title: _songTitleController.text,
              ));
      Navigator.push(context, route);
    }
  }

  bool _validInput() {
    bool _valid = true;
    _valid &= _artistController.text.isNotEmpty;
    _valid &= _songTitleController.text.isNotEmpty;

    setState(() {
      _nameInputError =
          _artistController.text.isEmpty ? "Please Enter artist name." : null;
      _titleInputError =
          _songTitleController.text.isEmpty ? "Please Enter song title." : null;
    });

    return _valid;
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text("LyricsAPI Test"),
    );
    return Scaffold(
      appBar: _appBar,
      body: Card(
        margin: margin,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _artistController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter artist name.",
                  errorText: _nameInputError,
                ),
              ),
              SizedBox(
                height: height,
              ),
              TextField(
                controller: _songTitleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter song title.",
                  errorText: _titleInputError,
                ),
              ),
              SizedBox(
                height: height,
              ),
              RaisedButton(
                onPressed: () {
                  print("${_artistController.text}");
                  _navigateToResultPage(context);
                },
                padding: EdgeInsets.all(16),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  "Search",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
