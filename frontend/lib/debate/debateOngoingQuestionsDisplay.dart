import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:http/http.dart' as http;

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
  final String questionId;
  final String question;
  final String tier;
  final bool reqStatus;

  QuestionNode(
      {this.questionId, this.question, this.tier, @required this.reqStatus});

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
        tier: json['tier'],
        question: json['question']);
  }
}

Widget displayTiers(int i, BuildContext context) {
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
                  AutoSizeText("\n" + questionsList[i].question)
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
                  AutoSizeText("\n" + questionsList[1].question)
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
                        AutoSizeText("\n" + questionsList[2].question)
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
                AutoSizeText("\n" + questionsList[3].question)
              ]),
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

List<QuestionNode> questionsList = [];

class _CurrentDebateQuestionsState extends State<CurrentDebateQuestions> {
  List data;
  String currentUser = '';
  //Future<QuestionNode> _futureQuestionNode;
  Future<List<QuestionNode>> _futureQuestions;

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureQuestions = getQuestions();
      print("FUTURE QUESTIONS" + _futureQuestions.toString());
      print("init" + questionsList.toString());

      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
  }

  Future<List<QuestionNode>> getQuestions() async {
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

    print(response.statusCode);
    if (response.statusCode == 200) {
      List<QuestionNode> allQuestions = [];
      // Get the questions, options and correctAnswers and store them in the class variables
      for (Map<String, dynamic> questionNode
          in jsonDecode(response.body)["questions"] as List) {
        print("*********************");
        // print(QuestionNode.fromJson(true, questionNode).tier);
        print("*********************");

        allQuestions += [QuestionNode.fromJson(true, questionNode)];
        print(allQuestions[0].tier);
      }
      // DEBUGGING STATEMENTS
      print('DEBUGGING: Post Node Get');
      print("\n\nQuestionodes: " + allQuestions[0].question);
      print(allQuestions.length);
      setState(() {
        questionsList = allQuestions;
        print("in api" + questionsList.toString());
      });
      return allQuestions;
      // Return posts data
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    //
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
