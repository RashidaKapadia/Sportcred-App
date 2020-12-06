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
      shape: RoundedRectangleBorder(
          side: BorderSide(color: colour, width: 5),
          borderRadius: BorderRadius.circular(20.0)),
      minWidth: 50.0,
      height: 25.0,
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(toRoute),
        child: Text(
          title,
          style: TextStyle(fontSize: 25, color: colour),
          textAlign: TextAlign.center,
        ),
        color: grey,
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
            color: lightGrey,
            child:
                new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              logoBanner(),
              Row(children: [
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        color: Color.fromRGBO(31, 38, 5, 0.9),
                        child: Text(
                          "Welcome " + username + "!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 255, 255, 0.9)),
                          textAlign: TextAlign.center,
                        )))
              ]),
              Expanded(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return GridView.count(
                      padding: EdgeInsets.all(16),
                      crossAxisCount: 2,
                      primary: false,
                      children: <Widget>[
                        margin10(
                            homepageTile("/theZone", "The Zone", lightGreen)),
                        margin10(homepageTile("/picksAndPredictions",
                            "Picks & Predictions", brightPeachOrange)),
                        margin10(
                            homepageTile("/trivia/category", "Trivia", orange)),
                        margin10(
                            homepageTile("/debate", "Analyze & Debate", green)),
                      ],
                    );
                  },
                ),
              ),
            ])));
  }
}
