import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class Password {
  final String username;
  final String newpassword;
  final String oldpassword;
  final bool reqStatus;

  Password(
      {this.username,
      this.oldpassword,
      this.newpassword,
      @required this.reqStatus});

  // converts json to Password object
  factory Password.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return Password(
        reqStatus: status,
      );
    }

    return Password(
        reqStatus: status,
        username: json['username'],
        oldpassword: json['oldpassword'],
        newpassword: json['newpassword']);
  }
}

Future<Password> _futureUserInfo;

// Http post request to update user info
Future<Password> passwordUpdate(
    String username, String newPassword, String oldPassword) async {
  print("making request");

  // Make the request and store the response
  final http.Response response = await http.post(
    // new Uri.http("localhost:8080", "/api/getUserInfo"),
    'http://localhost:8080/api/updateUserPassword',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'newPassword': newPassword,
      'oldPassword': oldPassword
    }),
  );

  if (response.statusCode == 200) {
    return Password(reqStatus: true);
  } else {
    return Password(reqStatus: false);
  }
}

class _ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  String input_old, input_new = "";
  String username = "";
  @override
  void initState() {
    super.initState();

    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              username = username.toString();
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final oldPassword = TextField(
        obscureText: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Old Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onChanged: (value) {
          setState(() {
            this.input_old = value;
          });
        });
    final newPassword = TextField(
        obscureText: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "New Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onChanged: (value) {
          setState(() {
            this.input_new = value;
          });
        });
    final changePassword = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            // Call API
            passwordUpdate(username, input_new, input_old);
          },
          child: Text("CONFIRM", textAlign: TextAlign.center)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed("/settings")),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25.0),
                oldPassword,
                SizedBox(height: 25.0),
                newPassword,
                SizedBox(
                  height: 35.0,
                ),
                changePassword,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
