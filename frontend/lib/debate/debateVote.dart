import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import 'package:frontend/requests/debate.dart';
import '../navbar.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DebateVote extends StatefulWidget {
  @override
  _DebateVoteState createState() => _DebateVoteState();
}

class GroupNode {
  final String groupId;
  List<Group_ResponsesNode> responses;
  final bool reqStatus;

  GroupNode({this.groupId, this.responses, @required this.reqStatus});

  // converts json to post node object
  factory GroupNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return GroupNode(
        reqStatus: status,
      );
    }

    return GroupNode(
      reqStatus: status,
      //responses: json['responses'],
      groupId: json['groupId'],
    );
  }
}

class Group_ResponsesNode {
  final String response;
  final int responseId;
  final bool reqStatus;

  Group_ResponsesNode(
      {this.response, this.responseId, @required this.reqStatus});

  // converts json to post node object
  factory Group_ResponsesNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return Group_ResponsesNode(reqStatus: status);
    }

    return Group_ResponsesNode(
      reqStatus: status,
      response: json['response'],
      responseId: json['groupId'],
    );
  }
}

List<GroupNode> allGroupResponses = [];

class _DebateVoteState extends State<DebateVote> {
  // TODO: Temp hardcoding
  String chosenCategory = '';
  List data = ['1', '2', '3'];
  double _value1 = 5;
  double _value2 = 5;
  double _value3 = 5;
  List sliderValues = [];

  Future<List<GroupNode>> _futureGroupResponses;

  String currentUser = "";

  Future getGroupResponses(String username) async {
    final http.Response response = await http.post(
        'http://localhost:8080//api/debate/get-group-responses-my-question',
        headers: defaultHeaders,
        body: jsonEncode(<String, Object>{
          "username": username,
        }));
    print("made the postman call");
    if (response.statusCode == 200) {
      // Store the session token
      //print("Post GET -> RESPONSE:" + response.body.toString());
      //print(jsonDecode(response.body)['questions']);
      print("response status code = 200");
      List<GroupNode> allGroups = [];
      // Get the questions, options and correctAnswers and store them in the class variables
      for (Map<String, dynamic> groupNode
          in jsonDecode(response.body)["groups"] as List) {
        print("*********************");
        print(GroupNode.fromJson(true, groupNode).groupId);
        print("*********************");
        List<Group_ResponsesNode> allGroupResponses = [];
        for (Map<String, dynamic> group_responsesNode
            in jsonDecode(response.body)["responses"] as List) {
          allGroupResponses += [
            Group_ResponsesNode.fromJson(true, group_responsesNode)
          ];
        }
        allGroups += [GroupNode.fromJson(true, groupNode)];
        allGroups.last.responses = allGroupResponses;
      }
      // DEBUGGING STATEMENTS
      print('DEBUGGING: Group Node Get');
      //print("\n\nGroupNodes: " + allGroups[0].responses[0]);

      // Return posts data
      return allGroups;
    } else {
      return null;
    }
  }

  initializeSlider() {
    sliderValues.add(_value1);
    sliderValues.add(_value2);
    sliderValues.add(_value3);
  }

  Widget createSlider(int i) {
    //double val = 1;
    return Slider(
        //value: ((i == 0) ? _value1 : ((i == 1) ? _value2 : _value3)),
        value: sliderValues[i],
        min: 0,
        max: 10,
        //label: ((i == 0) ? _value1 : ((i == 1) ? _value2 : _value3))
        //  .round()
        //.toString(),
        label: (sliderValues[i]).toString(),
        divisions: 10,
        onChanged: (double newVal) {
          setState(() {
            sliderValues[i] = newVal;
            //((i == 0)
            //  ? _value1 = newVal
            //: ((i == 1) ? _value2 = newVal : _value3 = newVal));
          });
        });
  }

  Widget displayResponses(int i, GroupNode group) {
    Group_ResponsesNode gr = group.responses[i];
    var button = Container();
    if (i == 2) {
      button = plainButton(
          text: "Submit",
          fontColor: Colors.white,
          backgroundColor: Colors.lightGreen[700],
          onPressed: () {
            setState(() {
              //_value1 = 5;
              //_value2 = 5;
              //_value3 = 5;
              // TEMP
              print("Testing Submiting votes");
              submitVotes("2020-12-01-FANALYST-0", "apple6", [103, 102, 91],
                  [sliderValues[0], sliderValues[1], sliderValues[2]]);
            });
          });
    }
    return Container(
        child: Column(children: [
      Row(children: [
        Icon(Icons.assignment),
        Expanded(
            //padding: const EdgeInsets.all(7.0),
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(gr.response
              // Group_responsesNode = group.responses[i].res
              //"Dogs are the best hands down, they are super energetic and" +
              //  "silly, they are great mood boosters when your downdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!",
              //overflow: TextOverflow.ellipsis,
              ),
        ))
      ]),
      createSlider(i),
      button
    ]));
  }

  Widget displayGroup(GroupNode group) {
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
                        children:
                            List.generate(group.responses.length, (index) {
                      return displayResponses(index, group);
                    })))
              ])),
        ));
  }

  void initState() {
    super.initState();
    setState(() {
      print("Gonna call GetGroupResponses");
      _futureGroupResponses = getGroupResponses(currentUser); // TO BE CHANGED
      print("FUTURE Group Responses" + _futureGroupResponses.toString());
      print("init" + allGroupResponses.toString());

      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
  }

  Widget build(BuildContext context) {
    initializeSlider();
    Widget categoryCarousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          height: 450,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: allGroupResponses.map((item) {
          return displayGroup(item);
        }).toList(),
      ),
    );

    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/debate")),
            title:
                Text("Voting is Open", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.blueGrey),
        bottomNavigationBar: NavBar(0),
        backgroundColor: Colors.grey[200],
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              h3("Question : abcefghijklmn", color: Colors.black),
              categoryCarousel,
            ])));
  }
}
