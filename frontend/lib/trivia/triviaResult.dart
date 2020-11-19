import 'package:flutter/material.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';

class TriviaResult extends StatefulWidget {
  int score, incorrect, correct, notAnswered, numQuestions;
  TriviaResult({
    Key key,
    this.score,
    this.incorrect,
    this.correct,
    this.notAnswered,
    this.numQuestions,
  }) : super(key: key);
  @override
  _TriviaResultState createState() =>
      _TriviaResultState(score, incorrect, correct, notAnswered, numQuestions);
}

class _TriviaResultState extends State<TriviaResult> {
  int score, incorrect, correct, notAnswered, numQuestions;
  _TriviaResultState(this.score, this.incorrect, this.correct, this.notAnswered,
      this.numQuestions);

  TableRow scoreRow(Icon icon, String field, int score) {
    return TableRow(children: [
      TableCell(child: Row(children: [hmargin5(icon), Text(field)])),
      TableCell(
          child: Text(score.toString() + '/' + numQuestions.toString(),
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
              width: 200,
              child: Table(
                  columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
                  border: TableBorder.all(
                      color: Colors.black26, width: 1, style: BorderStyle.none),
                  children: [
                    scoreRow(Icon(Icons.check_circle, color: Colors.green),
                        "Correct:", correct),
                    scoreRow(Icon(Icons.cancel, color: Colors.red),
                        "Incorrect:", incorrect),
                    scoreRow(Icon(Icons.error, color: Colors.blue),
                        "Not Answered:", notAnswered),
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
