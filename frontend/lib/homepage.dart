import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/layout.dart';
import './navbar.dart';
import 'package:frontend/widgets/fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isSelected = false;
  String username = "";

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Widget homepageTile(toRoute, title, colour) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(20.0)),
      minWidth: 50.0,
      height: 25.0,
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(toRoute),
        child: Text(title, style: TextStyle(fontSize: 15)),
        color: colour,
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
          child: new Column(
          mainAxisSize: MainAxisSize.min, children: <Widget>[
          logoBanner(),
          Text("Welcome " + username + "!", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return GridView.count(
                  padding: EdgeInsets.all(30),
                  crossAxisCount: 2,
                  primary: false,
                  children: <Widget>[
                    margin10(homepageTile("/theZone", "The Zone", darkGreen)),
                    margin10(homepageTile("/picksAndPredictions", "Picks & Predictions",
                        darkOrange)),
                    margin10(homepageTile(
                        "/trivia/category", "Trivia", orange)),
                    margin10(homepageTile(
                        "/debate", "Analyze & Debate", teal)),
                  ],
                );
              },
            ),
          ),
        ])));
  }
}
