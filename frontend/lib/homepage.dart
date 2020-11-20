import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/layout.dart';
import './navbar.dart';

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
      minWidth: 50.0,
      height: 25.0,
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(toRoute),
        child: Text(title),
        color: colour,
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          logoBanner(),
          Text("Welcome " + username + "!"),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return GridView.count(
                  padding: EdgeInsets.all(30),
                  crossAxisCount: 2,
                  primary: false,
                  children: <Widget>[
                    homepageTile("/theZone", "The Zone", Colors.redAccent),
                    homepageTile("/homepage", "Picks & Predictions",
                        Colors.orangeAccent),
                    homepageTile(
                        "/trivia/category", "Trivia", Colors.yellowAccent[100]),
                    homepageTile(
                        "/homepage", "Analyze & Debate", Colors.greenAccent),
                  ],
                );
              },
            ),
          ),
        ]));
  }
}
