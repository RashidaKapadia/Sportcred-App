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

class DebateVote extends StatefulWidget {
  String username;
  DebateVote({@required this.username});
  @override
  _DebateVoteState createState() => _DebateVoteState();
}

class _DebateVoteState extends State<DebateVote> {
  Future<List<GroupNode>> _futureResponses;
  String currentUser = "";

  @override
  void initState() {
    FlutterSession().get('username').then((value) {
      setState(() {
        print("Gonna call GetGroupResponses and question");
        currentUser = value.toString();
        _futureResponses = getVoteGroupResponses(currentUser);
      });
    });
    super.initState();
  }

  Widget loadDebateGroupsAndQuestion() {
    return FutureBuilder<List<GroupNode>>(
      future: _futureResponses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DebatePage(groupResponses: snapshot.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => (_futureResponses != null)
      ? loadDebateGroupsAndQuestion()
      : Text("loading....");
}

class DebatePage extends StatefulWidget {
  List<GroupNode> groupResponses;
  String question = "";
  DebatePage({Key key, @required this.groupResponses}) : super(key: key);

  @override
  _DebatepageState createState() =>
      _DebatepageState(groupResponses: groupResponses, question: question);
}

class _DebatepageState extends State<DebatePage> {
  List<GroupNode> groupResponses;
  String chosenCategory = '';
  List data = ['1', '2', '3'];
  List sliderValues = [5, 5, 5];
  List<String> selectedAnswers = [];
  String question = "";
  String currentUser = "";
  Future<String> _futureQuestion;
  _DebatepageState({@required this.groupResponses, @required this.question});

  void initSlider() {
    setState(() {
      sliderValues = [5, 5, 5];
    });
  }

  @override
  void initState() {
    FlutterSession().get('username').then((value) {
      setState(() {
        initSlider();
        currentUser = value.toString();
        _futureQuestion = getMyQuestion(currentUser);
      });
    });
    super.initState();
  }

  Widget loadQuestion() {
    return FutureBuilder<String>(
      future: _futureQuestion,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Center(child: h3(snapshot.data, color: Colors.black)));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget createSlider(int i) {
    return Slider(
        value: sliderValues[i],
        min: 0,
        max: 10,
        label: (sliderValues[i]).toString(),
        divisions: 10,
        onChanged: (double newVal) {
          setState(() {
            sliderValues[i] = newVal;
          });
        });
  }

  Widget displayResponses(int i, GroupNode group) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(children: [
          Row(children: [
            hmargin10(Icon(Icons.assignment)),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(),
              child: AutoSizeText(group.responses[i].response),
            ))
          ]),
          createSlider(i),
        ]));
  }

  Widget displayGroup(GroupNode group) {
    var voteButton = (group.responses.length > 0)
        ? plainButton(
            text: "Submit",
            fontColor: Colors.white,
            backgroundColor: Colors.lightGreen[700],
            onPressed: () {
              setState(() {
                print("Testing Submiting votes");
                // submitVotes(
                //     group.groupId, currentUser, [103, 102, 91], sliderValues);
              });
            })
        : Container();

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            borderOnForeground: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            elevation: 15.0,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Column(children: [
                  Column(
                    children: List.generate(
                      group.responses.length,
                      (index) => displayResponses(index, group),
                    ),
                  ),
                  voteButton,
                ])),
          ),
        ));
  }

  Widget categoryCarousel() {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            height: 430,
            autoPlay: false,
            enlargeCenterPage: true,
            onPageChanged: (a, b) => initSlider()),
        // Items list will require to be updated here as well anytime new category is added
        items: groupResponses.map((item) {
          return displayGroup(item);
        }).toList(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pushNamed("/debate")),
          title:
              Text("Voting is Opened", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      bottomNavigationBar: NavBar(0),
      backgroundColor: Colors.grey[200],
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(children: [
            loadQuestion(),
            categoryCarousel(),
          ])),
    );
  }
}
