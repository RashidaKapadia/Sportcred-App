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
  Timer _timer;
  String question = "";
  String analysis = "";
  TextEditingController responseController = new TextEditingController()
    ..text = '';

  String currentUser = "";

  Future<String> getDailyQuestion() async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/debate/get-daily-question',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'username': currentUser}),
    );

    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body));

        question = jsonDecode(response.body)["dailyQuestion"].toString();
      });

      print("*********************");
      print(question);
      print("*********************");

      return question;
      // Return posts data
    } else {
      return null;
    }
  }

  Future<String> getResponse() async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/debate/get-daily-question-response',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'username': currentUser}),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        print("Response: " + jsonDecode(response.body)["analysis"].toString());

        responseController
          ..text = jsonDecode(response.body)["analysis"].toString();
      });

      print("*********************");
      print(responseController.value.text);
      print("*********************");

      return analysis;
      // Return posts data
    } else {
      return "";
    }
  }

  Future<bool> addDebateAnalysis(String analysis) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/debate/add-response',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(
          <String, String>{'username': currentUser, 'analysis': analysis}),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        getResponse();
      });
      popUp(context, "Confirmation", "Analysis submitted successfully!");
      return true;
    } else {
      errorPopup(context, "Could not submit analysis!");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      // get current user's username
      FlutterSession()
          .get('username')
          .then((username) => {currentUser = username.toString()});

      _timer = new Timer(const Duration(milliseconds: 200), () {
        print("USERNAME: " + currentUser);

        // Get the daily debate question for this user
        getDailyQuestion();

        print("GETTING RESPONSE");

        // Get the user's response (in case if they have previously answered the question)
        getResponse();
      });
    });
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
            vmargin25(Text(question, style: TextStyle(fontSize: 20))),
            vmargin20(hmargin15(TextFormField(
                style: TextStyle(fontSize: 16),
                controller: responseController,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                    hintText: "Response",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),             
                keyboardType: TextInputType.multiline,
                maxLines: null))),
            vmargin25(orangeButtonLarge(
                text: "Submit",
                onPressed: () => {
                      setState(() {
                        print("ADDING RESPONSE");
                        print(responseController.value.text);
                        if (responseController.value.text.isNotEmpty) {
                          // Add debate analysis
                          addDebateAnalysis(responseController.value.text);
                          print("RESPONSE ADDED");
                        } else {
                          print("Respomse is empty");
                          errorPopup(context, "Please provide your analysis!");
                        }
                      })
                    })),
          ],
        ))));
  }
}
