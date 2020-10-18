import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String username;

  String acs = '314';
  String tier = 'FANANALYST';

  TextEditingController _usernameController = TextEditingController()
    ..text = 'jking';
  TextEditingController _statusController = TextEditingController()
    ..text = 'Hungry for some basketball';
  TextEditingController _emailController = TextEditingController()
    ..text = 'jerry_king@gmail.com';
  TextEditingController _birthdayController = TextEditingController()
    ..text = '23 March 1975';
  TextEditingController _aboutController = TextEditingController()
    ..text = 'A history professor who is keen on basketball';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 500.0),
                              child: new Text('PROFILE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 450.0, top: 50.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'ACS:' + '  ' + acs + '  [' + tier + ']',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.green[300],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        // new Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     SizedBox(height: 20.0),
                        Image.asset('Jerry_King.jpg',
                            width: 250, height: 325, fit: BoxFit.cover),
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
                          padding:
                              EdgeInsets.only(left: 50.0, right: 50, top: 15.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, right: 25.0, top: 50.0),
                        child: Container(
                          child: new TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add status here',
                            ),
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
                      Padding(
                          padding: EdgeInsets.only(left: 50.0, top: 15.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    'Username:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: new Column(children: <Widget>[
                                      new TextField(
                                        // onChanged: (text) {
                                        //   setState(() {
                                        //     username = text;
                                        //   });
                                        // },
                                        style: TextStyle(fontSize: 16.0),
                                        enabled: !_status,
                                        autofocus: !_status,
                                        controller: _usernameController,
                                      ),
                                    ])),
                              ),
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
                                    'About:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
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
                                    enabled: !_status,
                                    autofocus: !_status,
                                    controller: _aboutController,
                                  ),
                                ),
                              ),
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
                                ),
                                flex: 2,
                              ),
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
                                    enabled: !_status,
                                    autofocus: !_status,
                                    controller: _emailController,
                                  ),
                                ),
                              ),
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
                                ),
                                flex: 2,
                              ),
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
                                    enabled: !_status,
                                    autofocus: !_status,
                                    controller: _birthdayController,
                                  ),
                                ),
                              ),
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
                    _usernameController = TextEditingController(text: username);
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
                    //username = '';
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
