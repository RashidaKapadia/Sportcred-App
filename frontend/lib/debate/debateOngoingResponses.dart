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
class CurrentDebateResponses extends StatefulWidget {
  @override
  _CurrentDebateResponseState createState() => _CurrentDebateResponseState();
}

class ResponseNode {
  final String response;
  final bool reqStatus;

  ResponseNode({this.response, @required this.reqStatus});

  // converts json to UserInfo object
  factory ResponseNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return ResponseNode(
        reqStatus: status,
      );
    }

    return ResponseNode(reqStatus: status, response: json['response']);
  }
}

class _CurrentDebateResponseState extends State<CurrentDebateResponses> {
  bool _status = true;
  List data;
  String currentUser;
  @override
  void initState() {
    super.initState();
    setState(() {
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
  }

  Widget displayPlayerResponse(int i) {
    return Container(
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(
                  Icons.assignment,
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Dogs are the best hands down, they are super energetic and" +
                          "silly, they are great mood boosters when your down!",
                      style: TextStyle(color: Colors.black),
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ]),
            ),
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
                  Navigator.of(context).pushNamed("/debate/currentDQ")),
          title: Text("Responses",
              style: TextStyle(
                  color: Colors
                      .black)), // ***TO BE CHANGED INTO "category response'
          centerTitle: true,
          backgroundColor: Colors.greenAccent),
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
                      return displayPlayerResponse(index);
                    }),
                  ),
                )
              ]))
        ]));
  }
}
