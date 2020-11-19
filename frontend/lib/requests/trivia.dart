import 'dart:convert';
import 'package:http/http.dart' as http;

var defaultHeaders = {
  'Content-Type': 'text/plain; charset=utf-8',
  'Accept': 'text/plain; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
};

class TriviaQuestion {
  final String question;
  final List<dynamic> options;
  final String answer;

  TriviaQuestion({this.question, this.options, this.answer});

  // converts json to TriviaQuestions object
  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
        question: json['question'],
        options: json['choices'],
        answer: json['answer']);
  }
}

// Http post request to get user info
Future<List<TriviaQuestion>> getQuestions(String category) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    'http://localhost:8080/api/trivia/get-questions',
    headers: defaultHeaders,
    body: jsonEncode(<String, String>{'category': category}),
  );

  if (response.statusCode == 200) {
    List<TriviaQuestion> triviaQs = [];
    // Get the questions, options and correctAnswers and store them in the class variables
    for (Map<String, dynamic> question
        in jsonDecode(response.body)["questions"] as List) {
      triviaQs += [TriviaQuestion.fromJson(question)];
    }
    return triviaQs;
  } else {
    return null;
  }
}

// Http post request to update ACS
Future updateACS(String token, String username, int score) async {
  // Make the request and store the response
  final http.Response response =
      await http.post('http://localhost:8080/api/editACS"',
          headers: defaultHeaders,
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

Future startMultiplayerTrivia(String username, String opponent) async {
  final http.Response response =
      await http.post('http://localhost:8080/api/trivia/start-multiplayer-game',
          headers: defaultHeaders,
          body: jsonEncode(<String, String>{
            "username": username,
            "opponent": opponent,
          }));

  List<TriviaQuestion> triviaQs = [];
  int gameId = -1;
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    gameId = json["gameID"];
    for (Map<String, dynamic> question in json["questions"] as List) {
      triviaQs.add(TriviaQuestion.fromJson(question));
    }
  }
  return [triviaQs, gameId];
}

Future joinMultiplayerTrivia(int gameId) async {
  final http.Response response =
      await http.post('http://localhost:8080/api/trivia/join-multiplayer-game',
          headers: defaultHeaders,
          body: jsonEncode(<String, dynamic>{
            "gameID": gameId,
          }));

  List<TriviaQuestion> triviaQs = [];
  String opponent = "<unknown>";

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    opponent = json["inviter"];
    for (Map<String, dynamic> question in json["questions"] as List) {
      triviaQs.add(TriviaQuestion.fromJson(question));
    }
  }
  return [triviaQs, opponent];
}

Future endMultiplayerTrivia(
    String username, int gameId, List<String> answers, int gameScore) async {
  final http.Response response =
      await http.post('http://localhost:8080/api/trivia/end-multiplayer-game',
          headers: defaultHeaders,
          body: jsonEncode(<String, dynamic>{
            "gameID": gameId,
            "username": username,
            "answers": answers,
            "gameScore": gameScore
          }));
  return (response.statusCode == 200);
}
