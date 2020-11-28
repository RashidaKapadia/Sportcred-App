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

import '../navbar.dart';

// variables storing info to display
class PreviousDebateResults extends StatefulWidget {
  @override
  _PreviousDebateResultState createState() => _PreviousDebateResultState();
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

class _PreviousDebateResultState extends State<PreviousDebateResults> {
  bool _status = true;
  List data;
  String currentUser;

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
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () =>
                  Navigator.of(context).pushNamed("/debatePreviousQuestions")),
          title: Text("Debate", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      bottomNavigationBar: NavBar(0),
      body: SingleChildScrollView(
          child: resultPage(context)), //resultPage(context),
    );
  }

  Widget resultPage(BuildContext context) {
    return Container(
      child: Column(children: [
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
          h3("Question : abcefghijklmn"),
          // Score breakdown
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(7, (index) {
                      // HARDCODED FOR NOW; CHANGE TO data.length
                      return displayPlayerResult(index);
                    }),
                  ),
                )
              ]))
        ]));
  }
}
