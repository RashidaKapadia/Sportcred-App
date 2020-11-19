import 'dart:js';

import 'package:flutter/material.dart';
// import 'package:frontend/InitialPage.dart';
import 'package:frontend/trivia/pickTriviaCategory.dart';
import 'package:frontend/trivia/onGoingTrivia.dart';
import 'package:frontend/trivia/triviaStart.dart';
import 'package:frontend/changePassword.dart';
import 'package:frontend/trivia/triviaResult.dart';
import 'changeContact.dart';
import './signup_page.dart';
import './welcome_page.dart';
import './loginPage.dart';
import './homepage.dart';
import './settings.dart';
import './HTTPRequestExample.dart';
import './profile_page.dart';
import './ACSHistory_page.dart';
import 'notificationBoard.dart';
import 'CommentsPage.dart';

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
        '/trivia': (context) => TriviaHomePage(),
        '/soloTrivia': (context) => PickTriviaCategoryPage(),
        '/quizPage': (context) => OnGoingTrivia("Basketball", null),
        '/settings': (context) => Settings(),
        "/profile/ACSHistory": (context) => ACSHistoryPage(),
        '/trivia/solo/result': (context) => TriviaResult(),
        '/notifications': (context) => NotificationBoard(),
        '/zone/comments': (context) => CommentsPage()
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
    return CommentsPage();
  }
}
