import 'package:flutter/material.dart';
import 'package:flutter_api/main.dart';
import 'package:flutter_api/model/lyrics_model.dart';
import 'package:flutter_api/network/api_service.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  final String artist;
  final String title;

  const ResultPage({
    Key key,
    this.artist,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);
    final _appBar = AppBar(
      title: Text(
        "Result",
      ),
    );
    return Scaffold(
      appBar: _appBar,
      body: FutureBuilder<Lyrics>(
        future: api.getLyrics(artist, title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(
                    "Something Wrong!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            final lyrics = snapshot.data.lyrics;
            if (lyrics != null && lyrics.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${title.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Text(
                      "${artist.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          "$lyrics",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text(
                    "Lyrics not found!",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
