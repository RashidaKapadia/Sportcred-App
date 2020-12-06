//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'formHelper.dart';
import 'theZone.dart';
import 'package:frontend/widgets/layout.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class Comment {
  final String profileName;
  final String username;
  final String acs;
  final String content;
  final String id;

  Comment({this.profileName, this.acs, this.username, this.content, this.id});

  // converts json to ACS object
  factory Comment.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print("json was null");
      return null;
    }
    return Comment(
        profileName: json['profileName'],
        username: json['username'],
        content: json['content'],
        acs: json['acs'].toString(),
        id: json['id']);
  }
}

List<Comment> allComments = [];

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  Future<List<Comment>> _futureComments;
  int totalComments = 0;
  String newComment;
  String currentUser;
  Future<bool> postSucess;
  Future<bool> deleteSucess;
  bool _deleteSucess = true;

  // Http post request to get post's comments
  Future<List<Comment>> getComments() async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getComments',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'postId': ForComment.postId}),
    );

    if (response.statusCode == 200) {
      List<Comment> comments = [];

      for (Map<String, dynamic> comment in jsonDecode(response.body) as List) {
        comments += [Comment.fromJson(comment)];
      }
      totalComments = comments.length;
      print(totalComments);
      print(comments);
      setState(() {
        allComments = comments;
        print("in api" + allComments.toString());
      });
      return comments;
    } else {
      return null;
    }
  }

  // Http post request to get post's comments
  Future<bool> postComment(String content) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/addComment',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'postId': ForComment.postId,
        'username': currentUser,
        'content': content
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        getComments();
      });
      print("added comment!");
      return true;
    } else {
      return false;
    }
  }

  // Http post request to delete post's comments
  Future<bool> deleteComment(String commentId) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/deleteComment',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(
          <String, String>{'username': currentUser, 'commentId': commentId}),
    );

    if (response.statusCode == 200) {
      print("delete comment!");
      _deleteSucess = true;

      setState(() {
        getComments();
      });

      return true;
    } else if (response.statusCode == 409) {
      _deleteSucess = false;
      print("users dont match!");
      print(_deleteSucess);
      return false;
    } else {
      return false;
    }
  }

  // Http post request to edit post's comments
  Future<bool> editComment(String commentId, String newData) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/editComment',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'commentId': commentId,
        'username': currentUser,
        'newData': newData
      }),
    );

    if (response.statusCode == 200) {
      print("edited comment!");
      setState(() {
        getComments();
      });

      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              this.currentUser = username.toString();
              _futureComments = getComments();
              print("init" + allComments.toString());
            })
          });
    });

    if (_futureComments != null) {
      print("its null");
      print(_futureComments);
    }
    print("outside" + allComments.toString());
  }

  Container displayComments(int i) {
    return Container(
        child: ListTile(
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                allComments[i].username +
                    " (ACS: " +
                    allComments[i].acs +
                    "): ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6))),
            Text(allComments[i].content)
          ]),
          trailing: (this.currentUser == allComments[i].username)
              ? PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'Delete':
                        showDialog(
                            context: context,
                            builder: (alertContext) {
                              return AlertDialog(
                                title: Text("Confirmation"),
                                content: Text(
                                    "Are you sure you want to delete this comment?"),
                                actions: [
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      setState(() {
                                        // Delete post
                                        deleteComment(allComments[i].id);

                                        print("COMMENT DELETED");

                                        Navigator.of(alertContext,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(alertContext,
                                              rootNavigator: true)
                                          .pop('dialog');
                                    },
                                  )
                                ],
                              );
                            });
                        break;
                      case 'Edit':
                        _editComment(allComments[i].id, allComments[i].content);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Edit', 'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              : Text(" "),
        ),
        decoration: new BoxDecoration(
            border: new Border(bottom: new BorderSide(color: Colors.grey))));
  }

  void _editComment(String commentId, String currComment) {
    print("id: " + commentId);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // For storing the title and content in text boxes
          TextEditingController editCommentController = TextEditingController()
            ..text = currComment;

          return SizedBox(
              height: 10,
              width: 100,
              child: Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Edit Comment",
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          title: TextField(
                            cursorColor: Colors.orange,
                            controller: editCommentController,
                            decoration: InputDecoration(
                                labelText: "Comment",
                                hintText: "Comment",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                child: Text("Cancel"),
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop()),
                            RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                // Check that comment content is not empty
                                if (editCommentController.value.text
                                    .trim()
                                    .isNotEmpty) {
                                  print(editCommentController.value.text);
                                  editComment(commentId,
                                      editCommentController.value.text);

                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  print("FINISHED EDITING COMMENT!");
                                } else {
                                  errorPopup(
                                      context, "Comment cannot be empty!");
                                }
                              },
                            )
                          ]),
                    )
                  ],
                )),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        appBar: AppBar(
            leading: BackButton(
                color: green,
                onPressed: () => Navigator.of(context).pushNamed("/theZone")),
            title: Text("Comments", style: TextStyle(color: green)),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {}),
            ],
            backgroundColor: grey),
        // bottomNavigationBar: NavBar(1, route: "/comments"),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView(
            children: List.generate(totalComments, (index) {
              return displayComments(index);
            }),
          )),
          Divider(),
          ListTile(
            title: new Theme(
                data: ThemeData(primaryColor: green),
                child: TextFormField(
                  controller: commentController,
                  cursorColor: green,
                  decoration: InputDecoration(
                    labelText: "Write comment ...",
                    labelStyle: TextStyle(color: green),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.newComment = value;
                    });
                  },
                )),
            trailing: FlatButton(
                //borderSide: BorderSide(color: green, width: 3),
                color: grey,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: green, width: 2, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10)),
                child: Text("Post", style: TextStyle(color: green)),
                onPressed: () {
                  setState(() {
                    print("Pressed" + ForComment.postId);
                    if (this.newComment != null) {
                      postSucess = postComment(this.newComment);
                      commentController.clear();
                    }
                  });
                }),
          )
        ]));
  }
}
