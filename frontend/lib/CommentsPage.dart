import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'formHelper.dart';
import 'theZone.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class Comment {
  final String profileName;
  final String username;
  final String content;
  final String id;

  Comment({this.profileName, this.username, this.content, this.id});

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
        id: json['id']);
  }
}

List<Comment> allComments = [];

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  Future<List<Comment>> _futureComments;
  int totalComments = 0;
  String newComment;
  String storeUsername;
  Future<bool> postSucess;
  Future<bool> deleteSucess;
  bool _postSucess;
  bool _deleteSucess = true;

  // Http post request to get post's comments
  Future<List<Comment>> getComments(String postId) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getComments',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'postId': postId}),
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
  Future<bool> postComment(
      String postId, String username, String content) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/addComment',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'postId': postId,
        'username': username,
        'content': content
      }),
    );

    if (response.statusCode == 200) {
      print("added comment!");
      return true;
    } else {
      return false;
    }
  }

  // Http post request to delete post's comments
  Future<bool> deleteComment(String username, String commentId) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/deleteComment',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'commentId': commentId}),
    );

    if (response.statusCode == 200) {
      print("delete comment!");
      _deleteSucess = true;
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
  Future<bool> editComment(
      String commentId, String username, String newData) async {
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
        'username': username,
        'newData': newData
      }),
    );

    if (response.statusCode == 200) {
      print("edited comment!");
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
              String storeToken = token.toString();
              this.storeUsername = username.toString();
              _futureComments = getComments(ForComment.postId);
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
              Text(allComments[i].username + " :   " + allComments[i].content),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Delete':
                  //             if (currentUser != creatorUsername) {
                  //   errorPopup(context, "You can only delete your post!!");
                  // }
                  if (this.storeUsername != allComments[i].username) {
                    errorPopup(context, "You can only delete your comment!!");
                  } else {
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
                                    print("DELETING POST");
                                    // Delete post
                                    deleteComment(
                                        this.storeUsername, allComments[i].id);
                                    setState(() {
                                      _futureComments =
                                          getComments(ForComment.postId);
                                    });

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
                  }
                  // _futureComments = getComments(ForComment.postId);
                  break;
                case 'Edit':
                  _editComment(allComments[i].username, allComments[i].id,
                      allComments[i].content);
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
          ),
        ),
        decoration: new BoxDecoration(
            border: new Border(bottom: new BorderSide(color: Colors.grey))));
  }

  void _editComment(String creatorUsername, String postId, String currComment) {
    if (this.storeUsername != creatorUsername) {
      errorPopup(context, "You can only edit your comment!");
    } else {
      print("id: " + postId);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // For storing the title and content in text boxes
            TextEditingController editCommentController =
                TextEditingController()..text = currComment;

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
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
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
                                    editComment(postId, this.storeUsername,
                                        editCommentController.value.text);
                                    setState(() {
                                      _futureComments =
                                          getComments(ForComment.postId);
                                    });

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
  }

  // void handleClick(String value) {
  //   switch (value) {
  //     case 'Edit':
  //       break;
  //     case 'Delete':
  //       deleteSucess = deleteComment(
  //           ForComment.post_username
  //           //change to this.storeUsername
  //           ,
  //           this.newComment);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/theZone")),
            title: Text("Comments", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {}),
            ],
            backgroundColor: Colors.black),
        bottomNavigationBar: NavBar(1),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView(
            children: List.generate(totalComments, (index) {
              return displayComments(index);
            }),
          )),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write comment ...",
              ),
              onChanged: (value) {
                setState(() {
                  this.newComment = value;
                });
              },
            ),
            trailing: OutlineButton(
                borderSide: BorderSide.none,
                child: Text("Post"),
                onPressed: () {
                  setState(() {
                    print("Pressed" + ForComment.postId);
                    postSucess = postComment(
                        ForComment.postId,
                        this.storeUsername
                        //change to this.storeUsername
                        ,
                        this.newComment);
                    commentController.clear();
                    _futureComments = getComments(ForComment.postId);
                  });
                }),
          )
        ]));
  }
}
