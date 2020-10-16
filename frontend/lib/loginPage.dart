import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  @override
  _State_Of_Login_Page createState() => _State_Of_Login_Page();
}

class _State_Of_Login_Page extends State<loginPage> {
//To make app secure and easy to use, check whether the information the user
//has provided is valid. If the user has correctly filled out the form,
//process the information.
//If the user submits incorrect information, display a friendly error message
//letting them know what went wrong.

// To add validation we create a global key that uniquely identifies the
// Form widget and allows validation of the form.

// loginKey is the formKey here
  final _loginKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
            // appBar: AppBar(
            //title: Text('Sample App'),
            //   ),
            body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: Image.asset(
                          'assets/images/SportsCred_logo.png',
                          height: 250,
                          width: 100,
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Welcome, Sign in!',
                          style:
                              TextStyle(fontSize: 17, color: Color(0xFF9E9E9E)),
                        )),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            icon: Icon(Icons.person),
                            labelText: 'User Name',
                            // enabledBorder: UnderlineInputBorder(
                            //borderSide: BorderSide(color: Color(0xFFFFA000)),
                            // ),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          //border: OutlineInputBorder(),
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      textColor: Color(0xFFFF8F00),
                      child: Text('Forgot Password'),
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xFFFF8F00),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0)),
                          //side: BorderSide(color: Colors.black)),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            print(nameController.text);
                            print(passwordController.text);
                          },
                        )),
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
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ],
                ))));
  }
}
