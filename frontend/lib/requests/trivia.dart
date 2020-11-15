import 'dart:convert';
import 'package:http/http.dart' as http;

// Http post request to update ACS
Future updateACS(String token, String username, int score) async {
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
            "amount": score.toString(),
            "date": DateTime.now().toString()
          }));

  // Check the type of response received from backend
  return (response.statusCode == 200);
}
