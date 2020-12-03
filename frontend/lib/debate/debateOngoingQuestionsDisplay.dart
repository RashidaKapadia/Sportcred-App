import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/debate/debateOngoingResponses.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/requests/debate.dart';

class CurrentDebateQuestions extends StatefulWidget {
  @override
  _CurrentDebateQuestionsState createState() => _CurrentDebateQuestionsState();
}

/*bool widgetVisible = true;

void showWidget() {
  setState(() {
    widgetVisible = true;
  });
}

void setState(Null Function() param0) {}

void hideWidget() {
  setState(() {
    widgetVisible = false;
  });
}*/

List<QuestionNode> questionsList = [];

class _CurrentDebateQuestionsState extends State<CurrentDebateQuestions> {
  List data;
  String currentUser = '';
  //Future<QuestionNode> _futureQuestionNode;

  Future<List<QuestionNode>> _futureQuestions;
  var _future;

  /*void loadfutures() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        print("Gonna call GetGroupResponses");

        currentUser = value.toString();
       _futureQuestions = getQuestions();
        
        print("FUTURE Group Responses" + _futureQuestions.toString());
        print("init" + questionsList.toString());
      });
    });
  }*/

  @override
  void initState() {
    setState(() {
      // Get game data depending on the mode
      _future = getQuestions();
    });
    super.initState();
    //loadfutures();
  }

  Widget loadDebateResponses() {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QuestionNode> debateQns;
          debateQns = snapshot.data;
          return DebatePage(
            questions: debateQns,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      (_future != null) ? loadDebateResponses() : Text("loading....");
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
    String q;
    int qId;

    if (questionsList.isEmpty) {
      print("It is empty");
    }
    switch (i) {
      case 0:
        {
          return Center(
            child: Container(
              margin: EdgeInsets.all(15),
              child: ButtonTheme(
                minWidth: 10,
                height: 20.0,
                child: Tooltip(
                  message: questions[3].question,
                  showDuration: Duration(seconds: 5),
                  child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => CurrentDebateResponses(
                                  question: questions[3].question,
                                  questionId: questions[3].questionId,
                                ))); //***PASS IN CATEGORY NAME  */
                      },
                      padding: EdgeInsets.all(10.0),
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      child: Text(tiers[i], style: TextStyle(fontSize: 15))),
                ),
              ),
            ),
          );
        }
        break;
      case 1:
        {
          return Center(
            child: Container(
              margin: EdgeInsets.all(15),
              child: ButtonTheme(
                minWidth: 150,
                height: 20,
                child: Tooltip(
                  message: questions[2].question,
                  showDuration: Duration(seconds: 5),
                  child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => CurrentDebateResponses(
                                  question: questions[2].question,
                                  questionId: questions[2].questionId,
                                ))); //***PASS IN CATEGORY NAME  */
                      },
                      padding: EdgeInsets.all(10.0),
                      color: Colors.yellow[600],
                      textColor: Colors.white,
                      child: Text(tiers[i], style: TextStyle(fontSize: 15))),
                ),
              ),
            ),
          );
        }
      case 2:
        {
          return Center(
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: ButtonTheme(
                      minWidth: 250,
                      height: 20.0,
                      child: Tooltip(
                        message: questions[1].question,
                        showDuration: Duration(seconds: 5),
                        child: RaisedButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CurrentDebateResponses(
                                            question: questions[1].question,
                                            questionId: questions[1].questionId,
                                          )));
                            },
                            padding: EdgeInsets.all(10.0),
                            color: Colors.orange,
                            textColor: Colors.white,
                            child:
                                Text(tiers[i], style: TextStyle(fontSize: 15))),
                      ))));
        }
        break;
      case 3:
        {
          return Center(
              child: Container(
            margin: EdgeInsets.all(15),
            child: ButtonTheme(
              minWidth: 350,
              height: 20.0,
              child: Tooltip(
                message: questions[0].question,
                showDuration: Duration(seconds: 5),
                child: RaisedButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CurrentDebateResponses(
                                question: questions[0].question,
                                questionId: questions[0].questionId,
                              ))); //***PASS IN CATEGORY NAME  */
                    },
                    padding: EdgeInsets.all(10.0),
                    color: Colors.red[800],
                    textColor: Colors.white,
                    child: Text(tiers[i], style: TextStyle(fontSize: 15))),
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
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/debate")),
            title: Text("Debate", style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.greenAccent),
        //backgroundColor: Colors.white,
        bottomNavigationBar: NavBar(0),
        body: SingleChildScrollView(
            child: vmargin25(Column(children: [
          Text('Discussion for Today',
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
        ])))
        //categoryCarousel,
        );
  }
}
