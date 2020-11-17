import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/requests/trivia.dart';
import 'package:frontend/trivia/onGoingTrivia.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';

class PickTriviaCategoryPage extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<PickTriviaCategoryPage> {
  // key is the cetgory of the trivia and ist value is its route
  // add more categories here
  final categories = {
    'General Sports': '/homepage',
    'Sports Scenarios': '/homepage',
    'Basketball': '/homepage'
  };

  // TODO: FIX should not hardcode to basketball
  String chosenCategory = 'basketball';

  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    Widget categoryCarousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 380.0,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: ['General Sports', 'Sports Scenarios', 'Basketball']
            .map((category) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                  color: Colors.lightGreen[900],
                  borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 145, 0, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        // Category label
                        Text(
                          category,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        // Play button
                        margin10(plainButton(
                            text: "Play!",
                            fontColor: Colors.white,
                            backgroundColor: Colors.lightGreen[700],
                            onPressed: () => Navigator.of(context).pushNamed(
                                "/trivia/mode",
                                arguments: {category: chosenCategory}))),
                      ],
                    )),
              ),
            );
          });
        }).toList(),
      ),
    );

    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              vmargin25(Column(children: [
                Text('Trivia',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Text('Time to build that ACS!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.black45))
              ])),
              categoryCarousel,
            ])));
  }
}
