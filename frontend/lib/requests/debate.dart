import 'dart:convert';
import 'package:http/http.dart' as http;

var defaultHeaders = {
  'Content-Type': 'text/plain; charset=utf-8',
  'Accept': 'text/plain; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
};

/**
 * Submits the votes for the debate group
 */
Future submitVotes(String groupId, String username, List<int> responseIds,
    List<int> ratings) async {
  final http.Response response =
      await http.post('http://localhost:8080/api/debate/vote-response',
          headers: defaultHeaders,
          body: jsonEncode(<String, Object>{
            "voter": username,
            "groupId": groupId,
            "responseIds": responseIds,
            "ratings": ratings
          }));

  return (response.statusCode == 200);
}
