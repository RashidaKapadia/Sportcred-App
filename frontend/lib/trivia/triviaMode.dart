import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/requests/trivia.dart';
import '../navbar.dart';
import 'onGoingTrivia.dart';

class TriviaModePage extends StatefulWidget {
  String category;
  TriviaModePage(this.category);

  @override
  _TriviaHomePageState createState() => _TriviaHomePageState(category);
}

class _TriviaHomePageState extends State<TriviaModePage> {
  String category;
  _TriviaHomePageState(this.category);

  Future<List<TriviaQuestion>> _futureTriviaQuestions;
  List<TriviaQuestion> triviaData;

  @override
  void initState() {
    super.initState();
    setState(() {
      print(category);
      _futureTriviaQuestions = getQuestions(category);
    });
  }

  void goToTrivia() async {
    await _futureTriviaQuestions.then((snapshot) {
      if (snapshot.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OnGoingTrivia(
                category: category, questions: snapshot, opponent: null)));
      }
    });
  }

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
                onPressed: () =>
                    Navigator.of(context).pushNamed("/trivia/category")),
            title: Text("Trivia", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.deepOrange),
        bottomNavigationBar: NavBar(0),
        body: (Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              gameModeTile(
                  onPressed: () {
                    if (_futureTriviaQuestions != null) {
                      goToTrivia();
                    }
                  },
                  text: "Solo Trivia"),
              gameModeTile(
                  onPressed: () {
                    if (_futureTriviaQuestions != null) {
                      goToTrivia();
                    }
                  },
                  text: "1 - 1 Trivia"),
            ],
          ),
        )));
  }
}
