// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/trivia.dart';
import 'package:frontend/trivia/triviaResult.dart';
import 'dart:async';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import 'package:simple_timer/simple_timer.dart';

enum TriviaMode { SOLO, MULTI_INVITER, MULTI_ACCEPTER }

class TriviaOngoing extends StatefulWidget {
  TriviaMode triviaMode;
  String username;
  String category;
  String opponent;
  int gameId;
  TriviaOngoing(
      {this.category,
      this.opponent,
      this.gameId,
      @required this.triviaMode,
      @required this.username});

  @override
  State<StatefulWidget> createState() => _TriviaOngoingState(
      username: username,
      category: category,
      opponent: opponent,
      gameId: gameId,
      triviaMode: triviaMode);
}

// Get questions, then call the actually quiz page after questions are recieved
class _TriviaOngoingState extends State<TriviaOngoing> {
  TriviaMode triviaMode;
  String category = "";
  String opponent = "";
  String username = "";
  String token = "";
  int gameId;
  _TriviaOngoingState(
      {this.category,
      this.opponent,
      this.gameId,
      @required this.triviaMode,
      @required this.username});
  var _future;

  @override
  void initState() {
    setState(() {
      // Get game data depending on the mode
      if (triviaMode == TriviaMode.SOLO) {
        _future = getQuestions(category);
      } else if (triviaMode == TriviaMode.MULTI_INVITER) {
        _future = startMultiplayerTrivia(username, opponent);
      } else if (triviaMode == TriviaMode.MULTI_ACCEPTER) {
        _future = joinMultiplayerTrivia(gameId);
      } else {
        // print("NO FUTURE FOR ONGOING TRIVIA!");
      }
    });
    super.initState();
  }

  // Widget loadTrivia() {
  //   if (triviaMode == TriviaMode.SOLO) {
  //   } else if (triviaMode == TriviaMode.MULTI_INVITER) {
  //   } else {}
  // }

  Widget loadTrivia() {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TriviaQuestion> triviaQns;
          if (triviaMode == TriviaMode.SOLO) {
            triviaQns = snapshot.data;
          } else if (triviaMode == TriviaMode.MULTI_INVITER) {
            List qnsNgameId = snapshot.data as List<dynamic>;
            triviaQns = qnsNgameId[0];
            gameId = qnsNgameId[1];
          } else {
            List qnsNopponent = snapshot.data as List<dynamic>;
            triviaQns = qnsNopponent[0];
            opponent = qnsNopponent[1];
          }
          return QuizPage(
              triviaMode: triviaMode,
              username: username,
              questions: triviaQns,
              gameId: gameId,
              opponent: opponent);
        } else {
          return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      (_future != null) ? loadTrivia() : Text("Game loading....");
}

// Page with changing questions
class QuizPage extends StatefulWidget {
  int gameId;
  List<TriviaQuestion> questions;
  String username = "";
  String token = "";
  String opponent;
  TriviaMode triviaMode;
  QuizPage(
      {Key key,
      @required this.username,
      @required this.questions,
      @required this.triviaMode,
      this.gameId,
      this.opponent})
      : super(key: key);

  @override
  _QuizpageState createState() => _QuizpageState(
      username: username,
      token: token,
      questions: questions,
      triviaMode: triviaMode,
      gameId: gameId,
      opponent: opponent);
}

class _QuizpageState extends State<QuizPage> with TickerProviderStateMixin {
  int gameId;
  List<TriviaQuestion> questions;
  String username = "";
  String token = "";
  String category = "";
  String opponent = "<unknown>";
  TriviaMode triviaMode;
  _QuizpageState(
      {@required this.username,
      @required this.token,
      @required this.questions,
      @required this.triviaMode,
      this.gameId,
      this.opponent});

  TimerController _timerController;

  // Styling
  Color colorToDisplay = Colors.indigoAccent; // current colour
  Color colorDefault = Colors.indigoAccent;
  Color correctAnsColor = Colors.green;
  Color incorrectAnsColor = Colors.red;

  int correctlyAnswered; // number of questions answered
  int notAnswered; // number of questions not answered
  int numQuestions; // number of questions
  List<String> selectedAnswers = [];

  int i = 0; // question index
  int timer = 10;

  bool disableAnswer = false;
  bool cancelTimer = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // print("Mode: " + triviaMode.toString());
    super.initState();
    correctlyAnswered = 0;
    notAnswered = questions.length;
    numQuestions = questions.length;
    _timerController = TimerController(this);

    startTimer();
  }

  int calculateDisplayScore(numQuestions, correctlyAnswered) {
    return correctlyAnswered - (i - correctlyAnswered);
  }

  gotoResults(context) {
    int score = correctlyAnswered - (numQuestions - correctlyAnswered);
    // print(selectedAnswers);

    if (triviaMode == TriviaMode.SOLO) {
      updateACS(token, username, score);
    } else {
      endMultiplayerTrivia(username, gameId, selectedAnswers, score);
    }

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
      // print("start time set state");
      // print("timer: " + timer.toString());

      // print(cancelTimer);
      if (cancelTimer) {
        setState(() {
          // print("cancelling");
          t.cancel();
          _timerController.stop();
        });
      } else if (timer < 1) {
        setState(() {
          _timerController.start();
          selectedAnswers.add(null);
          nextQuestion();
        });
      } else {
        setState(() {
          _timerController.start();
          timer--;
        });
      }
    });
  }

  void nextQuestion() {
    // print("next question set state");
    setState(() {
      timer = 10;
      // NOTE: i is inclusive TODO:
      // print("i: " + i.toString());
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
      // print("validate set state");
      setState(() {
        if (questions[i].answer == questions[i].options[t]) {
          correctlyAnswered++;
          colorToDisplay = correctAnsColor;
        } else {
          colorToDisplay = incorrectAnsColor;
        }
        notAnswered--;
        selectedAnswers.add(questions[i].options[t]);
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
          animationDuration: Duration(seconds: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
  }

  Future<dynamic> confirmLeave(BuildContext context) {
    Widget leaveButton = FlatButton(
        onPressed: () {
          setState(() {
            cancelTimer = true;
            for (int k = i; k < numQuestions; k++) {
              selectedAnswers.add(null);
            }
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
                  (triviaMode == TriviaMode.SOLO)
                      ? Row(children: [
                          h3("Good luck "),
                          h3(username, color: Colors.deepOrange),
                          h3("!")
                        ])
                      : Row(children: [
                          h3("You", color: Colors.deepOrange),
                          h3(" vs "),
                          h3(opponent, color: Colors.redAccent)
                        ]),
                  timer,
                  question,
                  options,
                  currentScore,
                ],
              ),
            )));
  }
}
