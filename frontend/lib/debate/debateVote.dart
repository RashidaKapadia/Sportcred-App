import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';

class DebateVote extends StatefulWidget {
  @override
  _DebateVoteState createState() => _DebateVoteState();
}

class _DebateVoteState extends State<DebateVote> {
  // TODO: Temp hardcoding
  String chosenCategory = '';
  List data = ['1', '2', '3'];
  double _value1 = 5;
  double _value2 = 5;
  double _value3 = 5;

  Widget createSlider(int i) {
    //double val = 1;
    return Slider(
        value: ((i == 0) ? _value1 : ((i == 1) ? _value2 : _value3)),
        min: 0,
        max: 10,
        label: ((i == 0) ? _value1 : ((i == 1) ? _value2 : _value3))
            .round()
            .toString(),
        divisions: 10,
        onChanged: (double newVal) {
          setState(() {
            ((i == 0)
                ? _value1 = newVal
                : ((i == 1) ? _value2 = newVal : _value3 = newVal));
          });
        });
  }

  Widget displayResponses(int i) {
    var button = Container();
    if (i == 2) {
      button = plainButton(
          text: "Submit",
          fontColor: Colors.white,
          backgroundColor: Colors.lightGreen[700],
          onPressed: () {
            setState(() {
              _value1 = 5;
              _value2 = 5;
              _value3 = 5;
            });
          });
    }
    return Container(
        child: Column(children: [
      Row(children: [
        Icon(Icons.assignment),
        Expanded(
            child: AutoSizeText(
          "Dogs are the best hands down, they are super energetic and" +
              "silly, they are great mood boosters when your downdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!",
          //overflow: TextOverflow.ellipsis,
        ))
      ]),
      createSlider(i),
      button
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

  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () =>
                  Navigator.of(context).pushNamed("/debatePreviousQuestions")),
          title: Text("Voting is Open", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      bottomNavigationBar: NavBar(0),
      body: SingleChildScrollView(
          child: resultPage(context)), //resultPage(context),
    );
  }*/

  /*Widget resultPage(BuildContext context) {
    return Container(
      child: Column(children: [
        pagebody(),
      ]),
    );
  }*/

  /*Widget pagebody() {
    var mediaQuery = MediaQuery;
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(children: [
          h3("Question : abcefghijklmn", color: Colors.black),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: //Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                padding: EdgeInsets.all(10),
                child: CarouselSlider(
                  //children: List.generate(7, (index) {
                  items: data.map((item) {
                    return displayGroup(0);
                  }).toList(),
                  // HARDCODED FOR NOW; CHANGE TO data.length
                  //return displayGroup(index);
                ),
              ))
        ]));
  }
*/
  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
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
