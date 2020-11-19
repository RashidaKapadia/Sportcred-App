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
          return margin10(CircularProgressIndicator());
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

  Widget listSelectedAnswers(BuildContext context, int qindex) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: game.questions[qindex].options.length,
        itemBuilder: (context, index) {
          bool youPicked =
              game.you.answers[qindex] == game.questions[qindex].options[index];
          bool theyPicked = game.otherPlayer.answers[qindex] ==
              game.questions[qindex].options[index];
          bool isAnswer = game.questions[qindex].options[index] ==
              game.questions[qindex].answer;
          return Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (youPicked)
                      ? tag("You", 190, 220, 230, width: 50)
                      : SizedBox(width: 50),
                  Container(
                      width: 200,
                      child: Text(
                        "• " + game.questions[qindex].options[index],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: (youPicked || theyPicked)
                                ? (isAnswer)
                                    ? Color.fromRGBO(90, 160, 20, 1)
                                    : Colors.red
                                : Colors.black38),
                      )),
                  (theyPicked)
                      ? tag("Them", 230, 210, 190, width: 50)
                      : SizedBox(width: 50),
                ])
          ]);
        });
  }

  Widget listQuestions(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: game.questions.length,
            padding: EdgeInsets.all(0),
            // physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vmargin10(bold(game.questions[index].question,
                        align: TextAlign.left)),
                    listSelectedAnswers(context, index)
                  ],
                ),
              );
            }));
  }

  Widget displaySummary(BuildContext context) {
    bool win = game.you.gameScore > game.otherPlayer.gameScore;
    String winner;
    if (game.you.gameScore > game.otherPlayer.gameScore) {
      winner = game.you.username;
    } else if (game.you.gameScore < game.otherPlayer.gameScore) {
      winner = game.otherPlayer.username;
    } else {
      winner = "tie";
    }
    return margin20(Column(
      children: [
        h3("Summary"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                h2(game.you.username),
                h3(game.you.gameScore.toString(),
                    color: (win) ? Colors.greenAccent : Colors.red)
              ],
            ),
            Column(
              children: [
                h2(game.otherPlayer.username),
                h3(game.you.gameScore.toString(),
                    color: (win) ? Colors.greenAccent : Colors.red)
              ],
            ),
          ],
        ),
        h3("Winner:"),
        h2(winner),
      ],
    ));
  }

  Widget body(BuildContext context) {
    return Center(
        child: Container(
      child: Column(children: [
        headerBanner(Column(
          children: [
            superLargeHeading("Trivia Results", color: Colors.white),
            heading(game.you.username + " vs " + game.otherPlayer.username,
                size: 25, color: Colors.deepOrange)
          ],
        )),
        listQuestions(context),
        displaySummary(context),
      ]),
    ));
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
        body: SingleChildScrollView(
          child: Stack(children: [body(context)]),
        ));
  }
}
