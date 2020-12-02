import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

var defaultHeaders = {
  'Content-Type': 'text/plain; charset=utf-8',
  'Accept': 'text/plain; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
};

class QuestionNode {
  final int questionId;
  final String question;
  final String tier;
  final bool reqStatus;

  QuestionNode(
      {this.questionId, this.question, this.tier, @required this.reqStatus});

  // converts json to UserInfo object
  factory QuestionNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return QuestionNode(
        reqStatus: status,
      );
    }

    return QuestionNode(
        reqStatus: status,
        questionId: json['questionId'],
        tier: json['tier'],
        question: json['question']);
  }
}

List<QuestionNode> makeQuestionsList(List<dynamic> list) {
  List<QuestionNode> qs = [];
  for (Map<String, dynamic> question in list) {
    qs.add(QuestionNode.fromJson(true, question));
  }
  return qs;
}

Future<List<QuestionNode>> getQuestions() async {
  // Make the request and store the response
  final http.Response response = await http.post(
    'http://localhost:8080/api/debate/get-ongoing-questions',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    print(response.statusCode);
    //List<QuestionNode> allQuestions = [];
    // Get the questions, options and correctAnswers and store them in the class variables
    //for (Map<String, dynamic> questionNode
    //  in jsonDecode(response.body)["questions"] as List) {
    return makeQuestionsList(jsonDecode(response.body)["questions"]);
    /*print("*********************");
      print(QuestionNode.fromJson(true, questionNode).tier);
      print("*********************");

      allQuestions += [QuestionNode.fromJson(true, questionNode)];
      print(allQuestions[0].tier);
    }
    // DEBUGGING STATEMENTS
    print('DEBUGGING: Post Node Get');
    print("\n\nQuestionodes: " + allQuestions[0].question);
    print(allQuestions.length);
    return allQuestions;
    //questionsList = allQuestions;
    //print("in api" + questionsList.toString());
    //return questionsList;
    // Return posts data*/
  } else {
    print(response.statusCode);
    return null;
  }
}

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
