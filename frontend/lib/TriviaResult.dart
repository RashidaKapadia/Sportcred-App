import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
// import 'package:frontend/loginPage.dart';
//import 'package:frontend/homepage.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;

class TriviaResult extends StatefulWidget {
  int marks, incorrect, correct, notAnswered;
  TriviaResult({
    Key key,
    @required this.marks,
    @required this.incorrect,
    @required this.correct,
    @required this.notAnswered,
  }) : super(key: key);
  @override
  _TriviaResultState createState() =>
      _TriviaResultState(marks, incorrect, correct, notAnswered);
}

class _TriviaResultState extends State<TriviaResult> {
  int marks, incorrect, correct, notAnswered;
  _TriviaResultState(
      this.marks, this.incorrect, this.correct, this.notAnswered);

  // Http post request to update ACS
  Future updateACS(String username, String token) async {
    // Make the request and store the response
    final http.Response response =
        await http.post('http://localhost:8080/api/editACS"',
            headers: {
              'Content-Type': 'text/plain; charset=utf-8',
              'Accept': 'text/plain; charset=utf-8',
              'Access-Control-Allow-Origin': '*',
            },
            body: jsonEncode(<String, String>{
              "username": username,
              "token": token,
              "oppUsername": "N/A",
              "gameType": "Trivia Solo",
              "amount": this.marks.toString(),
              "date": DateTime.now().toString()
            }));

    // Check the type of response received from backend
    if (response.statusCode == 200) {
      print('SUCCESS - ACS UPDATED!');
      // Return true if ACS was updated successfully
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Send score through HTTP request to update this user's ACS
    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              updateACS(username.toString(), token.toString());
            })
          });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
          child: new ListView(children: [
            Container(
              color: Colors.blueGrey[900],
              height: 200,
              alignment: Alignment.center,
              child: Text(
                'Result',
                style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              padding: EdgeInsets.all(20.0),
              //decoration: BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(10)),
              //),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Your trivia result is as follows:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              // width: MediaQuery.of(context).size.width,
              child: Column(
                //direction: Axis.horizontal,
                children: [
                  Container(
                    width: 200.0,
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text('Correct: '),
                        Text(correct.toString() + '/10'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200.0,
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        Text('Incorrect: '),
                        Text(incorrect.toString() + '/10'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.blue),
                        Text('Not Answered: '),
                        Text(notAnswered.toString() + '/10'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35.0),
            Container(
              alignment: Alignment.center,
              child: Text('Total Score',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  )),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(marks.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: 35.0),
            RaisedButton(
              highlightElevation: 25.0,
              //color: Colors.black,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //color: Colors.lightGreen[800]
              child: Text(
                'Get My ACS History',
                style: TextStyle(color: Colors.blueGrey[900], fontSize: 20),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.of(context).pushNamed("/profile/ACSHistory");
              },
            ),
            RaisedButton(
              highlightElevation: 25.0,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //color: Colors.black,
              //color: Colors.lightGreen[800]
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(Icons.share)
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
              onPressed: () {},
            ),
          ]),
        ));
  }
}

/*
children: [
           Container(
            color: Colors.blueGrey[900],
            height: 200,
            alignment: Alignment.center,
            child: Text(
              'Result',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            padding: EdgeInsets.all(20.0),
            //decoration: BoxDecoration(
            //borderRadius: BorderRadius.all(Radius.circular(10)),
            //),
          ),
          Container(
             Text('Your trivia result is as follows:'),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                       Icon(Icons.check_circle, color: Colors.green),
                  Text('correct'+'/10'),
                    ],
                  )
,                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                  ),
                ),
            ),)
            Container(
              padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                       Icon(Icons.cancel, color: Colors.red),
                  Text('Incorrect'+'/10'),
                    ],
                  )
,                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                  ),
                ),
            ),
            ),
             Container(
              padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                       Icon(Icons.cancel, color: Colors.red),
                  Text('NotAnswered'+'/10'),
                    ],
                  )
,                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                  ),
                ),
            ),
            ),]
          )),],
          Container(
            Text('Total Score'),
          ),
          Container(
            Text('score'+'/10'),
          ),
          OutlineButton(
            highlightElevation: 25.0,
            color: Colors.black,
            //color: Colors.lightGreen[800]
            child: Text(
              'Get My ACS History',
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0)),
            onPressed: () {},
          ),
          OutlineButton(
            highlightElevation: 25.0,
            color: Colors.black,
            //color: Colors.lightGreen[800]
            child: Row(
              children: [
                Text(
                  'Share',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.share)
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0)),
            onPressed: () {},
          ),
          Container(
            Text("ScoreBoard",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
          )
        ],
*/
