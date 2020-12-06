import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/layout.dart';
import './navbar.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/profile_page.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isSelected = false;
  String name = "";
  String acs = "";

 // Http post request to get user info
  Future<UserInfo> getUserInfo(String username, String token) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getUserInfo',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'username': username, 'token': token}),
    );

    if (response.statusCode == 200) {
      UserInfo userData = UserInfo.fromJson(true, jsonDecode(response.body));

      setState(() {
        this.name = userData.firstname;
        this.acs = userData.acs.toString();
       
        print(this.name);

        storePrevValues();
      });

      return userData;
    } else if (response.statusCode == 403) {
      Navigator.of(context).pushNamed('/login');
      return UserInfo(reqStatus: false);
    } else {
      return UserInfo(reqStatus: false);
    }
  }

  void loadUsername() {
     FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              String store_token = token.toString();
               getUserInfo(username.toString(), store_token);
            })
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
                          "Welcome " + name + " (ACS: " + acs + ")" + "!",
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
