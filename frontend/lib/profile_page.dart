import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class ProfileStatus {
  final bool success;
  final String message;
  ProfileStatus(this.success, this.message);
}

// Http post request to get user info
Future<UserInfo> profile_get(String username) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    // new Uri.http("localhost:8080", "/api/getUserInfoe"),
    'http://localhost:8080/api/getUserInfo',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{'username': username}),
  );

  if (response.statusCode == 200) {
    // Store the session token
    // String user_info = jsonDecode(response.body)['string_respone'];
    return UserInfo.fromJson(jsonDecode(response.body));
    // return ProfileStatus(true, "Profile info fetched successfully");
  } else {
    throw Exception('Failed to get profile.');
  }
}

// Http post request to update user info
Future<UserInfo> profile_update(String username, String email, String status,
    String about, String dob, String tier, String acs) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    // new Uri.http("localhost:8080", "/api/getUserInfo"),
    'http://localhost:8080/api/updateUserInfo',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'email': email,
      'status': status,
      'about': about,
      'dob': dob,
      'acs': acs.toString(),
      'tier': tier
    }),
  );

  if (response.statusCode == 200) {
    // Store the session token
    // String user_info = jsonDecode(response.body)['string_respone'];
    return UserInfo.fromJson(jsonDecode(response.body));
    // return ProfileStatus(true, "Profile info fetched successfully");
  } else {
    throw Exception('Failed to update profile.');
  }
}

class UserInfo {
  final int acs;
  final String username;
  final String status;
  final String email;
  final String dob;
  final String about;
  final String tier;

  UserInfo(
      {this.acs,
      this.username,
      this.status,
      this.email,
      this.dob,
      this.about,
      this.tier});

  // converts json to UserInfo object
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      status: json['status'],
      email: json['email'],
      dob: json['dob'],
      about: json['about'],
      tier: json['tier'],
      acs: json['acs'],
    );
  }
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    Future<UserInfo> _futureUserInfo;
    _futureUserInfo = profile_get(username);

    if (_futureUserInfo != null) {}
    super.initState();
  }

  String acs = '314';
  String tier = 'FANANALYST';
  String username = 'JerryKing';
  TextEditingController _usernameController = TextEditingController()
    ..text = 'jking';
  TextEditingController _statusController = TextEditingController()
    ..text = 'Hungry for some basketball';
  TextEditingController _emailController = TextEditingController()
    ..text = 'jerry_king@gmail.com';
  TextEditingController _birthdayController = TextEditingController()
    ..text = '23 March 1975';
  TextEditingController _aboutController = TextEditingController()
    ..text = 'A history professor who is keen on basketball';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.black,
              onPressed: () => Navigator.of(context).pushNamed("/homepage")),
          title: Text("Profile"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: NavBar(),
        body: Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'ACS:' + '  ' + acs + '  [' + tier + ']',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            // new Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[
                            //     SizedBox(height: 20.0),
                            Image.asset('Jerry_King.jpg',
                                width: 250, height: 325, fit: BoxFit.cover),
                            //   ],
                            // ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 50.0, right: 50, top: 15.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Status:',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 50.0, right: 25.0, top: 50.0),
                            child: Container(
                              child: new TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Add status here',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                // onChanged: (text) {
                                //   setState(() {
                                //     _statusController =
                                //         TextEditingController(text: text);
                                //     //you can access nameController in its scope to get
                                //     // the value of text entered as shown below
                                //     //fullName = nameController.text;
                                //   });
                                // },
                                style: TextStyle(fontSize: 16.0),
                                enabled: !_status,
                                autofocus: !_status,
                                controller: _statusController,
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 15.0),
                              child: new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      'Username:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.topLeft,
                                          child: new Column(children: <Widget>[
                                            new TextField(
                                              // onChanged: (text) {
                                              //   setState(() {
                                              //     username = text;
                                              //   });
                                              // },
                                              style: TextStyle(fontSize: 16.0),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              enabled: !_status,
                                              autofocus: !_status,
                                              controller: _usernameController,
                                            ),
                                          ])),
                                      flex: 2),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    child: new Text(
                                      'About:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          child: new TextField(
                                        // onChanged: (text) {
                                        //   setState(() {
                                        //     _aboutController =
                                        //         TextEditingController(text: text);
                                        //   });
                                        // },
                                        style: TextStyle(fontSize: 16.0),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        enabled: !_status,
                                        autofocus: !_status,
                                        controller: _aboutController,
                                      )),
                                      flex: 2),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    child: new Text(
                                      'Email:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                        child: new TextField(
                                          // onChanged: (text) {
                                          //   setState(() {
                                          //     _emailController =
                                          //         TextEditingController(text: text);
                                          //   });
                                          // },
                                          style: TextStyle(fontSize: 16.0),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          enabled: !_status,
                                          autofocus: !_status,
                                          controller: _emailController,
                                        ),
                                      ),
                                      flex: 2),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 50.0, top: 15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    child: new Text(
                                      'Birthday:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                        child: new TextField(
                                          // onChanged: (text) {
                                          //   setState(() {
                                          //     _birthdayController =
                                          //         TextEditingController(text: text);
                                          //   });
                                          // },
                                          style: TextStyle(fontSize: 16.0),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          enabled: !_status,
                                          autofocus: !_status,
                                          controller: _birthdayController,
                                        ),
                                      ),
                                      flex: 2),
                                ],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    _usernameController = TextEditingController(text: username);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    //username = '';
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
