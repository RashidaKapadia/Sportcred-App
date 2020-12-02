import 'dart:convert';
import 'dart:async';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/formHelper.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:flutter_cursor/flutter_cursor.dart';

class CurrentDebateQuestions extends StatefulWidget {
  @override
  _CurrentDebateQuestionsState createState() => _CurrentDebateQuestionsState();
}

bool widgetVisible = true;

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
}

final tiers = ["Expert", "Pro Analyst", "Analyst", "Fanalyst"];

class QuestionNode {
  final int questionId;
  final String question;
  final bool reqStatus;

  QuestionNode({this.questionId, this.question, @required this.reqStatus});

  // converts json to UserInfo object
  factory QuestionNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return QuestionNode(
        reqStatus: status,
      );
    }

    return QuestionNode(
        reqStatus: status,
        questionId: json['questionId'],
        question: json['question']);
  }
}

Widget displayTiers(int i, BuildContext context) {
  print("dailyquestions size:" + dailyQuestions.length.toString());
  switch (i) {
    case 0:
      {
        return Center(
          child: Container(
            margin: EdgeInsets.all(15),
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 10.0,
              child: RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      "/debateCurrentResponses"); //***PASS IN CATEGORY NAME  */
                },
                padding: EdgeInsets.all(10.0),
                color: Colors.lightGreen,
                textColor: Colors.white,
                child: Column(children: [
                  Text(tiers[i], style: TextStyle(fontSize: 15)),
                  AutoSizeText("\nQuestion")
                  // AutoSizeText(dailyQuestions[i].question)
                ]),
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
              minWidth: double.infinity,
              height: 10.0,
              child: RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      "/debateCurrentResponses"); //***PASS IN CATEGORY NAME  */
                },
                padding: EdgeInsets.all(10.0),
                color: Colors.yellow[600],
                textColor: Colors.white,
                child: Column(children: [
                  Text(tiers[i], style: TextStyle(fontSize: 15)),
                  AutoSizeText("\nQuestion")
                ]),
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
                    minWidth: double.infinity,
                    height: 10.0,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            "/debateCurrentResponses"); //***PASS IN CATEGORY NAME  */
                      },
                      padding: EdgeInsets.all(10.0),
                      color: Colors.orange,
                      textColor: Colors.white,
                      child: Column(children: [
                        Text(tiers[i], style: TextStyle(fontSize: 15)),
                        AutoSizeText("\nQuestion")
                      ]),
                    ))));
      }
      break;
    case 3:
      {
        return Center(
            child: Container(
          margin: EdgeInsets.all(15),
          child: ButtonTheme(
            minWidth: double.infinity,
            height: 10.0,
            child: RaisedButton(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    "/debateCurrentResponses"); //***PASS IN CATEGORY NAME  */
              },
              padding: EdgeInsets.all(10.0),
              color: Colors.red[800],
              textColor: Colors.white,
              child: Column(children: [
                Text(tiers[i], style: TextStyle(fontSize: 15)),
                AutoSizeText("\nQuestion")
              ]),
            ),
          ),
        ));
      }
      break;
    default:
      {
        return null;
      }
      break;
  }
}

List<QuestionNode> dailyQuestions = [];

class _CurrentDebateQuestionsState extends State<CurrentDebateQuestions> {
  List data;
  Future<List<QuestionNode>> _futurePosts;
  String currentUser;
  var _future;

  Future<List<QuestionNode>> getQuestions() async {
    print("getQuestions");
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/debate/get-ongoing-questions',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{}),
    );
    print(response);

    if (response.statusCode == 200) {
      List<QuestionNode> q =
          makeQuestionsList(jsonDecode(response.body)["questions"]);
      print("in api not in set state" + dailyQuestions.toString());
      setState(() {
        dailyQuestions = q;
        print("in api" + dailyQuestions.toString());
      });
      print(dailyQuestions.toString());
      return dailyQuestions;
    } else {
      print("in here");
      return null;
    }
  }

  List<QuestionNode> makeQuestionsList(List<dynamic> list) {
    List<QuestionNode> questions = [];
    for (Map<String, dynamic> question in list) {
      questions.add(QuestionNode.fromJson(true, question));
    }
    print("inside make question " + questions[1].questionId.toString());
    return questions;
  }

  @override
  void initState() {
    // setState(() {
    print("inisde here");
    _future = getQuestions();
    print("init" + dailyQuestions.toString());
    // });
    print("dailyquestions size:" + dailyQuestions.length.toString());

    print("done here");

    FlutterSession().get('token').then((token) {
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
    print(_future.toString());
    super.initState();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     _futurePosts = getQuestions();
  //     print("FUTURE POSTS" + _futurePosts.toString());
  //     print("init" + dailyQuestions.toString());

  //     FlutterSession()
  //         .get('username')
  //         .then((username) => {currentUser = username.toString()});
  //   });
  //   print(dailyQuestions.toString());
  // }

  Widget loadTrivia() {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QuestionNode> triviaQns;
          triviaQns = snapshot.data;
        } else {
          return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/debate")),
            title: Text("Debate", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.blueGrey),
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
                children: List.generate(dailyQuestions.length, (index) {
              // HARDCODED FOR NOW; CHANGE TO data.length
              return displayTiers(index, context);
            })),
          )
        ])))
        //categoryCarousel,
        );
  }
}
