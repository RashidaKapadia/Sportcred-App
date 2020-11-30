import 'dart:js';

import 'package:flutter/material.dart';
import 'package:frontend/debate/MyDebateResult.dart';
import 'package:frontend/debate/debateOngoingQuestionsDisplay.dart';
import 'package:frontend/debate/debateOngoingResponses.dart';
import 'package:frontend/debate/debatePreviousQuestionsDisplay.dart';
import 'package:frontend/debate/debatePreviousQuestionsResults.dart';
// import 'package:frontend/InitialPage.dart';
import 'package:frontend/trivia/triviaPickCategory.dart';
import 'package:frontend/trivia/triviaMode.dart';
import 'package:frontend/changePassword.dart';
import 'package:frontend/trivia/triviaResult.dart';
import 'package:frontend/trivia/triviaSearchOpponent.dart';
import 'changeContact.dart';
import './signup_page.dart';
import './welcome_page.dart';
import './loginPage.dart';
import './homepage.dart';
import './settings.dart';
import './theZone.dart';
import './HTTPRequestExample.dart';
import './profile_page.dart';
import './ACSHistory_page.dart';
import './requests/trivia.dart';
import 'package:frontend/debate/dailyDebateQuestion.dart';
import 'notificationBoard.dart';
import 'CommentsPage.dart';
import 'debate/debateMain.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          accentColor: Colors.orangeAccent, primaryColor: Colors.orangeAccent),
      title: 'SportCred',
      home: SportCredApp(),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
        '/homepage': (context) => HomePage(),
        '/changePassword': (context) => ChangePassword(),
        '/changeContact': (context) => ChangeContact(),
        "/test": (context) => HTTPRequestExample(),
        '/trivia/mode': (context) => TriviaModePage("basketball"),
        '/trivia/category': (context) => TriviaPickCategoryPage(),
        '/trivia/solo/result': (context) => TriviaResult(),
        '/trivia/searchOpponent': (context) =>
            TriviaSearchOpponentPage("basketball"),
        '/settings': (context) => Settings(),
        "/profile/ACSHistory": (context) => ACSHistoryPage(),
        '/notifications': (context) => NotificationBoard(),
        '/theZone': (context) => TheZone(),
        '/comments': (context) => CommentsPage(),
        '/myDebateResult': (context) => MyDebateResult(),
        '/debate/dailyQuestion': (context) => DailyDebateQuestion(),
        '/debate/currentDQ': (context) => CurrentDebateQuestions(),
        '/debateCurrentResponses': (context) => CurrentDebateResponses(),
        '/debatePreviousQuestions': (context) => PreviousDebateQuestions(),
        '/debatePreviousResults': (context) => PreviousDebateResults(),
        '/debate': (context) => Debate()
      }));
}

class SportCredApp extends StatefulWidget {
  @override
  _SportCredAppState createState() => _SportCredAppState();
}

class _SportCredAppState extends State<SportCredApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
