import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome!", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
      ),
      body: Center(
          child: Column(children: [
        SizedBox(
          height: 100.0,
        ),
        Text(
          "You have been registered successfully!",
          style: TextStyle(
              color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
        RaisedButton(
            child: Text(
              "Log in",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.orange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              Navigator.of(context).pushNamed('/signup');
                   // Need to change to login page
            }),
      ])),
    );
  }
}
