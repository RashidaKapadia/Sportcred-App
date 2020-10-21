import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import './formFields.dart';
import './fieldStyles.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:http/http.dart' as http;

class SignUpStatus {
  final bool success;
  final String message;
  SignUpStatus(this.success, this.message);
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
  // Initialize dropdown items
  List<DropdownMenuItem<String>> dropDownItems = List();

  Future<SignUpStatus> _futureSignUpStatus;

  TextEditingController password1Controller = TextEditingController();

  bool signupSuccess = false;

// Http post request to signup
  Future<SignUpStatus> signUp(
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

    // Check the type of response received from backend
    if (response.statusCode == 200) {
      // Go to the welcome page if sign up was successful
      Navigator.of(context).pushNamed('/welcome');
      return SignUpStatus(true, "SignUp successful!");
    } else if (response.statusCode == 409) {
      return SignUpStatus(false, "Username or email already exists.");
    } else {
      return SignUpStatus(false, "Sign up failed, please contact your admin.");
    }

    return null;
  }

  /// Indicates signup status based on the response
  Widget signupStatus() {
    return FutureBuilder<SignUpStatus>(
      future: _futureSignUpStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // DEBUGGING
          if (snapshot.data.success) {
            print('SUCCESS');
          }
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

  @override
  void initState() {
    createDropdownItems();
    sportLevel = dropDownItems[0].value;
    super.initState();
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
      cursorColor: mainColour,
      validator: requiredValidator,
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
      cursorColor: mainColour,
      validator: emailValidator,
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
      validator: passwordValidator,
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
      cursorColor: mainColour,
      validator: (val) => MatchValidator(
        errorText: 'Passwords do not match',
      ).validateMatch(val, password1Controller.value.text),
      obscureText: true,
      decoration: inputDecorator(
        'Confirm Password',
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
      validator: requiredValidator,
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: txtField("Date of Birth:"),
        ),
        TextFormField(
          cursorColor: mainColour,
          onTap: () {
            setState(() {
              _pickDate(context);
            });
          },
          decoration: InputDecoration(
              hintText: dob == null
                  ? 'YYYY-MM-DD'
                  : '${dateFormatter.format(this.dob)}',
              prefixIcon: Icon(Icons.calendar_view_day),
              suffixIcon: Icon(Icons.date_range_outlined)),
        ),
      ],
    );
  }

  Widget getFavouriteSport() {
    return TextFormField(
      cursorColor: mainColour,
      validator: requiredValidator,
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
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'What is your highest level of sport play?',
        labelStyle: TextStyle(fontSize: 17),
        prefixIcon: Icon(Icons.leaderboard),
      ),
      style: TextStyle(fontSize: 17, color: Colors.black87),
      items: dropDownItems,
      value: sportLevel,
      onChanged: (value) {
        setState(() {
          this.sportLevel = value;
        });
      },
    );
  }

  Widget getSportToLearn() {
    return TextFormField(
      cursorColor: mainColour,
      validator: requiredValidator,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.question_answer),
          labelText: 'What sport would you like to know or learn about?',
          hintText: 'Enter your answer'),
      onSaved: (value) {
        setState(() {
          this.sportToLearn = value;
        });
      },
    );
  }

  Widget getFavouriteTeam() {
    return TextFormField(
      cursorColor: mainColour,
      validator: requiredValidator,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.question_answer),
        labelText: 'What is your favourite sports team?',
        hintText: 'Enter your answer',
      ),
      onSaved: (value) {
        setState(() {
          this.favTeam = value;
        });
      },
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
                      if (_formKey.currentState.validate()) {
                        print("Sign up was successful!");

                        _formKey.currentState.save();

                        // For debugging
                        print(username);
                        print(password1);
                        print(email);
                        print(phoneNumber);
                        print(favSport);
                        print(sportLevel);
                        print(sportToLearn);
                        print(favTeam);
                        print('${dateFormatter.format(this.dob)}');

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
                          '${dateFormatter.format(this.dob)}',
                        );
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
