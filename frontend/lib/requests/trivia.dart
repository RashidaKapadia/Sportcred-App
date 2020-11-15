import 'dart:convert';
import 'package:http/http.dart' as http;

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
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
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
