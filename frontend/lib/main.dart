import 'package:flutter/material.dart';
// import 'package:frontend/InitialPage.dart';
import 'package:frontend/SoloTriviaPage.dart';
import 'package:frontend/changePassword.dart';
import 'changeContact.dart';
import 'onGoingTrivia.dart';
import './signup_page.dart';
import './welcome_page.dart';
import './loginPage.dart';
import './homepage.dart';
import './settings.dart';
import './HTTPRequestExample.dart';
import './profile_page.dart';
import 'ACSHistory_page.dart';

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
        '/soloTrivia': (context) => SoloTriviaPage(),
        '/quizPage': (context) => OnGoingTrivia("Basketball", null),
        '/settings': (context) => Settings(),
        "/profile/ACSHistory": (context) => ACSHistoryPage()
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
