import 'package:flutter/material.dart';
import './loginPage.dart';
import './HTTPRequestExample.dart';

void main() {
  runApp(MaterialApp(title: 'SportCred', routes: {
    "/": (context) => LoginPage(),
    "/test": (context) => HTTPRequestExample()
  }));
}
