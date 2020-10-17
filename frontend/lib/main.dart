import 'package:flutter/material.dart';
import './loginPage.dart';
import './HTTPRequestExample.dart';

void main() {
  runApp(MaterialApp(
    title: 'SportCred',
    home: SportCredApp(),
  ));
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
    // return HTTPRequestExample();
  }
}
