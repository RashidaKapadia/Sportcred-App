import 'dart:html';

import 'package:flutter/material.dart';
import '../navbar.dart';

class TriviaHomePage extends StatefulWidget {
  @override
  _TriviaHomePageState createState() => _TriviaHomePageState();
}

class _TriviaHomePageState extends State<TriviaHomePage> {
  Widget gameModeTile({String text, Function onPressed}) {
    return ButtonTheme(
        minWidth: 200.0,
        height: 100.0,
        child: RaisedButton(
          onPressed: onPressed,
          color: Color(0xFFFF8F00),
          child: Text(text, style: TextStyle(fontSize: 20)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Trivia", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.black),
        bottomNavigationBar: NavBar(0),
        body: (Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              gameModeTile(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/soloTrivia"),
                  text: "Solo Trivia"),
              gameModeTile(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/soloTrivia"),
                  text: "1 - 1 Trivia"),
            ],
          ),
        )));
  }
}
