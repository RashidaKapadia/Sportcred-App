import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/requests/debate.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:frontend/debate/debatePreviousQuestionsResults.dart';

class PreviousDebateQuestions extends StatefulWidget {
  @override
  _PreviousDebateQuestionsState createState() =>
      _PreviousDebateQuestionsState();
}

final tiers = ["Expert", "Pro Analyst", "Analyst", "Fanalyst"];
List<QuestionNode> questionsList = [];

Widget backbar(BuildContext context) {
  return AppBar(
      leading: BackButton(
          color: green,
          onPressed: () => Navigator.of(context).pushNamed("/debate")),
      title: Text("Debate", style: TextStyle(color: green)),
      centerTitle: true,
      backgroundColor: grey);
}

class _PreviousDebateQuestionsState extends State<PreviousDebateQuestions> {
  List data;
  String currentUser = '';
  //Future<QuestionNode> _futureQuestionNode;

  Future<List<QuestionNode>> _futureQuestions;
  var _future;

  @override
  void initState() {
    setState(() {
      // Get game data depending on the mode
      _future = getPreviousQuestions();
    });
    super.initState();
    //loadfutures();
  }

  Widget loadDebateQuestions() {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QuestionNode> debateQns;
          debateQns = snapshot.data;
          if (debateQns.length > 0) {
            return DebatePage(
              questions: debateQns,
            );
          } else {
            return Scaffold(
                appBar: backbar(context),
                body: Container(
                    padding: EdgeInsets.all(50),
                    child: h2("No questions for Today :(")));
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      (_future != null) ? loadDebateQuestions() : Text("loading....");
}

class DebatePage extends StatefulWidget {
  List<QuestionNode> questions;

  DebatePage({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  _DebatepageState createState() => _DebatepageState(
        questions: questions,
      );
}

class _DebatepageState extends State<DebatePage> {
  List<QuestionNode> questions;

  _DebatepageState({
    @required this.questions,
  });

  final tiers = ["Expert", "Pro Analyst", "Analyst", "Fanalyst"];

  Widget displayTiers(int i, BuildContext context) {
    switch (i) {
      case 0:
        {
          return Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: ButtonTheme(
                  minWidth: 10.0,
                  height: 10.0,
                  child: Tooltip(
                    message: questions[3].question,
                    showDuration: Duration(seconds: 5),
                    child: RaisedButton(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => PreviousDebateResults(
                                        question: questions[3].question,
                                        questionId: questions[3].questionId,
                                      ))); //***PASS IN CATEGORY NAME  */
                        },
                        padding: EdgeInsets.all(10.0),
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        child: Text(tiers[i], style: TextStyle(fontSize: 15))),
                  )),
            ),
          );
        }
        break;
      case 1:
        {
          return Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: ButtonTheme(
                minWidth: 150.0,
                height: 10.0,
                child: Tooltip(
                  message: questions[2].question,
                  child: RaisedButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PreviousDebateResults(
                                question: questions[2].question,
                                questionId: questions[2].questionId,
                              ))); //***PASS IN CATEGORY NAME  */
                    },
                    padding: EdgeInsets.all(10.0),
                    color: Colors.yellow[600],
                    textColor: Colors.white,
                    child: (Text(tiers[i], style: TextStyle(fontSize: 15))),
                  ),
                ),
              ),
            ),
          );
        }
      case 2:
        {
          return Center(
              child: Container(
                  margin: EdgeInsets.all(20),
                  child: ButtonTheme(
                      minWidth: 250,
                      height: 10.0,
                      child: Tooltip(
                        message: questions[1].question,
                        child: RaisedButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => PreviousDebateResults(
                                          question: questions[1].question,
                                          questionId: questions[1].questionId,
                                        ))); //***PASS IN CATEGORY NAME  */
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: Text(tiers[i], style: TextStyle(fontSize: 15)),
                        ),
                      ))));
        }
        break;
      case 3:
        {
          return Center(
              child: Container(
            margin: EdgeInsets.all(20),
            child: ButtonTheme(
              minWidth: 350,
              height: 10.0,
              child: Tooltip(
                message: questions[0].question,
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PreviousDebateResults(
                              question: questions[0].question,
                              questionId: questions[0].questionId,
                            ))); //***PASS IN CATEGORY NAME  */
                  },
                  padding: EdgeInsets.all(10.0),
                  color: Colors.red[800],
                  textColor: Colors.white,
                  child: Text(tiers[i], style: TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ));
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    return Scaffold(
        appBar: backbar(context),
        //backgroundColor: Colors.white,
        bottomNavigationBar: NavBar(0),
        body: vmargin25(Column(children: [
          Text('Results for Yesterday',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Container(margin: EdgeInsets.all(20)),
          Container(
            child: Column(
                children: List.generate(4, (index) {
              // HARDCODED FOR NOW; CHANGE TO data.length
              return displayTiers(index, context);
            })),
          )
        ]))
        //categoryCarousel,
        );
  }
}
