import 'dart:async';
import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'package:frontend/fieldStyles.dart';
import 'package:frontend/formHelper.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import 'package:http/http.dart' as http;

// -- HTTP Request ---

class LoginStatus {
  final bool success;
  final String message;
  LoginStatus(this.success, this.message);
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
  final _loginKey = GlobalKey<FormState>();
// holds the user information on logon page for access later on
  String username = "";
  String password = "";
  Future<LoginStatus> _futureLoginStatus;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      await FlutterSession().set('username', username);

      // String userSession =
      //     jsonEncode(<String, String>{'username': username, 'token': token});
      // await FlutterSession().set('user', '{"username": "apple"}');

      return LoginStatus(true, "Login successful!");
    } else if (response.statusCode == 403) {
      return LoginStatus(false, "Your username or password is incorrect.");
    } else {
      return LoginStatus(false, "Login failed, please contact your admin.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(10),
            child: Form(
                key: _loginKey,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        logoBanner(),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Welcome, Sign in!',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black87),
                            )),
                        vmargin10(Center(
                            child: (_futureLoginStatus != null)
                                ? getStatus(context, _futureLoginStatus)
                                : Text("",
                                    style: TextStyle(color: Colors.black54)))),
                        // Username field
                        TextFormField(
                          //padding: EdgeInsets.all(5),
                          //child: TextField(
                          controller: nameController,
                          validator: requiredValidator,
                          cursorColor: mainColour,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'User Name',
                          ),
                          onChanged: (value) {
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
                          cursorColor: mainColour,
                          controller: passwordController,
                          validator: requiredValidator,
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            icon: Icon(Icons.lock),
                            labelText: 'Password',
                          ),
                          onChanged: (value) {
                            setState(() {
                              this.password = value;
                            });
                          },
                        ),
                        // Forgot Password Link
                        vmargin10(FlatButton(
                          textColor: Color(0xFFFF8F00),
                          child: Text('Forgot Password'),
                          onPressed: () {
                            //Move to forgot password screen, to be implemented after
                          },
                        )),

                        // Login button
                        vmargin10(orangeButtonLarge(
                          text: "Login!",
                          onPressed: () {
                            setState(() {
                              // Validate the fields
                              if (_loginKey.currentState.validate()) {
                                // Make HTTP request
                                _futureLoginStatus = login(nameController.text,
                                    passwordController.text);

                                // If response has been returned, check the status and go to homepage if
                                // login was successful
                                if (_futureLoginStatus != null) {
                                  checkStatus(
                                      context, _futureLoginStatus, "/homepage");
                                }
                              } else {
                                errorPopup(context,
                                    "Please provide both your username and password.");
                              }
                            });
                          },
                        )),

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
                                //if (_loginKey.currentState.validate()) {
                                //_loginKey.currentState.save();

                                // the model object at this point can be POSTed
                                // to an API or persisted for further use

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
