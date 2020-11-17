import 'dart:convert';
import 'package:http/http.dart' as http;

class UserInfo {
  final String firstname;
  final String lastname;
  final String username;

  UserInfo({this.firstname, this.lastname, this.username});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        firstname: json['firstname'],
        lastname: json['lastname'],
        username: json['username']);
  }
}

// Http post request to get user info
Future<List<UserInfo>> getUsers() async {
  // Make the request and store the response
  final http.Response response = await http.post(
    'http://localhost:8080/api/get-users-list',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    List<UserInfo> users = [];

    // Get the questions, options and correctAnswers and store them in the class variables
    for (Map<String, dynamic> user in jsonDecode(response.body) as List) {
      users += [UserInfo.fromJson(user)];
    }
    return users;
  } else {
    return null;
  }
}
