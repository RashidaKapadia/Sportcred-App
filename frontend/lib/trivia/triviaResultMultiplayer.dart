// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/requests/trivia.dart';
import 'dart:async';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';

class TriviaResultMulti extends StatefulWidget {
  String username;
  int gameId;
  TriviaResultMulti({@required this.username, @required this.gameId});

  @override
  State<StatefulWidget> createState() =>
      _TriviaResultMultiState(username: username, gameId: gameId);
}

// Get questions, then call the actually quiz page after questions are recieved
class _TriviaResultMultiState extends State<TriviaResultMulti> {
  String username = "";
  int gameId;
  _TriviaResultMultiState({@required this.username, @required this.gameId});
  Future<TriviaGameResult> _futureTriviaGameResults;

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureTriviaGameResults = resultsMultiplayerTrivia(username, gameId);
    });
  }

  Widget temp() {
    return Scaffold(
        body: ListView(children: [
      Text("Dummy"),
      Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        bold("Question 1"),
        ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) => Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("You  ->"),
                        Text("• " + index.toString()),
                        Text("<- Them")
                      ])
                ])),
      ])),
    ]));
  }

  Widget loadTrivia() {
    return FutureBuilder<TriviaGameResult>(
      future: _futureTriviaGameResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PageBody(
            username: username,
            game: snapshot.data,
          );
        } else {
          return temp();
          // return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => loadTrivia();
}

// Page with changing questions
class PageBody extends StatefulWidget {
  String username = "";
  TriviaGameResult game;
  PageBody({Key key, @required this.username, @required this.game})
      : super(key: key);

  @override
  _PageBodyState createState() =>
      _PageBodyState(username: username, game: game);
}

class _PageBodyState extends State<PageBody> with TickerProviderStateMixin {
  String username = "";
  TriviaGameResult game;
  _PageBodyState({@required this.username, @required this.game});

  @override
  void initState() {
    super.initState();
  }

  Widget body(BuildContext context) {
    return Text("TODO");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.brown[300]),
        // bottomNavigationBar: NavBar(1),
        body: body(context));
  }
}
