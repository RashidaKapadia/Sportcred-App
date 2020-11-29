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
  final String questionId;
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
            minWidth: 350,
            height: 10.0,
            child: RaisedButton(
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
        //statements;
      }
      break;
  }
}

class _CurrentDebateQuestionsState extends State<CurrentDebateQuestions> {
  List data;
  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
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
