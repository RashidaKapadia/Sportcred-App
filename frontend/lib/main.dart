import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';
import './navbar.dart';

void main() {
  //print("Answer chosen!");
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var questInd = 0;
  var totalScore = 0;
  final questions = const [
    {
      "questionText": "What\'s your favourite color?",
      "answers": [
        {"text": "red", "score": 0},
        {"text": "orange", "score": 0},
        {"text": "yellow", "score": 0},
        {"text": "green", "score": 1},
      ],
    },
    {
      "questionText": "What\'s your favourite animal?",
      "answers": [
        {"text": "dog", "score": 1},
        {"text": "cat", "score": 0},
        {"text": "cow", "score": 0},
        {"text": "pig", "score": 0},
      ],
      "correct": "dog",
    },
    {
      "questionText": "Who is the worst prof",
      "answers": [
        {"text": "Nick", "score": 0},
        {"text": "Anna", "score": 0},
        {"text": "Brian", "score": 0},
        {"text": "Thierry", "score": 1},
      ],
    },
  ];
  void resetQuiz(){
    print("do your job mate");
    setState((){
      questInd = 0;
      totalScore = 0;
      print("yo pls, do your job mate");
    });
  }

  void answerQuestion(int score) {
    if (questInd < questions.length) {
      print("dude why");
      setState(() {
        totalScore += score;
        questInd++;
      });
    }
    print(questInd);
  }

  Widget build(BuildContext context) {
// A list of disctionaries.

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: questInd < questions.length
            ? Quiz(
// We pass stuff into our quiz function, which does stuff and returns the format
// FOr our question and answers
          answerQuestion: answerQuestion,
          questInd: questInd,
          questions: questions,
        )
            : Result(totalScore, resetQuiz),
        bottomNavigationBar: NavBar(),
      ),
    );
  }
}
