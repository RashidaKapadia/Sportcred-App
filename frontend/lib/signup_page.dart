import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './formFields.dart';
import './fieldStyles.dart';


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
  DateTime _dob;
  DateFormat _dateFormatter = new DateFormat('yyyy-MM-dd');

  List<String> _sportLevels = [
    'No history',
    'Recreational',
    'High School',
    'University',
    'Professional'
  ];
  List<DropdownMenuItem<String>> _dropDownItems = List();


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

    if (dateSelect != null && dateSelect != _dob) {
      setState(() {
        this._dob = dateSelect;
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
                                      _dob == null
                                          ? 'Please select a date'
                                          : '${_dateFormatter.format(this._dob)}',
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
                    items: _dropDownItems,
                    value: _sportLevel,
                    onChanged: (value) {
                      setState(() {
                        this._sportLevel = value;
                      });
                    }),
                SizedBox(height: 20.0),
                txtField('What sport would you like to know or learn about?'),
                TextFormField(
                  cursorColor: mainColour,
                  validator: (value) => checkInput(value, "answer"),
                  onChanged: (value) {
                    setState(() {
                      this._sportToLearn = value;
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
                      this._favTeam = value;
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
                      print(username);
                      print(email);
                      print(password1);
                      print(password2);
                      print(favSport);
                      print(_sportLevel);
                      print(_sportToLearn);
                      print(_favTeam);

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
