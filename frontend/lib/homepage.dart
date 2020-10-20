import 'package:flutter/material.dart';
import './navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isSelected = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(),
        body: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(child: Image.asset('assets/Logo.png')),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return GridView.count(
                  padding: EdgeInsets.all(30),
                  crossAxisCount: 4,
                  primary: false,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 25.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text("The Zone"),
                        color: Colors.redAccent,
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 25.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text("Picks & Predictions"),
                        color: Colors.orangeAccent,
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 25.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text("Trivia"),
                        color: Colors.yellowAccent[100],
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 25.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text("Analyze & Debate"),
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ]));
  }
}
