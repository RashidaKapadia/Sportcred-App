// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/trivia/triviaResult.dart';
import 'dart:async';
import 'package:frontend/trivia/soloTriviaPage.dart';
import 'package:simple_timer/simple_timer.dart';

class OnGoingTrivia extends StatelessWidget {
  String category;
  List<TriviaQuestion> triviaQuestions;
  OnGoingTrivia(this.category, this.triviaQuestions);

  @override
  Widget build(BuildContext context) {
    return (triviaQuestions == null)
        ? Text("Loading")
        : quizPage(data: triviaQuestions);
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

  TimerController _timerController;

  Color colorToDisplay = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int correctlyAnswered;
  int notAnswered; // number of questions not answered
  int questions;

  int i = 0;
  int timer = 10;

  String showTimer = "10";
  bool disableAnswer = false;
  bool cancelTimer = false;

  int displayScore(questions, correctlyAnswered) {
    return correctlyAnswered - (i - correctlyAnswered);
  }

  Function gotoResults = (context, questions, correctlyAnswered, notAnswered) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TriviaResult(
            score: correctlyAnswered - (questions - correctlyAnswered),
            incorrect: questions - notAnswered - correctlyAnswered,
            correct: correctlyAnswered,
            notAnswered: notAnswered)));
  };

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    setState(() {
      correctlyAnswered = 0;
      notAnswered = data.length;
      questions = data.length;
    });
    _timerController = TimerController(this); // TODO:
    startTimer();
  }

  void startTimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      print("start time set state");
      setState(() {
        _timerController.start();
        if (timer < 1) {
          t.cancel();
          nextQuestion();
        } else if (cancelTimer == true) {
          t.cancel();
          _timerController.stop();
        } else {
          timer--;
        }
        showTimer = timer.toString();
      });
    });
  }

  void nextQuestion() {
    print("next question set state");
    setState(() {
      timer = 10;
      cancelTimer = false;
      // NOTE: i is inclusive TODO:
      (i < questions - 1)
          ? i++
          : Timer(
              Duration(seconds: 0),
              () => gotoResults(
                  context, questions, correctlyAnswered, notAnswered));
      disableAnswer = false;
    });
    // startTimer();
    _timerController.reset();
    _timerController.start();
  }

  void validateAnswer(int t, bool val) {
    if (val == true) {
      if (data[i].answer == data[i].options[t]) {
        correctlyAnswered++;
        colorToDisplay = correctAnsColor;
      } else {
        colorToDisplay = incorrectAnsColor;
      }
      print("validate set state");
      setState(() {
        cancelTimer = true;
        disableAnswer = true;
      });
    }

    Timer(Duration(seconds: 1), nextQuestion);
  }

  Widget answersAnimation(int t) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: MaterialButton(
          onPressed: () {
            // _isPressed = true;
            validateAnswer(t, true);
          },
          child: Text(data[i].options[t], maxLines: 1),
          color: colorToDisplay,
          highlightColor: Colors.indigo[700],
          minWidth: 200.0,
          height: 45.0,
          splashColor: Colors.indigo[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
  }

  Future<dynamic> confirmLeave(BuildContext context) {
    Widget leaveButton = FlatButton(
        onPressed: () {
          Navigator.of(context).pop(); // TODO:
          gotoResults(context, questions, correctlyAnswered, notAnswered);
        },
        child: Text('Leave'));

    Widget resumeButton = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Resume'));

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: Text(
              "You sure want to leave? You will forfeit the game resulting in a score of -10!",
            ),
            actions: [leaveButton, resumeButton]));
  }

  @override
  Widget build(BuildContext context) {
    Widget timer = Expanded(
        child: Container(
            child: SimpleTimer(
      controller: _timerController,
      duration: Duration(seconds: 10),
      timerStyle: TimerStyle.expanding_sector,
    )));

    Widget question = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8),
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigoAccent, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Text(
        'Q. ' + data[i].question,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );

    Widget options = Expanded(
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
    );

    Widget currentScore = Text(
      'Score: ' + displayScore(questions, correctlyAnswered).toString(),
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    return WillPopScope(
        onWillPop: () => confirmLeave(context),
        child: Column(
          children: <Widget>[
            timer,
            question,
            options,
            currentScore,
          ],
        ));
  }
}
