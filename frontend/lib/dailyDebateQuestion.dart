import 'dart:async';
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/formHelper.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DebateQuestionNode {
  final String question;
  final String id;
  final bool reqStatus;

  DebateQuestionNode({this.question, this.id, this.reqStatus});

  // converts json to post node object
  factory DebateQuestionNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return DebateQuestionNode(
        reqStatus: status,
      );
    }

    return DebateQuestionNode(
      reqStatus: status,
      question: json["dailyQuestion"],
      id: json["id"],
    );
  }
}

class DailyDebateQuestion extends StatefulWidget {
  @override
  _DailyDebateQuestionState createState() => _DailyDebateQuestionState();
}

class _DailyDebateQuestionState extends State<DailyDebateQuestion> {
  // String question = "";
  String response = "";
  String currentUser = "";
  DebateQuestionNode dailyQuestion;

  Future<DebateQuestionNode> getDailyQuestion() async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getDailyDebateQuestion',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'username': currentUser}),
    );

    if (response.statusCode == 200) {
      setState(() {
        dailyQuestion =
            DebateQuestionNode.fromJson(true, jsonDecode(response.body));
      });

      print("*********************");
      print(dailyQuestion.question);
      print("*********************");

      return dailyQuestion;
      // Return posts data
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      // Get question
      getDailyQuestion();
      // get current user's username
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});
    });
    print(currentUser);
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
        body: SingleChildScrollView(
            child: margin20(Column(
          children: [
            vmargin25(Text("Hilklj", style: TextStyle(fontSize: 20))),
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
            vmargin25(orangeButtonLarge(
                text: "Submit",
                onPressed: () {
                  // call send response API
                })),
          ],
        ))));
  }
}
