import 'package:flutter/material.dart';
import './welcome_page.dart';

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
  String _sportLevel = "";
  String _sportToLearn = "";
  String _favTeam = "";

  List<String> _sportLevels = [
    'No history',
    'Recreational',
    'High School',
    'University',
    'Professional'
  ];
  List<DropdownMenuItem<String>> _dropDownItems = List();

  int age;

  @override
  void initState() {
    createDropdownItems();
    _sportLevel = _dropDownItems[0].value;
    super.initState();
  }

  void createDropdownItems() {
    for (String item in _sportLevels) {
      _dropDownItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            accentColor: Colors.orangeAccent,
            primaryColor: Colors.orangeAccent),
        home: Scaffold(
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
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your username!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.username = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your email!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your password!";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
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
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please reenter your password!";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
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
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your phone number!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
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
                    TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your age!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(
                          Icons.calendar_view_day_outlined,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.age = int.parse(value);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your favourite sport!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Favourite Sport',
                        prefixIcon: Icon(
                          Icons.sports_basketball,
                        ),
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
                            prefixIcon: Icon(Icons.leaderboard)),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        items: _dropDownItems,
                        value: _sportLevel,
                        onChanged: (value) {
                          setState(() {
                            this._sportLevel = value;
                          });
                        }),
                    SizedBox(height: 20.0),
                    Text('What sport would you like to know or learn about?',
                        style: TextStyle(fontSize: 18, color: Colors.black54)),
                    TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide an answer!";
                        }
                        return null;
                      },
                      showCursor: true,
                      onChanged: (value) {
                        setState(() {
                          this._sportToLearn = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text('What is your favourite sports team?',
                        style: TextStyle(fontSize: 18, color: Colors.black54)),
                    TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide an answer!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          this._favTeam = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          print(username);
                          print(email);
                          print(password1);
                          print(password2);
                          print(age);
                          print(favSport);
                          print(_sportLevel);
                          print(_sportToLearn);
                          print(_favTeam);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomePage()));
                          // if (_formKey.currentState.validate()){
                          // Data processing

                          // }
                        }),
                  ],
                ),
              )),
        ));
  }
}
