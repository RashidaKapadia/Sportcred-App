// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/trivia.dart';
import 'package:frontend/trivia/triviaResult.dart';
import 'dart:async';
import 'package:frontend/widgets/fonts.dart';
import 'package:simple_timer/simple_timer.dart';

class OnGoingTrivia extends StatefulWidget {
  String category;
  String opponent;
  List<TriviaQuestion> questions;
  OnGoingTrivia({@required this.category, this.opponent});

  @override
  State<StatefulWidget> createState() =>
      _OnGoingTriviaState(category: category, opponent: opponent);
}

class _OnGoingTriviaState extends State<OnGoingTrivia> {
  List<TriviaQuestion> questions;
  String category;
  String opponent;
  _OnGoingTriviaState({this.category, this.opponent});

  @override
  Widget build(BuildContext context) {
    return (questions == null)
        ? Text("Loading...")
        : quizPage(
            questions: questions, category: category, opponent: opponent);
  }
}

class quizPage extends StatefulWidget {
  List<TriviaQuestion> questions;
  String category;
  String opponent;
  quizPage({Key key, @required this.questions, this.category, this.opponent})
      : super(key: key);

  @override
  _QuizpageState createState() => _QuizpageState(
      questions: questions, category: category, opponent: opponent);
}

class _QuizpageState extends State<quizPage> with TickerProviderStateMixin {
  List<TriviaQuestion> questions;
  String category;
  String opponent;
  _QuizpageState({@required this.questions, this.category, this.opponent});

  TimerController _timerController;

  // Styling
  Color colorToDisplay = Colors.indigoAccent; // current colour
  Color colorDefault = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int correctlyAnswered; // number of questions answered
  int notAnswered; // number of questions not answered
  int numQuestions; // number of questions

  int i = 0; // question index
  int timer = 10;

  bool disableAnswer = false;
  bool cancelTimer = false;

  String username = "";
  String token = "";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    loadToken();
    loadUsername();
    correctlyAnswered = 0;
    notAnswered = questions.length;
    numQuestions = questions.length;
    _timerController = TimerController(this);

    startTimer();
  }

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
      });
    });
  }

  void loadToken() {
    FlutterSession().get('token').then((value) {
      this.setState(() {
        token = value.toString();
      });
    });
  }

  int calculateDisplayScore(numQuestions, correctlyAnswered) {
    return correctlyAnswered - (i - correctlyAnswered);
  }

  gotoResults(context) async {
    int score = correctlyAnswered - (numQuestions - correctlyAnswered);
    updateACS(token, username, score);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TriviaResult(
            score: score,
            incorrect: numQuestions - notAnswered - correctlyAnswered,
            correct: correctlyAnswered,
            notAnswered: notAnswered,
            numQuestions: numQuestions)));
  }

  void startTimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      print("start time set state");
      print("timer: " + timer.toString());
      print(cancelTimer);
      setState(() {
        _timerController.start();
        if (cancelTimer) {
          print("cancelling");
          t.cancel();
          _timerController.stop();
        } else if (timer < 1) {
          nextQuestion();
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
      // NOTE: i is inclusive TODO:
      print("i: " + i.toString());
      if (i < numQuestions - 1) {
        i++;
        _timerController.reset();
        _timerController.start();
      } else {
        cancelTimer = true;
        Timer(Duration(seconds: 0), () => gotoResults(context));
      }
      disableAnswer = false;
      colorToDisplay = colorDefault;
    });
  }

  void validateAnswer(int t, bool val) {
    if (val == true) {
      print("validate set state");
      setState(() {
        if (questions[i].answer == questions[i].options[t]) {
          correctlyAnswered++;
          colorToDisplay = correctAnsColor;
        } else {
          colorToDisplay = incorrectAnsColor;
        }
        notAnswered--;
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
          child: Text(questions[i].options[t], maxLines: 1),
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
          setState(() {
            cancelTimer = true;
          });
          Navigator.of(context).pop();
          gotoResults(context);
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
              "You sure want to leave? You will forfeit the remaining numQuestions!",
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
          border: Border.all(color: Colors.indigoAccent, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          'Q' + (i + 1).toString() + ": " + questions[i].question,
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
              children: List.generate(questions[i].options.length, (index) {
                return animatedChoiceButton(index);
              })),
        ),
      ),
    );

    Widget currentScore = Text(
      'Score: ' +
          calculateDisplayScore(numQuestions, correctlyAnswered).toString(),
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    // TODO: material theme missing
    return Scaffold(
        body: WillPopScope(
            onWillPop: () => confirmLeave(context),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: <Widget>[
                  h3("Good luck " + username),
                  timer,
                  question,
                  options,
                  currentScore,
                ],
              ),
            )));
  }
}