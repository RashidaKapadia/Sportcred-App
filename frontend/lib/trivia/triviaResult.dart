import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:http/http.dart' as http;

class TriviaResult extends StatefulWidget {
  int score = 0, incorrect = 0, correct = 0, notAnswered = 0, questions = 0;
  TriviaResult({
    Key key,
    this.score,
    this.incorrect,
    this.correct,
    this.notAnswered,
    this.questions,
  }) : super(key: key);
  @override
  _TriviaResultState createState() =>
      _TriviaResultState(score, incorrect, correct, notAnswered, questions);
}

class _TriviaResultState extends State<TriviaResult> {
  int score = 0, incorrect = 0, correct = 0, notAnswered = 0, questions = 0;
  _TriviaResultState(this.score, this.incorrect, this.correct, this.notAnswered,
      this.questions);

  // Http post request to update ACS
  Future updateACS(String username, String token) async {
    // Make the request and store the response
    final http.Response response =
        await http.post('http://localhost:8080/api/editACS"',
            headers: {
              'Content-Type': 'text/plain; charset=utf-8',
              'Accept': 'text/plain; charset=utf-8',
              'Access-Control-Allow-Origin': '*',
            },
            body: jsonEncode(<String, String>{
              "username": username,
              "token": token,
              "oppUsername": "N/A",
              "gameType": "Trivia Solo",
              "amount": this.score.toString(),
              "date": DateTime.now().toString()
            }));

    // Check the type of response received from backend
    return (response.statusCode == 200);
  }

  @override
  void initState() {
    super.initState();
    // Send score through HTTP request to update this user's ACS
    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              updateACS(username.toString(), token.toString());
            })
          });
    });
  }

  Widget headerBanner(Widget title) {
    return Container(
        width: double.infinity,
        color: Colors.blueGrey[900],
        height: 200,
        padding: EdgeInsets.all(20.0),
        child: title);
  }

  TableRow scoreRow(Icon icon, String field, int score) {
    return TableRow(children: [
      TableCell(child: Row(children: [icon, Text(field)])),
      TableCell(
          child: Text(score.toString() + '/' + questions.toString(),
              textAlign: TextAlign.right))
    ]);
  }

  Widget pagebody() {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(children: [
          // Description
          h3("Your trivia result is as follows:"),

          // Score breakdown
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: 240,
              child: Table(
                  border: TableBorder.all(
                      color: Colors.black26, width: 1, style: BorderStyle.none),
                  children: [
                    scoreRow(Icon(Icons.check_circle, color: Colors.green),
                        "Correct: ", correct),
                    scoreRow(Icon(Icons.cancel, color: Colors.red),
                        "Incorrect: ", incorrect),
                    scoreRow(Icon(Icons.error, color: Colors.blue),
                        "Not Answered: ", notAnswered),
                  ])),

          // Display Total Score
          h2("Total Score"),
          h3(score.toString()),

          // Buttons Links
          vmargin20(Column(
            children: [
              greyButtonFullWidth(
                  () => Navigator.of(context).pushNamed("/profile/ACSHistory"),
                  largeButtonTextGrey(" See ACS History ")),
              greyButtonFullWidth(
                  () {},
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share),
                        largeButtonTextGrey(" Share "),
                      ]))
            ],
          )),
        ]));
  }

  Widget page(BuildContext context) {
    return Container(
      child: Column(children: [
        headerBanner(superLargeHeading("Result", color: Colors.white)),
        pagebody(),
      ]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(0),
      body: page(context),
    );
  }
}
