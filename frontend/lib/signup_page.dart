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
    String dob) async {
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

  // Store the session token
  String token = jsonDecode(response.body)['token'];
  await FlutterSession().set('token', token);
  // Check the type of response received from backend
  if (response.statusCode == 200) {
    return SignUpStatus(true, "SignUp successful!");
  } else if (response.statusCode == 409) {
    return SignUpStatus(
        false, "Username or email already exists.");
  } else {
    return SignUpStatus(false, "Sign up failed, please contact your admin.");
  }
      
  return null;
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

// Signup fields
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

  Future<SignUpStatus> _futureSignUpStatus;

  //TextEditingController emailController = TextEditingController();
  //TextEditingController usernameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController(); // needed to check that passwords match
  TextEditingController password2Controller = TextEditingController();
  //TextEditingController phoneNumberController = TextEditingController();
  //TextEditingController favSportController = TextEditingController();
  //TextEditingController sportLevelController = TextEditingController();
  //TextEditingController sportToLearnController = TextEditingController();
  //TextEditingController favTeamController = TextEditingController();
  
  @override
  void initState() {
    createDropdownItems();
    sportLevel = dropDownItems[0].value;
    super.initState();
  }

/// Indicates signup status based on the response
  Widget signupStatus() {
    return FutureBuilder<SignUpStatus>(
      future: _futureSignUpStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //Navigator.of(context).pushNamed("/welcome");
          return Text(snapshot.data.message);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
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

///Creates the dropdownitems for drop down field
  void createDropdownItems() {
    for (String item in sportLevels) {
      dropDownItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
  }

  /// Date picker
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

  Widget getUsername() {
    return TextFormField(
      // controller: usernameController,
      cursorColor: mainColour,
      validator: (value) => checkInput(value, "Username"),
      decoration: inputDecorator(
        'Username',
        Icon(Icons.person),
      ),
      onSaved: (value) {
        setState(() {
          this.username = value;
        });
      },
    );
  }

  Widget getEmail() {
    return TextFormField(
      //   controller: emailController,
      cursorColor: mainColour,
      validator: (value) => checkInput(value, "Email"),
      decoration: inputDecorator(
        'Email',
        Icon(Icons.email),
      ),
      onSaved: (value) {
        setState(() {
          this.email = value;
        });
      },
    );
  }

  Widget getPassword1() {
    return TextFormField(
      controller: password1Controller,
      cursorColor: mainColour,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your password!";
        } else if (value.length < 8) {
          return "Your password must have at least 8 characters.";
        } else {
          return null;
        }
      },
      obscureText: true,
      decoration: inputDecorator(
        'Password',
        Icon(Icons.lock),
      ),
      onSaved: (value) {
        setState(() {
          this.password1 = value;
        });
      },
    );
  }

  Widget getPassword2() {
    return TextFormField(
      controller: password2Controller,
      cursorColor: mainColour,
      validator: (value) {
        if (password1Controller.value.text != value) {
          return "Passwords don't match!";
        } else {
          return null;
        }
      },
      obscureText: true,
      decoration: inputDecorator(
        'Password',
        Icon(Icons.lock),
      ),
      onSaved: (value) {
        setState(() {
          this.password2 = value;
        });
      },
    );
  }

  Widget getPhoneNumber() {
    return TextFormField(
      cursorColor: mainColour,
      validator: (value) => checkInput(value, "Phone number"),
      decoration: inputDecorator(
        'Phone number',
        Icon(Icons.phone),
      ),
      onSaved: (value) {
        setState(() {
          this.phoneNumber = value;
        });
      },
    );
  }

  Widget getDateOfBirth() {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black26, width: 2.0))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 12.0),
            Icon(Icons.calendar_view_day, color: Colors.black45),
            Text('  Date of Birth: ',
                style: TextStyle(fontSize: 17, color: Colors.black54)),
            SizedBox(width: 20.0),
          ]),
          FlatButton(
              onPressed: () {
                setState(() {
                  _pickDate(context);
                });
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dob == null
                          ? 'Please select a date'
                          : '${dateFormatter.format(this.dob)}',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                    SizedBox(width: 20.0),
                    Icon(Icons.date_range_rounded, color: Colors.black45),
                  ]))
        ]));
  }

  Widget getFavouriteSport() {
    return TextFormField(
      //  controller: favSportController,
      cursorColor: mainColour,
      validator: (value) => checkInput(value, "Favourite Sport"),
      decoration: inputDecorator(
        'Favourite sport',
        Icon(Icons.sports_basketball),
      ),
      onSaved: (value) {
        this.favSport = value;
      },
    );
  }

  Widget getHighestSportLevel() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget getSportToLearn() {
    return Column(
      children: [
        txtField('What sport would you like to know or learn about?'),
        TextFormField(
          // controller: sportToLearnController,
          cursorColor: mainColour,
          validator: (value) => checkInput(value, "answer"),
          onSaved: (value) {
            setState(() {
              this.sportToLearn = value;
            });
          },
        )
      ],
    );
  }

  Widget getFavouriteTeam() {
    return Column(
      children: [
        txtField('What is your favourite sports team?'),
        TextFormField(
          // controller: favTeamController,
          cursorColor: mainColour,
          validator: (value) => checkInput(value, "answer"),
          onSaved: (value) {
            setState(() {
              this.favTeam = value;
            });
          },
        )
      ],
    );
  }

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
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
                (_futureSignUpStatus != null)
                    ? signupStatus()
                    : Text("Enter your information below:"),
                SizedBox(height: 20.0),
                getUsername(),
                SizedBox(height: 20.0),
                getEmail(),
                SizedBox(
                  height: 20.0,
                ),
                getPassword1(),
                SizedBox(
                  height: 20.0,
                ),
                getPassword2(),
                SizedBox(
                  height: 20.0,
                ),
                getPhoneNumber(),
                SizedBox(
                  height: 20.0,
                ),
                getDateOfBirth(),
                SizedBox(
                  height: 20.0,
                ),
                getFavouriteSport(),
                SizedBox(height: 20.0),
                getHighestSportLevel(),
                SizedBox(height: 20.0),
                getSportToLearn(),
                SizedBox(height: 20.0),
                getFavouriteTeam(),
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
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        print("Sign up was successful!");

                        _formKey.currentState.save();

                        // Call the HTTP request
                        _futureSignUpStatus = signUp(
                            username,
                            email,
                            password1,
                            phoneNumber,
                            favSport,
                            sportLevel,
                            sportToLearn,
                            favTeam,
                            dob.toString());

                      //  if (_futureSignUpStatus != null) {}
                      }
                    });

                    //Navigator.of(context).pushNamed("/welcome");
                    // if (_formKey.currentState.validate()){
                    // Data processing

                    // }
                  },
                ),

              ],
            ),
          )),
    );
  }
}
