import 'package:flutter/material.dart';
import '../navbar.dart';
import 'triviaOngoing.dart';

class TriviaModePage extends StatefulWidget {
  String category;
  TriviaModePage(this.category);

  @override
  _TriviaHomePageState createState() => _TriviaHomePageState(category);
}

class _TriviaHomePageState extends State<TriviaModePage> {
  String category;
  _TriviaHomePageState(this.category);

  goToTrivia() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            TriviaOngoing(category: category, opponent: null)));
  }

  selectUser() {
    Navigator.of(context).pushNamed('/trivia/searchOpponent');
  }

  Widget gameModeTile({String text, Function onPressed}) {
    return ButtonTheme(
        height: MediaQuery.of(context).size.height / 3,
        child: RaisedButton(
          onPressed: onPressed,
          color: Colors.black38,
          child: Text(text.toUpperCase(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gameModeTile(onPressed: () => goToTrivia(), text: "Solo Trivia"),
              gameModeTile(onPressed: () => selectUser(), text: "1 - 1 Trivia"),
            ],
          ),
        )));
  }
}
