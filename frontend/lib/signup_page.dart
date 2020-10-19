import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import './formFields.dart';
import './fieldStyles.dart';

import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;

class SignUpStatus {
  final bool success;
  final String message;
  SignUpStatus(this.success, this.message);
}

// Http post request to login
Future<SignUpStatus> login(
    String username,
    String email,
    String password,
    String phoneNum,
    String favSport,
    String sportLevel,
    String sportToLearn,
    String favTeam,
    DateTime dob) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    // new Uri.http("localhost:8080", "/api/login"),
    'http://localhost:8080/api/signup',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, Object>{
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNum,
      'favSport': favSport,
      'sportLevel': sportLevel,
      'sportToLearn': sportToLearn,
      'favTeam': favTeam,
      'dob': dob
    }),
  );

  if (response.statusCode == 200) {
    // Store the session token
    String token = jsonDecode(response.body)['token'];
    await FlutterSession().set('token', token);
    return SignUpStatus(true, "SignUp successful!");
  } else if (response.statusCode == 403) {
    return SignUpStatus(false, "Your username or password is incorrect.");
  } else {
    return SignUpStatus(false, "Login failed, please contact your admin.");
  }

  return null;
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String username = ""; 
  String password1 = "";
  String password2 = "";
  String phoneNumber = "";
  String favSport = "";
  String sportLevel = "";
  String sportToLearn = "";
  String favTeam = "";
  DateTime dob;
  DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');

  List<String> sportLevels = [
    'No history',
    'Recreational',
    'High School',
    'University',
    'Professional'
  ];
  List<DropdownMenuItem<String>> dropDownItems = List();

  @override
  void initState() {
    createDropdownItems();
    sportLevel = dropDownItems[0].value;
    super.initState();
  }

  void createDropdownItems() {
    for (String item in sportLevels) {
      dropDownItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
  }

  Future<Null> _pickDate(BuildContext context) async {
    final dateSelect = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
                colorScheme: ColorScheme.light(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                    surface: Colors.orange,
                    onSurface: Colors.black87),
                primaryColor: Colors.orange),
            child: child,
          );
        });

    if (dateSelect != null && dateSelect != dob) {
      setState(() {
        this.dob = dateSelect;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            child: ListView(
              children: [
                SizedBox(height: 20.0),
                Image.asset('assets/Logo.png',
                    width: 250, height: 325, fit: BoxFit.cover),
                Text(
                  "Sign Up!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Username"),
                  decoration: inputDecorator(
                    'Username',
                    Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.username = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Email"),
                  decoration: inputDecorator(
                    'Email',
                    Icon(Icons.email),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Password"),
                  obscureText: true,
                  decoration: inputDecorator(
                    'Password',
                    Icon(Icons.lock),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.password1 = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Password"),
                  obscureText: true,
                  decoration: inputDecorator(
                    'Confirm password',
                    Icon(Icons.lock),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.password2 = value; // Set password2 to the value
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Phone number"),
                  decoration: inputDecorator(
                    'Phone number',
                    Icon(Icons.phone),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.phoneNumber = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black26, width: 2.0))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 12.0),
                                Icon(Icons.calendar_view_day,
                                    color: Colors.black45),
                                Text('  Date of Birth: ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black54)),
                                SizedBox(width: 20.0),
                              ]),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  _pickDate(context);
                                });
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dob == null
                                          ? 'Please select a date'
                                          : '${dateFormatter.format(this.dob)}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black54),
                                    ),
                                    SizedBox(width: 20.0),
                                    Icon(Icons.date_range_rounded,
                                        color: Colors.black45),
                                  ]))
                        ])),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "Favourite Sport"),
                  decoration: inputDecorator(
                    'Favourite sport',
                    Icon(Icons.sports_basketball),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.favSport = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                Text('What is your highest level of sport play?',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.leaderboard),
                    ),
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                    items: dropDownItems,
                    value: sportLevel,
                    onChanged: (value) {
                      setState(() {
                        this.sportLevel = value;
                      });
                    }),
                SizedBox(height: 20.0),
                txtField('What sport would you like to know or learn about?'),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "answer"),
                  onChanged: (value) {
                    setState(() {
                      this.sportToLearn = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                txtField('What is your favourite sports team?'),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "answer"),
                  onChanged: (value) {
                    setState(() {
                      this.favTeam = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: mainColour,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      /* print(username);
                      print(email);
                      print(password1);
                      print(password2);
                      print(favSport);
                      print(_sportLevel);
                      print(_sportToLearn);
                      print(_favTeam); */

                      Navigator.of(context).pushNamed("/welcome");
                      // if (_formKey.currentState.validate()){
                      // Data processing

                      // }
                    }),
              ],
            ),
          )),
    );
  }
}
