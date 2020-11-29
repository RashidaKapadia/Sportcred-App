import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';
import 'package:flutter_cursor/flutter_cursor.dart';

class PreviousDebateQuestions extends StatefulWidget {
  @override
  _PreviousDebateQuestionsState createState() =>
      _PreviousDebateQuestionsState();
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

class ResultNode {
  final String groupNumber;
  final PlayerResultInfo yourResult;
  final List<dynamic> others;
  final String winner;
  final String yourScore;
  final bool reqStatus;

  ResultNode(
      {this.groupNumber,
      this.yourResult,
      this.others,
      this.winner,
      this.yourScore,
      @required this.reqStatus});

  // converts json to UserInfo object
  factory ResultNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return ResultNode(
        reqStatus: status,
      );
    }

    return ResultNode(
        reqStatus: status,
        groupNumber: json['groupNumber'],
        yourResult: json['yours'],
        others: json['theirs'],
        yourScore: json['yourScore'],
        winner: json['winner']);
  }
}

class PlayerResultInfo {
  final String username;
  final String response;
  final String rating;
  final bool reqStatus;

  PlayerResultInfo(
      {this.username, this.response, this.rating, @required this.reqStatus});

  // converts json to UserInfo object
  factory PlayerResultInfo.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return PlayerResultInfo(
        reqStatus: status,
      );
    }

    return PlayerResultInfo(
        reqStatus: status,
        username: json['username'],
        response: json['response'],
        rating: json['averageRating']);
  }
}

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
                  message: "Question",
                  showDuration: Duration(seconds: 5),
                  child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            "/debatePreviousResults"); //***PASS IN CATEGORY NAME  */
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
                message: "Question",
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        "/debatePreviousResults"); //***PASS IN CATEGORY NAME  */
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
                      message: "Question",
                      child: RaisedButton(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              "/debatePreviousResults"); //***PASS IN CATEGORY NAME  */
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
              message: "Question",
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      "/debatePreviousResults"); //***PASS IN CATEGORY NAME  */
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

class _PreviousDebateQuestionsState extends State<PreviousDebateQuestions> {
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
