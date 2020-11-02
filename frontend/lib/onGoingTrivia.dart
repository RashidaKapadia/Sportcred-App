// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/TriviaResult.dart';
import 'dart:async';
import 'dart:math';
import 'package:frontend/homepage.dart';
import './SoloTriviaPage.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:flutter/animation.dart';

class OnGoingTrivia extends StatelessWidget {
  String category;

  // Trivia questions, options and correct answers
  List<TriviaQuestion> triviaQuestions;
  //Map<String, List<String>> triviaOptions;
  //Map<String, String> triviaAnswers;

  OnGoingTrivia(this.category, this.triviaQuestions);
  String assetLoad;

  setasset() {
    assetLoad = "assets/mockdata2.json";
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString(assetLoad, cache: false),
        builder: (context, snapshot) {
         // List data = json.decode(snapshot.data.toString());
         List data = triviaQuestions; // creating data with data from backend
          if (data == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading",
                ),
              ),
            );
          } else {
            return quizPage(data: data);
          }
        });
  }
}

class quizPage extends StatefulWidget {
  var data;
  quizPage({Key key, @required this.data}) : super(key: key);

  @override
  _quizpageState createState() => _quizpageState(data);
}

class _quizpageState extends State<quizPage> with TickerProviderStateMixin {
  var data;
  _quizpageState(this.data);

  AnimationController _controller;
  Animation<double> _animation;

  Color colorToDisplay = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int marks = 0;
  int i = 1;
  int j = 1;
  int timer = 10;
  String showTimer = "10";
  bool disableAnswer = false;
  var randomList;
  //TimerController _timerController;
  TimerController _timerController;

  Map<String, Color> colorsForOptions = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent
  };

  bool cancelTimer = false;

  createRandomList() {
    var distinctIds = [];
    var rand = new Random();
    for (int i = 0;;) {
      distinctIds.add(rand.nextInt(10));
      randomList = distinctIds.toSet().toList();
      if (randomList.length < 10) {
        continue;
      } else {
        break;
      }
    }
    print(randomList);
  }

  @override
  void initState() {
    startTimer();
    createRandomList();
    _timerController = TimerController(this);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 5000),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.forward();
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void startTimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        _timerController.start();
        if (timer < 1) {
          t.cancel();
          nextQuestion();
        } else if (cancelTimer == true) {
          t.cancel();
          _timerController.stop();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  void nextQuestion() {
    timer = 10;
    cancelTimer = false;
    setState(() {
      if (j < 10) {
        i = randomList[j];
        j++;
      } else {
        // **************TODO
        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TriviaResult(),
          ));
        });
      }
      colorsForOptions["a"] = Colors.indigoAccent;
      colorsForOptions["b"] = Colors.indigoAccent;
      colorsForOptions["c"] = Colors.indigoAccent;
      colorsForOptions["d"] = Colors.indigoAccent;
      disableAnswer = false;
    });
    startTimer();
    _timerController.reset();
    _timerController.start();
  }

  void validateAnswer(String t) {
    if (data[2][i.toString()] == data[1][i.toString()][t]) {
      marks = marks + 1;
      colorToDisplay = correctAnsColor;
    } else {
      marks = marks - 1;
      colorToDisplay = incorrectAnsColor;
    }
    setState(() {
      colorsForOptions[t] = colorToDisplay;
      cancelTimer = true;
      disableAnswer = true;
    });

    Timer(Duration(seconds: 1), nextQuestion);
  }

  Widget answersAnimation(String t) {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: MaterialButton(
          onPressed: () => validateAnswer(t),
          child: Text(
            data[1][i.toString()][t],
            maxLines: 1,
          ),
          color: colorsForOptions[t],
          highlightColor: Colors.indigo[700],
          minWidth: 200.0,
          height: 45.0,
          splashColor: Colors.indigo[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text(
                      "Trivia",
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TO DO something with ACS
                          },
                          child: Text('Leave')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Resume'))
                    ],
                  ));
        },
        child: Scaffold(
            body: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Expanded(
                child: Container(
                    child: SimpleTimer(
              controller: _timerController,
              duration: Duration(seconds: 10),
              timerStyle: TimerStyle.expanding_sector,
            ))),
            SizedBox(height: 20.0),
            Expanded(
              flex: 3,
              child: Container(
                //width: 200,
                //height: 20,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigoAccent, width: 5.0),
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),

                child: Text(
                  'Q. ' + data[0][i.toString()],
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            //SizedBox(height: 100.0),
            Expanded(
              flex: 6,
              child: AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      answersAnimation('a'),
                      answersAnimation('b'),
                      answersAnimation('c'),
                      answersAnimation('d'),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: ',
                  style: TextStyle(fontSize: 20),
                ),
                FadeTransition(
                  opacity: _animation,
                  child: Center(
                    child: Text(
                      marks.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ),
              ],
            )),
            // ****TODO :- Add Score at the bottom and Questions Left
            //SizedBox(height: 50.0),
            /*Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    showTimer,
                    style: TextStyle(fontSize: 35.0),
                  ),
                ))*/
          ],
        )));
  }
}
