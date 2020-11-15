import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/trivia/onGoingTrivia.dart';
import '../navbar.dart';
import 'package:http/http.dart' as http;

class TriviaQuestion {
  final String question;
  final List<dynamic> options;
  final String answer;

  TriviaQuestion({this.question, this.options, this.answer});

  // converts json to TriviaQuestions object
  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
        question: json['question'],
        options: json['choices'],
        answer: json['answer']);
  }
}

class SoloTriviaPage extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<SoloTriviaPage> {
  // key is the cetgory of the trivia and ist value is its route
  // add more categories here
  final categories = {
    'General Sports': '/homepage',
    'Sports Scenarios': '/homepage',
    'Basketball': '/homepage'
  };

  // TODO: FIX should not hardcode to basketball
  String chosenCategory = 'basketball';
  List<TriviaQuestion> triviaData;
  Timer _timer;

  Future<List<TriviaQuestion>> _futureTriviaQuestions;

  // Http post request to get user info
  Future<List<TriviaQuestion>> getQuestions(String category) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/trivia/get-questions',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'category': category}),
    );

    if (response.statusCode == 200) {
      List<TriviaQuestion> triviaQs = [];

      // Get the questions, options and correctAnswers and store them in the class variables
      for (Map<String, dynamic> question
          in jsonDecode(response.body)["questions"] as List) {
        triviaQs += [TriviaQuestion.fromJson(question)];
      }
      return triviaQs;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureTriviaQuestions = getQuestions(chosenCategory);
    });
  }

  Future<Widget> DialogBox(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        //color: Color.black,
        builder: (BuildContext context) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0.0,
            backgroundColor: Colors.grey,
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Power up your game by answering all 10 questions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator()),
                    ]),
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    Widget category_carousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: ['General Sports', 'Sports Scenarios', 'Basketball'].map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.lightGreen[900],
                  borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 150.0,
                      ),
                      Text(
                        i,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      RaisedButton(
                        highlightElevation: 25.0,
                        color: Colors.lightGreen[800],
                        child: Text(
                          'Play!',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0)),
                        onPressed: () {
                          if (_futureTriviaQuestions != null) {
                            goToTrivia();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
            padding: EdgeInsets.all(10),
            child: ListView(children: [
              Text('Trivia',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text('Time to build that ACS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Color(0xFF9E9E9E))),
              SizedBox(
                height: 50.0,
              ),
              category_carousel,
            ])));
  }

  void goToTrivia() async {
    await _futureTriviaQuestions.then((snapshot) {
      if (snapshot.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OnGoingTrivia('Basketball', snapshot)));
      }
    });
  }
}