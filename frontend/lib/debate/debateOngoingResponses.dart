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
  String currentUser;
  List data = ['1', '2', '3'];
  @override
  void initState() {
    super.initState();
    setState(() {
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
  }

  Widget displayResponses(int i) {
    return Container(
        child: Column(children: [
      Row(children: [
        Icon(Icons.assignment),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            "Dogs are the best hands down, they are super energetic and" +
                "silly, they are great mood boosters when your downdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!",
            //overflow: TextOverflow.ellipsis,
          ),
        ))
      ]),
    ]));
  }

  Widget displayGroup(int i) {
    return Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Card(
              color: Colors.white,
              borderOnForeground: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              elevation: 15.0,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                        children: List.generate(3, (index) {
                      return displayResponses(index);
                    })))
              ])),
        ));
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
                onPressed: () =>
                    Navigator.of(context).pushNamed("/debate/currentDQ")),
            title: Text("Responses",
                style: TextStyle(
                    color: Colors
                        .black)), // ***TO BE CHANGED INTO "category response'
            centerTitle: true,
            backgroundColor: Colors.greenAccent),
        bottomNavigationBar: NavBar(0),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(children: [
            h3("Question : abcefghijklmn", color: Colors.black),
            categoryCarousel,
          ]),
        ));
  }
}
