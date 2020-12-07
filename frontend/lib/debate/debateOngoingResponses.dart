import 'dart:async';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/fonts.dart';
//import 'package:frontend/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:frontend/requests/debate.dart';
import 'package:frontend/widgets/layout.dart';

import '../navbar.dart';

// variables storing info to display
class CurrentDebateResponses extends StatefulWidget {
  int questionId;
  String question;
  CurrentDebateResponses({this.questionId, this.question});

  @override
  State<StatefulWidget> createState() =>
      _CurrentDebateResponseState(question: question, questionId: questionId);
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
  Future<List<GroupNode>> _future;

  String question;
  int questionId;
  _CurrentDebateResponseState({this.question, this.questionId});
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     FlutterSession()
  //         .get('username')
  //         .then((username) => {currentUser = username.toString()});
  //   });
  // }

  @override
  void initState() {
    FlutterSession().get('username').then((value) {
      setState(() {
        print("Gonna call GetGroupResponses and question");
        currentUser = value.toString();
        _future = getGroupResponses(questionId);
        print(_future.toString());
        print("question: " + question);
        print("questionId: " + questionId.toString());
      });
    });
    super.initState();
    //loadfutures();
  }

  Widget loadDebateResponses() {
    return FutureBuilder<List<GroupNode>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<GroupNode> result;
          result = snapshot.data;
          return DebateResponsePage(
            groupResponses: snapshot.data,
            question: question,
          );
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
  List<GroupNode> groupResponses;
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
  Future<List<GroupNode>> _future;

  List<GroupNode> groupResponses;

  String question = "";
  Future<String> _futureQuestion;
  _DebateResponsepageState(
      {@required this.groupResponses, @required this.question});

  Widget displayResponses(int i, GroupNode item) {
    return Container(
        child: Column(children: [
      Row(children: [
        Icon(Icons.assignment),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(item.responses[i].response)
              //overflow: TextOverflow.ellipsis,
              ),
        )
      ]),
    ]));
  }

  Widget displayGroup(GroupNode item) {
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
                        children: List.generate(item.responses.length, (index) {
                      // print("inner index: " + index.toString());
                      return displayResponses(index, item);
                    })))
              ])),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: green,
              onPressed: () =>
                  Navigator.of(context).pushNamed("/debate/currentDQ")),
          title: Text("Responses",
              style: TextStyle(
                  color: green)), // ***TO BE CHANGED INTO "category response'
          centerTitle: true,
          backgroundColor: grey),
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
    print("Question:" + question);
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(children: [
          // Description
          Align(alignment: Alignment.topCenter, child: h3(question)),
          // Score breakdown
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(groupResponses.length, (index) {
                      // HARDCODED FOR NOW; CHANGE TO data.length
                      // print("outter index: " + index.toString());
                      return displayGroup(groupResponses[index]);
                    }),
                  ),
                )
              ]))
        ]));
  }
}
