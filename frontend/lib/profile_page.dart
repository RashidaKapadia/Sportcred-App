import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;

String old_username, old_status, old_email, old_birthday, old_about;

TextEditingController _usernameController = TextEditingController()..text = '';
TextEditingController _statusController = TextEditingController()..text = '';
TextEditingController _emailController = TextEditingController()..text = '';
TextEditingController _birthdayController = TextEditingController()..text = '';
TextEditingController _aboutController = TextEditingController()..text = '';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class ProfileStatus {
  final bool success;
  final UserInfo userInfo;
  ProfileStatus(this.success, this.userInfo);
}

class UserInfo {
  final String acs;
  final String username;
  final String status;
  final String email;
  final String dob;
  final String about;
  final String tier;
  final bool reqStatus;

  UserInfo(
      {this.acs,
      this.username,
      this.status,
      this.email,
      this.dob,
      this.about,
      this.tier,
      @required this.reqStatus});

  // converts json to UserInfo object
  factory UserInfo.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return UserInfo(
        reqStatus: status,
      );
    }

    return UserInfo(
      reqStatus: status,
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

void storePrevValues() {
  old_username = _usernameController.text;
  old_status = _statusController.text;
  old_birthday = _birthdayController.text;
  old_about = _aboutController.text;
  old_email = _emailController.text;
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  // Initialize values
  String acs = "";
  String tier = "";
  String username = "";

  // TODO:

  @override
  void initState() {
    super.initState();

    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              _futureUserInfo =
                  profileGet(username.toString(), token.toString());
            })
          });
    });
  }

  Future<UserInfo> _futureUserInfo;

  // Http post request to get user info
  Future<UserInfo> profileGet(String username, String token) async {
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
        this.username = userData.username;
        this.acs = userData.acs;
        this.tier = userData.tier;

        _usernameController..text = this.username;
        _statusController..text = userData.status;
        _birthdayController..text = userData.dob;
        _aboutController..text = userData.about;
        _emailController..text = userData.email;

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

// Http post request to update user info
  Future<UserInfo> profileUpdate(String username, String email, String status,
      String about, String dob, String acs) async {
    print("making request");

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
        'acs': acs,
      }),
    );

    if (response.statusCode == 200) {
      return UserInfo(reqStatus: true);
    } else if (response.statusCode == 403) {
      Navigator.of(context).pushNamed('/login');
    } else {
      return UserInfo(reqStatus: false);
    }
  }

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Profile", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.black),
        bottomNavigationBar: NavBar(2),
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
                                    _usernameController.text,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                flex: 2),
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'ACS:' +
                                      '  ' +
                                      this.acs +
                                      '  [' +
                                      this.tier +
                                      ']',
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
                          padding: EdgeInsets.only(top: 30.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            // new Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[
                            //     SizedBox(height: 20.0),
                            Image.asset('profile_icon.png',
                                width: 150, height: 125, fit: BoxFit.fitWidth),
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
                                left: 50.0, right: 25.0, top: 30.0),
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
                          // Padding(
                          //     padding: EdgeInsets.only(left: 50.0, top: 15.0),
                          //     child: new Row(
                          //       children: <Widget>[
                          //         Expanded(
                          //             child: Container(
                          //           alignment: Alignment.topLeft,
                          //           child: new Text(
                          //             'Username:',
                          //             style: TextStyle(
                          //                 fontSize: 16.0,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //         )),
                          //         Expanded(
                          //             child: Container(
                          //                 alignment: Alignment.topLeft,
                          //                 child: new Column(children: <Widget>[
                          //                   new TextField(
                          //                     // onChanged: (text) {
                          //                     //   setState(() {
                          //                     //     username = text;
                          //                     //   });
                          //                     // },
                          //                     style: TextStyle(fontSize: 16.0),
                          //                     keyboardType:
                          //                         TextInputType.multiline,
                          //                     maxLines: null,
                          //                     enabled: !_status,
                          //                     autofocus: !_status,
                          //                     controller: _usernameController,
                          //                   ),
                          //                 ])),
                          //             flex: 2),
                          //       ],
                          //     )),
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
                    storePrevValues();
                    // HTTP request to update profile
                    profileUpdate(
                        this.username,
                        _emailController.value.text,
                        _statusController.value.text,
                        _aboutController.value.text,
                        _birthdayController.value.text,
                        this.acs.toString());

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
                    _statusController = TextEditingController(text: old_status);

                    _usernameController =
                        TextEditingController(text: old_username);

                    _aboutController = TextEditingController(text: old_about);

                    _emailController = TextEditingController(text: old_email);

                    _birthdayController =
                        TextEditingController(text: old_birthday);

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
