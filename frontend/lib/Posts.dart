import 'package:flutter/material.dart';

class PostNode {
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
      {this.uniqueIdentifier,
      this.username,
      this.content,
      this.title,
      this.profileName,
      this.peopleAgree,
      this.peopleDisagree,
      this.comments,
      @required this.reqStatus});

  // converts json to UserInfo object
  factory PostNode.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return PostNode(
        reqStatus: status,
      );
    }

    return PostNode(
      reqStatus: status,
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
