import 'dart:async';
import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/formHelper.dart';
import 'package:frontend/widgets/fonts.dart';
//import 'package:frontend/widgets/layout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'navbar.dart';

// variables storing info to display
class MyDebateResult extends StatefulWidget {
  @override
  _MyDebateResultState createState() => _MyDebateResultState();
}

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

class _MyDebateResultState extends State<MyDebateResult> {
  bool _status = true;
  List data;
  String currentUser;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerCenter;
  @override
  void initState() {
    _controllerTopCenter = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _controllerTopCenter.play();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
    setState(() {
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  Widget displayPlayerResult(int i) {
    return Container(
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [Icon(Icons.person), Text("alice")]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(Icons.assignment),
                Expanded(
                  child: AutoSizeText(
                    "Dogs are the best hands down, they are super energetic and" +
                        "silly, they are great mood boosters when your down!",
                    //overflow: TextOverflow.ellipsis,
                  ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [Icon(Icons.assessment), Text("35%")]),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(0),
      body: SingleChildScrollView(
          child: resultPage(context)), //resultPage(context),
    );
  }

  Widget headerBanner(Widget title) {
    return Container(
        width: double.infinity,
        color: Colors.blueGrey[900],
        height: 100,
        padding: EdgeInsets.all(20.0),
        child: title);
  }

  Widget resultPage(BuildContext context) {
    return Container(
      child: Column(children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerTopCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
          ),
        ),
        headerBanner(superLargeHeading("Your Debate result is as follows:",
            color: Colors.white)),
        pagebody(),
      ]),
    );
  }

  Widget pagebody() {
    var mediaQuery = MediaQuery;
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(children: [
          // Description
          h3("Group Number : x"),
          // Score breakdown
          DelayedDisplay(
            delay: Duration(seconds: 1),
            fadingDuration: Duration(seconds: 2),
            child: Text(
              "And the winner is... ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.orange[400],
              ),
            ),
          ),
          DelayedDisplay(
            delay: Duration(seconds: 3),
            fadingDuration: Duration(seconds: 2),
            child: Text(
              "Alice",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
                color: Colors.orange[600],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    //semanticContainer: true,
                    //clipBehavior: Clip.antiAlias,
                    //margin: EdgeInsets.all(20.0),
                    elevation: 10.0,
                    child: Column(
                      children: [
                        Row(children: [Icon(Icons.person), Text("test")]),
                        Row(children: [
                          Icon(Icons.assignment),
                          Expanded(
                            child: AutoSizeText(
                                "I love cats more, because  they are more independent"),
                          )
                        ]),
                        Row(children: [Icon(Icons.assessment), Text("30%")]),
                        Row(children: [
                          Text("Your Score: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text("3")
                        ]), // *****TO BE CHANGED
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey,
                    width: double.infinity,
                    height: 40,
                    child: Text("Your Group",
                        style: TextStyle(
                          //fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          //color: Colors.blue
                        ))),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(5, (index) {
                      // HARDCODED FOR NOW; CHANGE TO data.length
                      return displayPlayerResult(index);
                    }),
                  ),
                )
              ]))
        ]));
  }
}
