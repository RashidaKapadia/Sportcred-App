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
import 'package:carousel_slider/carousel_slider.dart';
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
  String currentUser;
  List data = ['1', '2', '3'];
  Widget displayGroup(int i) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      ),
      child: SingleChildScrollView(
          /*child: Card(
              color: Colors.white,
              borderOnForeground: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              elevation: 15.0,*/
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
                children: List.generate(3, (index) {
              return displayResponses(index);
            })))
      ])),
    );
  }

  Widget displayResponses(int i) {
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
    Widget categoryCarousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          height: 450,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: data.map((item) {
          return displayGroup(0);
        }).toList(),
      ),
    );
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context)
                    .pushNamed("/debatePreviousQuestions")),
            title: Text("Debate", style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.greenAccent),
        backgroundColor: Colors.black12,
        bottomNavigationBar: NavBar(0),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              h3("Question : abcefghijklmn", color: Colors.black),
              categoryCarousel,
            ])));
  }
}
