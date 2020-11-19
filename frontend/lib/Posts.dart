import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostStatus {
  final bool success;
  final String message;
  PostStatus(this.success, this.message);
}

class PostsPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class PostNode {
  final String timestamp;
  final String uniqueIdentifier;
  final String username;
  final String content;
  final String title;
  final String profileName;
  final Set peopleAgree;
  final Set peopleDisagree;
  final bool reqStatus;
  final List comments; // TYPE TO BE CHANGED TO COMMENT NODE

  PostNode(
      {this.timestamp,
      this.uniqueIdentifier,
      this.username,
      this.content,
      this.title,
      this.profileName,
      this.peopleAgree,
      this.peopleDisagree,
      this.comments,
      @required this.reqStatus});

  // converts json to post node object
  factory PostNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return PostNode(
        reqStatus: status,
      );
    }

    return PostNode(
      reqStatus: status,
      timestamp: json["timestamp"],
      uniqueIdentifier: json['uniqueIdentifier'],
      username: json['username'],
      content: json['content'],
      title: json['title'],
      profileName: json['profileName'],
      peopleAgree: json['peopleAgree'],
      comments: json['comments'],
    );
  }
}

class _PostPageState extends State<PostsPage> {
  bool _status = true;
  Future<PostNode> _futurePostNode;

  Future<List<PostNode>> getPosts(
    String timestamp,
    String uniqueIdentifier,
    String username,
    String content,
    String title,
    String profileName,
    Set peopleAgree,
    Set peopleDisagree,
    List comments,
  ) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/trivia/get-questions',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      // Store the session token
      //print("Post GET -> RESPONSE:" + response.body.toString());
      //print(jsonDecode(response.body)['questions']);
      List<PostNode> allPosts = [];
      // Get the questions, options and correctAnswers and store them in the class variables
      for (Map<String, dynamic> postNode
          in jsonDecode(response.body)["posts"] as List) {
        print("*********************");
        print(PostNode.fromJson(true, postNode).uniqueIdentifier);
        print("*********************");

        allPosts += [PostNode.fromJson(true, postNode)];
      }
      //setState(() {
      //this.triviaData = triviaQs;
      //});

      // DEBUGGING STATEMENTS
      print('DEBUGGING: Post Node Get');
      print("\n\nPostNodes: " + allPosts[0].timestamp);

      // Return trivia data
      return allPosts;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
