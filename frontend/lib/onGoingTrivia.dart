// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/TriviaResult.dart';
import 'dart:async';
import 'dart:math';
import './SoloTriviaPage.dart';
import 'package:simple_timer/simple_timer.dart';

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
          print(data.length);
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

  //AnimationController _controller;

  Color colorToDisplay = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int marks = 0;
  var pressedCorrectOption = 0; // number of correct answers picked
  var pressedIncorrectOption = 0; // number of questions answered wrong
  var notAnswered = 0; // number of questions not answered
  int i = 1;
  int j = 1;
  int timer = 10;
  String showTimer = "10";
  bool disableAnswer = false;
  bool _isPressed = false;
  //bool _isCorrect = false;
  int _isPressedCorrect = -1; // 0 - correct; 1 - incorrect; -1  for not pressed
  var randomList;
  TimerController _timerController;

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
    super.initState();
  }

  /*@override
  dispose() {
    _controller.dispose();
    super.dispose();
  }*/

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
          if (_isPressed == false) {
            marks = marks - 1;
          }
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
        Timer(Duration(seconds: 0), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => TriviaResult(
                  marks: marks,
                  incorrect: pressedIncorrectOption,
                  correct: pressedCorrectOption,
                  notAnswered:
                      10 - pressedCorrectOption - pressedIncorrectOption)));
        });
      }
      disableAnswer = false;
      _isPressedCorrect = -1;
    });
    startTimer();
    _timerController.reset();
    _timerController.start();
  }

  void validateAnswer(int t, bool val) {
    if (val == true) {
      if (data[i].answer == data[i].options[t]) {
        _isPressedCorrect = 0; //true
        marks = marks + 1;
        colorToDisplay = correctAnsColor;
        pressedCorrectOption = pressedCorrectOption + 1;
      } else {
        _isPressedCorrect = 1; //false
        marks = marks - 1;
        colorToDisplay = incorrectAnsColor;
        pressedIncorrectOption = pressedIncorrectOption + 1;
      }
      setState(() {
        cancelTimer = true;
        disableAnswer = true;
        _isPressed = false;
      });
    } else {
      marks = marks - 1;
    }

    Timer(Duration(seconds: 1), nextQuestion);
  }

  Widget answersAnimation(int t) {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        child: MaterialButton(
          onPressed: () {
            _isPressed = true;
            validateAnswer(t, true);
          },
          child: Text(
            data[i].options[t],
            maxLines: 1,
          ),
          color: _isPressedCorrect == 0
              ? Colors.green
              : _isPressedCorrect == 1
                  ? Colors.red
                  : Colors.indigoAccent,
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
                      "You sure want to leave? You will get a score of -10!",
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            marks = -10;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => TriviaResult(
                                        marks: marks,
                                        incorrect: pressedIncorrectOption,
                                        correct: pressedCorrectOption,
                                        notAnswered: 10 -
                                            pressedCorrectOption -
                                            pressedIncorrectOption)));
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
            SizedBox(height: 25.0),
            Expanded(
                child: Container(
                    child: SimpleTimer(
              controller: _timerController,
              duration: Duration(seconds: 10),
              timerStyle: TimerStyle.expanding_sector,
            ))),
            SizedBox(height: 25.0),
            Container(
              //flex: 3,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigoAccent, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text(
                  'Q. ' + data[i].question,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              flex: 6,
              child: AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(data[i].options.length, (index) {
                        return answersAnimation(index);
                      })),
                ),
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: ' + marks.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
          ],
        )));
  }
}
