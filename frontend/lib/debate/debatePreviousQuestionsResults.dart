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
import 'package:frontend/requests/debate.dart';
import 'package:frontend/widgets/layout.dart';

import '../navbar.dart';

// variables storing info to display
class PreviousDebateResults extends StatefulWidget {
  int questionId;
  String question;
  PreviousDebateResults({this.questionId, this.question});
  @override
  State<StatefulWidget> createState() =>
      _PreviousDebateResultState(question: question, questionId: questionId);
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
  Future<List<GroupResultNode>> _future;

  String question;
  int questionId;
  _PreviousDebateResultState({this.question, this.questionId});

  @override
  void initState() {
    FlutterSession().get('username').then((value) {
      setState(() {
        print("Gonna call GetGroupResponses and question");
        currentUser = value.toString();
        _future = getGroupResponsesnResults(questionId);
        print(_future.toString());
        print("question: " + question);
        print("questionId: " + questionId.toString());
      });
    });
    super.initState();
    //loadfutures();
  }

  Widget loadDebateResponses() {
    return FutureBuilder<List<GroupResultNode>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<GroupResultNode> result;
          result = snapshot.data;
          return DebateResponsePage(
              groupResponses: snapshot.data, question: question);
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

class DebateResponsePage extends StatefulWidget {
  List<GroupResultNode> groupResponses;
  String question = "";
  DebateResponsePage(
      {Key key, @required this.groupResponses, @required this.question})
      : super(key: key);

  @override
  _DebateResponsepageState createState() => _DebateResponsepageState(
      groupResponses: groupResponses, question: question);
}

class _DebateResponsepageState extends State<DebateResponsePage> {
  bool _status = true;
  String currentUser = "";
  List data = ['1', '2', '3'];
  Future<List<GroupResultNode>> _future;

  List<GroupResultNode> groupResponses;

  String question = "";

  _DebateResponsepageState(
      {@required this.groupResponses, @required this.question});

  Widget displayGroup(GroupResultNode item) {
    print("item :" + item.toString());
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      ),
      //child: SingleChildScrollView(
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
                children: List.generate(item.responses.length, (index) {
              return displayResponses(index, item.responses[index]);
            })))
      ]),
    );
  }

  Widget displayResponses(int i, ResponseResultNode item) {
    return Container(
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [Icon(Icons.person), Text(item.username)]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(Icons.assignment),
                Expanded(
                  child: AutoSizeText(item.response
                      //overflow: TextOverflow.ellipsis,
                      ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(Icons.assessment),
                Text(item.averageRating.toString())
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    print("question " + question);
    Widget categoryCarousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          height: 440,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: groupResponses.map((item) {
          return SingleChildScrollView(
            child: displayGroup(item),
          );
        }).toList(),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: darkGreen,
              onPressed: () =>
                  Navigator.of(context).pushNamed("/debatePreviousQuestions")),
          title: Text("Debate", style: TextStyle(color: darkGreen)),
          centerTitle: true,
          backgroundColor: grey),
      backgroundColor: Colors.black12,
      bottomNavigationBar: NavBar(0),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(children: [
          h3(question, color: Colors.black),
          categoryCarousel,
        ]),
      ),
    );
  }
}
