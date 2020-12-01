import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var defaultHeaders = {
  'Content-Type': 'text/plain; charset=utf-8',
  'Accept': 'text/plain; charset=utf-8',
  'Access-Control-Allow-Origin': '*',
};

class GroupNode {
  final String groupId;
  List<Group_ResponsesNode> responses;
  final bool reqStatus;

  GroupNode({this.groupId, this.responses, @required this.reqStatus});

  // converts json to post node object
  factory GroupNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return GroupNode(
        reqStatus: status,
      );
    }

    return GroupNode(
      reqStatus: status,
      //responses: json['responses'],
      groupId: json['groupId'],
    );
  }
}

class Group_ResponsesNode {
  final String response;
  final int responseId;
  final bool reqStatus;

  Group_ResponsesNode(
      {this.response, this.responseId, @required this.reqStatus});

  // converts json to post node object
  factory Group_ResponsesNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return Group_ResponsesNode(reqStatus: status);
    }

    return Group_ResponsesNode(
      reqStatus: status,
      response: json['response'],
      responseId: json['groupId'],
    );
  }
}

Future<List<GroupNode>> getGroupResponses(String username) async {
  final http.Response response = await http.post(
      'http://localhost:8080/api/debate/get-group-responses-my-question',
      headers: defaultHeaders,
      body: jsonEncode(<String, Object>{
        "username": username,
      }));
  print("made the postman call");
  if (response.statusCode == 200) {
    // Store the session token
    //print("Post GET -> RESPONSE:" + response.body.toString());
    //print(jsonDecode(response.body)['questions']);
    print("response status code = 200");
    List<GroupNode> allGroups = [];
    // Get the questions, options and correctAnswers and store them in the class variables
    for (Map<String, dynamic> groupNode
        in jsonDecode(response.body)["groups"] as List) {
      print("*********************");
      print(GroupNode.fromJson(true, groupNode).groupId);
      print("*********************");
      List<Group_ResponsesNode> allGroupResponses = [];
      for (Map<String, dynamic> group_responsesNode
          in jsonDecode(response.body)["responses"] as List) {
        allGroupResponses += [
          Group_ResponsesNode.fromJson(true, group_responsesNode)
        ];
      }
      allGroups += [GroupNode.fromJson(true, groupNode)];
      allGroups.last.responses = allGroupResponses;
    }
    // DEBUGGING STATEMENTS
    print('DEBUGGING: Group Node Get');
    //print("\n\nGroupNodes: " + allGroups[0].responses[0]);

    // Return posts data
    return allGroups;
  } else {
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
