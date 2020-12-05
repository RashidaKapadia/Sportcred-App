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
import 'package:frontend/requests/debate.dart';

import '../navbar.dart';

// variables storing info to display
class MyDebateResult extends StatefulWidget {
  @override
  _MyDebateResultState createState() => _MyDebateResultState();
}

class _MyDebateResultState extends State<MyDebateResult> {
  bool _status = true;
  List data;
  Future<YourResponseResultNode> _future;
  String currentUser;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerCenter;
  YourResponseResultNode yourResult;

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
    print(currentUser);

    FlutterSession().get('username').then((username) => {
          setState(() {
            currentUser = username.toString();
            _future = getPreviousTopicResult(username.toString());
          })
        });
  }

  Widget loadDebateResponses() {
    return FutureBuilder<YourResponseResultNode>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          YourResponseResultNode result;
          result = snapshot.data;
          return DebateResultPage(
            yourResult: snapshot.data,
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

class DebateResultPage extends StatefulWidget {
  YourResponseResultNode yourResult;

  DebateResultPage({
    Key key,
    @required this.yourResult,
  }) : super(key: key);

  @override
  _DebateResultpageState createState() => _DebateResultpageState(
        result: yourResult,
      );
}

class _DebateResultpageState extends State<DebateResultPage> {
  YourResponseResultNode result;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerCenter;

  _DebateResultpageState({
    @required this.result,
  });

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
              child: Row(children: [
                Icon(Icons.person),
                Text(result.theirs[i].username)
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(Icons.assignment),
                Expanded(
                  child: AutoSizeText(
                    result.theirs[i].response,
                    //overflow: TextOverflow.ellipsis,
                  ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: [
                Icon(Icons.assessment),
                Text(result.theirs[i].averageRating.toString())
              ]),
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
              onPressed: () => Navigator.of(context).pushNamed("/debate")),
          title: Text("Results Are In!", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
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
        //headerBanner(superLargeHeading("Your Debate result is as follows:",
        //  color: Colors.white)),
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
          h3("Group Number : " + result.groupId.toString()),
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
              result.winner.toString(),
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
                        Row(children: [
                          Icon(Icons.person),
                          Text(result.yours.username)
                        ]),
                        Row(children: [
                          Icon(Icons.assignment),
                          Expanded(
                            child: AutoSizeText(result.yours.response),
                          )
                        ]),
                        Row(children: [
                          Icon(Icons.assessment),
                          Text(result.yours.averageRating.toString())
                        ]),
                        Row(children: [
                          Text("Your Score: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(result.yourScore.toString())
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
                    child: Text("Other members",
                        style: TextStyle(
                          //fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          //color: Colors.blue
                        ))),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(2, (index) {
                      // HARDCODED FOR NOW; CHANGE TO data.length
                      return displayPlayerResult(index);
                    }),
                  ),
                )
              ]))
        ]));
  }
}
