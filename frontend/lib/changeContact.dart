import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import 'formHelper.dart';

// -- HTTP Request ---
class ContactStatus {
  final bool success;
  final String message;
  ContactStatus(this.success, this.message);
}

class ChangeContact extends StatefulWidget {
  @override
  _ChangeContactState createState() => _ChangeContactState();
}

class Contact {
  final String username;
  final String oldEmail;
  final String newEmail;
  final String oldPhone;
  final String newPhone;
  final bool reqStatus;

  Contact(
      {this.username = "",
      this.oldEmail = "",
      this.newEmail = "",
      this.oldPhone = "",
      this.newPhone = "",
      @required this.reqStatus});

  // converts json to Password object
  factory Contact.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return Contact(
        reqStatus: status,
      );
    }

    return Contact(
        reqStatus: status,
        username: json['username'],
        oldEmail: json['email'],
        oldPhone: json['phoneNumber']);
    ;
  }
}

class _ChangeContactState extends State<ChangeContact>
    with SingleTickerProviderStateMixin {
  String username = "";
  String oldEmail, oldPhone, newEmail, newPhone = "";

  Future<Contact> _futureContact;
  Future<ContactStatus> _futureContactStatus;
  @override
  void initState() {
    super.initState();

    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              this.username = username.toString();
              String store_token = token.toString();
              _futureContact = contactGet(username.toString(), store_token);
            })
          });
    });
  }

  // Http post request to get user info
  Future<Contact> contactGet(String username, String token) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getUserInfo',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'username': username, 'token': token}),
    );

    if (response.statusCode == 200) {
      Contact userData = Contact.fromJson(true, jsonDecode(response.body));

      setState(() {
        this.username = userData.username;
        this.oldEmail = userData.oldEmail;
        this.oldPhone = userData.oldPhone;
      });

      return userData;
    } else if (response.statusCode == 403) {
      Navigator.of(context).pushNamed('/login');
      return Contact(reqStatus: false);
    } else {
      return Contact(reqStatus: false);
    }
  }

// Http post request to update user info
  Future<ContactStatus> contactUpdate(
      String username, String email, String phoneNumber) async {
    print("making request");

    // Make the request and store the response
    final http.Response response = await http.post(
      // new Uri.http("localhost:8080", "/api/getUserInfo"),
      'http://localhost:8080/api/updateUserContact',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber
      }),
    );

    if (response.statusCode == 200) {
      return ContactStatus(true, "Contact Updated Successfully");
    } else {
      return ContactStatus(false, "Could not update Email/Phone Number");
    }
  }

  void changeEmailOnUI() {
    setState(() => this.oldEmail = this.newEmail);
  }

  void changePhoneOnUI() {
    setState(() => this.oldPhone = this.newPhone);
  }

  @override
  Widget build(BuildContext context) {
    final oldEmail = new Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.blue, width: 2)),
      child: Text("Email: " + this.oldEmail),
    );
    final newEmail = TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "New Email",
            helperText: 'Example: abc@xyz.com',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onChanged: (value) {
          setState(() {
            this.newEmail = value;
          });
        });
    final oldPhone = new Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.blue, width: 2)),
      child: Text("Phone Number: " + this.oldPhone),
    );
    final newPhone = TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "New Phone Number",
            helperText: 'Minimum characters is 9',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onChanged: (value) {
          setState(() {
            this.newPhone = value;
          });
        });
    final changeContact = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            String dateRegex =
                "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
            bool emailValid = RegExp(dateRegex).hasMatch(this.newEmail);
            if (this.newEmail == null || this.newEmail == "") {
              print("Email is null");
              this.newEmail = this.oldEmail;
            }
            if (this.newPhone == null || this.newPhone == "") {
              this.newPhone = this.oldPhone;
            }
            if (this.newPhone.length < 9) {
              errorPopup(
                  context, "Phone Number must be atleast 9 characters long");
            } else if (!emailValid) {
              errorPopup(context,
                  "Email format incorrect: must be similar to abc@xyz.com");
            } else {
              // Call API
              _futureContactStatus =
                  contactUpdate(this.username, this.newEmail, this.newPhone);
              if (_futureContactStatus != null) {
                checkStatus(context, _futureContactStatus);
              }
            }
          },
          child: Text("CONFIRM", textAlign: TextAlign.center)),
    );
    print("INFO CONTACT: " + this.oldEmail + this.oldPhone);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed("/settings")),
        title: Text(
          "Change Contact Info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25.0),
                oldEmail,
                SizedBox(height: 25.0),
                newEmail,
                SizedBox(height: 25.0),
                oldPhone,
                SizedBox(height: 25.0),
                newPhone,
                SizedBox(
                  height: 35.0,
                ),
                changeContact,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkStatus(BuildContext context, Future status) async {
    await status.then((snapshot) {
      print('YAYY');
      print(snapshot);
      print(snapshot.message);
      if (snapshot.success) {
        print("HEREE");
        popUp(context, "Success", snapshot.message);
        changeEmailOnUI();
        changePhoneOnUI();
      } else {
        errorPopup(context, snapshot.message);
      }
    });
  }
}
