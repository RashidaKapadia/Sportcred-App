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

class GroupNode {
  final String groupId;
  List<dynamic> responses;

  final bool reqStatus;

  GroupNode({this.groupId, this.responses, this.reqStatus});

  // converts json to UserInfo object
  factory GroupNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return GroupNode(
        reqStatus: status,
      );
    }

    return GroupNode(
        reqStatus: status,
        groupId: json['groupId'],
        responses: json['responses']);
  }
}

class ResponseNode {
  final int responseId;
  final String response;
  final bool reqStatus;

  ResponseNode({this.responseId, this.response, this.reqStatus});

  // converts json to UserInfo object
  factory ResponseNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return ResponseNode(
        reqStatus: status,
      );
    }

    return ResponseNode(
        reqStatus: status,
        responseId: json['responseId'],
        response: json['response']);
  }
}

List<GroupNode> makeGroupResponseList(List<dynamic> list) {
  List<GroupNode> gr = [];
  for (Map<String, dynamic> group in list) {
    gr.add(GroupNode.fromJson(true, group));
  }
  return gr;
}

List<ResponseNode> makeRepsonseList(List<dynamic> list) {
  List<ResponseNode> qs = [];
  for (Map<String, dynamic> response in list) {
    qs.add(ResponseNode.fromJson(true, response));
  }
  return qs;
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
    return makeQuestionsList(jsonDecode(response.body)["questions"]);
  } else {
    print(response.statusCode);
    return null;
  }
}

Future<List<GroupNode>> getGroupResponses(int questionId) async {
  // Make the request and store the response
  final http.Response response = await http.post(
      'http://localhost:8080/api/debate/get-group-responses',
      headers: defaultHeaders,
      body: jsonEncode(<String, Object>{"questionId": questionId}));

  if (response.statusCode == 200) {
    print(response.statusCode);
    List<GroupNode> r =
        makeGroupResponseList(jsonDecode(response.body)["groups"]);

    for (int i = 0; i < r.length; i++) {
      List<ResponseNode> res = makeRepsonseList(r[i].responses);
      print("before" + r[i].responses.toString());
      print(res[0].response);

      r[i].responses = res;
      print("after" + r[i].responses.toString());
      print(r[i].responses[0].response);
    }
    print(r[0].responses);
    return r;
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
