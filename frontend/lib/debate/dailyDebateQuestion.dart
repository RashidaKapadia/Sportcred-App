import 'dart:async';
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/formHelper.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DailyDebateQuestion extends StatefulWidget {
  @override
  _DailyDebateQuestionState createState() => _DailyDebateQuestionState();
}

class _DailyDebateQuestionState extends State<DailyDebateQuestion> {
  String question = "";
  String response = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      question = "How are you?";
    });
    // Get question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff66cc00),
          leading: backButton(context),
          title: Text("Daily Debate Question",
              style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(child: margin20(
           Column(
            children: [
              vmargin25(Text(question, style: TextStyle(fontSize: 20))),
              vmargin20(hmargin15(TextField(
                  style: TextStyle(fontSize: 16),
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                      hintText: "Response",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onChanged: (value) {
                    setState(() {
                      response = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null))),
                  vmargin25(orangeButtonLarge(text: "Submit", 
                  onPressed: (){
                    // call send response API
                  })),
            ],
          )
    )));
  }
}
