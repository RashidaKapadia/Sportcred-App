import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(
      this.questionText); //This syntax basically says, take the thingy stick it into our vown questionText
  @override
  Widget build(BuildContext context) {
    return Container( // Handles the formatting for the question box
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
