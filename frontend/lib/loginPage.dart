import 'dart:async';
import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

// -- HTTP Request ---

class LoginStatus {
  final bool success;
  final String message;
  LoginStatus(this.success, this.message);
}

// Http post request to login
Future<LoginStatus> login(String username, String password) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    // new Uri.http("localhost:8080", "/api/login"),
    'http://localhost:8080/api/login',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    // Store the session token
    String token = jsonDecode(response.body)['token'];
    await FlutterSession().set('token', token);
    return LoginStatus(true, "Login successful!");
  } else if (response.statusCode == 403) {
    return LoginStatus(false, "Your username or password is incorrect.");
  } else {
    return LoginStatus(false, "Login failed, please contact your admin.");
  }

  return null;
}

// -- Widget --

class LoginPage extends StatefulWidget {
  @override
  _State_Of_Login_Page createState() => _State_Of_Login_Page();
}

class _State_Of_Login_Page extends State<LoginPage> {
//To make app secure and easy to use, check whether the information the user
//has provided is valid. If the user has correctly filled out the form,
//process the information.
//If the user submits incorrect information, display a friendly error message
//letting them know what went wrong.

// To add validation we create a global key that uniquely identifies the
// Form widget and allows validation of the form.

// loginKey is the formKey here
  final _formKey = GlobalKey<FormState>();
// holds the user information on logon page for access later on
  String username = "";
  String password = "";
  Future<LoginStatus> _futureLoginStatus;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final usernameValidator = RequiredValidator(errorText: "Incorrect Username");
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: "Incorrect Password"),
    //MinLengthValidator(8, errorText: "Password must have at least 8 characters")
  ]);

  // Can pull out to generalize
  Widget logoTitle() {
    return Container(
        padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        child: Image.asset(
          'assets/images/SportsCred_logo.png',
          height: 250,
          width: 100,
        ));
  }

  Widget loginStatus() {
    print("I am here");
    return FutureBuilder<LoginStatus>(
      future: _futureLoginStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.success) {
            print("SUCCESS");
            Navigator.of(context).pushNamed("/homepage");
            return Text(snapshot.data.message);
          }
          return Text(snapshot.data.message);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          print("I was here");
          return Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        logoTitle(),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Welcome, Sign in!',
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xFF9E9E9E)),
                            )),
                        (_futureLoginStatus != null)
                            ? loginStatus()
                            : Text("Enter your information below:"),
                        // Username field
                        TextFormField(
                          controller: nameController,
                          validator: usernameValidator,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'User Name',
                          ),
                          onSaved: (value) {
                            setState(() {
                              this.username = value;
                            });
                          },
                        ),
                        // Pasword field
                        TextFormField(
                          //padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          //child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          validator: passwordValidator,
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            icon: Icon(Icons.lock),
                            labelText: 'Password',
                          ),
                          onSaved: (value) {
                            setState(() {
                              this.password = value;
                            });
                          },
                        ),
                        // Forgot Password Link
                        FlatButton(
                          textColor: Color(0xFFFF8F00),
                          child: Text('Forgot Password'),
                          onPressed: () {
                            //Move to forgot password screen, to be implemented after
                          },
                        ),
                        // Login button
                        Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color(0xFFFF8F00),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0)),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  print("LogIn was successful!");

                                  _formKey.currentState.save();

                                  print(username);
                                  print(password);

                                  // Call the HTTP request to make an album
                                  _futureLoginStatus = login(
                                      nameController.text,
                                      passwordController.text);

                                  if (username == "test" &&
                                      password == "test") {
                                    Navigator.of(context)
                                        .pushNamed("/homepage");
                                  }

                                  if (_futureLoginStatus != null) {
                                    return loginStatus();
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        // Sign up Link
                        Container(
                            child: Row(
                          children: <Widget>[
                            Text('Not a member yet?'),
                            FlatButton(
                              textColor: Color(0xFFFF8F00),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                //signup screen
                                Navigator.of(context).pushNamed("/signup");
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))
                      ],
                    )))));
    // _loginKey yet to be used....
  }
}
