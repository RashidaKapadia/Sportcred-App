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

  // Styling
  Color colorToDisplay = Colors.indigoAccent; // current colour
  Color colorDefault = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int correctlyAnswered; // number of questions answered
  int notAnswered; // number of questions not answered
  int questions; // number of questions

  int i = 0; // question index
  int timer = 10;

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
      colorToDisplay = colorDefault;
    });
    _timerController.reset();
    _timerController.start();
  }

  void validateAnswer(int t, bool val) {
    if (val == true) {
      print("validate set state");
      setState(() {
        if (data[i].answer == data[i].options[t]) {
          correctlyAnswered++;
          colorToDisplay = correctAnsColor;
        } else {
          colorToDisplay = incorrectAnsColor;
        }
        notAnswered--;
        cancelTimer = true;
        disableAnswer = true;
      });
    }

    // Delay for colour change before repainting
    Timer(Duration(seconds: 1), nextQuestion);
  }

  Widget animatedChoiceButton(int t) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: MaterialButton(
          onPressed: () => validateAnswer(t, true),
          child: Text(data[i].options[t], maxLines: 1),
          // Using race condition to colour buttons
          color: colorToDisplay,
          minWidth: 200.0,
          height: 45.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
  }

  Future<dynamic> confirmLeave(BuildContext context) {
    Widget leaveButton = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
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
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: SimpleTimer(
              controller: _timerController,
              duration: Duration(seconds: 10),
              timerStyle: TimerStyle.expanding_sector,
            )));

    Widget question = Container(
      //flex: 3,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        margin: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigoAccent, width: 5.0),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Text(
          'Q. ' + data[i].question,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
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
                return animatedChoiceButton(index);
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            children: <Widget>[
              timer,
              question,
              options,
              currentScore,
            ],
          ),
        ));
  }
}
