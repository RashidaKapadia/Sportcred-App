import 'package:flutter/material.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';

class ACSHistoryPage extends StatefulWidget {
  @override
  _ACSHistoryPageState createState() => _ACSHistoryPageState();
}

int historyAmount = 0;

class ACS {
  final List<dynamic> amount;
  final List<dynamic> date;
  final List<dynamic> oppUserane;
  final List<dynamic> gameType;

  ACS({this.amount, this.date, this.oppUserane, this.gameType});

  // converts json to ACS object
  factory ACS.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      print("json was null");
      return ACS(
          // reqStatus: status,
          );
    }
    print(json['amount']);
    return ACS(
        amount: json['amount'],
        date: json['date'],
        oppUserane: json['oppUserane'],
        gameType: json['gameType']);
  }
}

class _ACSHistoryPageState extends State<ACSHistoryPage> {
  var isSelected = false;
  Future<ACS> _futureACS;

  // Initialize values
  List<dynamic> amount;
  List<dynamic> date;
  List<dynamic> oppUserane;
  List<dynamic> gameType;

  // Http post request to get user acs history
  Future<ACS> getACSHistory(String username, String token, int amount) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getACS',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(
          <String, String>{'username': username, "amount": amount.toString()}),
    );

    if (response.statusCode == 200) {
      // Store the session token
      ACS acsHistory = ACS.fromJson(true, jsonDecode(response.body));
      setState(() {
        if (acsHistory != null) {
          this.amount = acsHistory.amount;
          this.date = acsHistory.date;
          this.oppUserane = acsHistory.oppUserane;
          this.gameType = acsHistory.gameType;
          print(this.gameType);
          print(acsHistory.gameType);
        }
      });
      int count = 0;
      for (dynamic i in acsHistory.amount) {
        if (i == null) {
          historyAmount = count;
          break;
        }
        count++;
      }
      return acsHistory;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    if (FlutterSession() != null) {
      FlutterSession().get('token').then((token) {
        FlutterSession().get('username').then((username) => {
              setState(() {
                historyAmount = 0;
                String store_token = token.toString();
                _futureACS =
                    getACSHistory(username.toString(), store_token, 10);
              })
            });
      });
    }

    if (_futureACS != null) {}

    super.initState();
  }

  Column printHistory(int i) {
    int match = this.date[i].indexOf(':');
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                child: new Text(
                  this.date[i].substring(0, match + 3),
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                      top: BorderSide(color: Colors.black, width: 4),
                      bottom: BorderSide(color: Colors.black, width: 4),
                      left: BorderSide(color: Colors.black, width: 4),
                      right: BorderSide(color: Colors.black, width: 4)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4)),
                  color: int.parse(this.amount[i]) >= 0
                      ? Colors.green
                      : int.parse(this.amount[i]) <= 0
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: new Text(
                  this.gameType[i],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: int.parse(this.amount[i]) >= 0
                      ? Colors.green
                      : int.parse(this.amount[i]) <= 0
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  this.oppUserane[i],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: int.parse(this.amount[i]) >= 0
                      ? Colors.green
                      : int.parse(this.amount[i]) <= 0
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  this.amount[i],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                margin: const EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: int.parse(this.amount[i]) >= 0
                      ? Colors.green
                      : int.parse(this.amount[i]) <= 0
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(0),
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pushNamed("/profile")),
          title: Text("ACS History", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.black),
      body: Column(children: <Widget>[
        // Container(children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(height: 100),
            Expanded(
              flex: 3,
              child: Container(
                child: new Text(
                  "Date",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: new Text(
                  "Game Type",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  "Opponent",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  "Points",
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10.0),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Wrap(
            direction: Axis.horizontal,
            // shringWrap: true,
            children: List.generate(historyAmount, (index) {
              return printHistory(index);
            }),
          ),
        )
        // ]),
      ]),
    );
  }
}
