import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final Function answerQuestion;
  final int questInd;

  Quiz(
      {@required this.questions,
        @required this.answerQuestion,
        @required this.questInd});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questInd]['questionText'], // Pass the question to the Question object to format it
        ),
        ...(questions[questInd]['answers'] as List<Map<String, Object>>).map((answer) {  // Create a list out of the stuff and pass it into our answer object
          return Answer( () => answerQuestion((answer['score'])), answer['text'],);  // ()=> is some spooky function pointer
        }).toList()
      ],
    );
  }
}
