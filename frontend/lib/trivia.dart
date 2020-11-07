import 'dart:html';

import 'package:flutter/material.dart';
import './navbar.dart';

class TriviaHomePage extends StatefulWidget {
  @override
  _TriviaHomePageState createState() => _TriviaHomePageState();
}

class _TriviaHomePageState extends State<TriviaHomePage> {
  var isSelected = false;
  // This widget is the root of your application.
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
              const SizedBox(height: 30),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/soloTrivia");
                    },
                    color: Color(0xFFFF8F00),
                    child: const Text('Solo Trivia',
                        style: TextStyle(fontSize: 20)),
                  )),
              const SizedBox(height: 30),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton(
                    onPressed: () {},
                    color: Color(0xFFFF8F00),
                    child: const Text('1 - 1 Trivia',
                        style: TextStyle(fontSize: 20)),
                  )),
            ],
          ),
        )));
  }
}
