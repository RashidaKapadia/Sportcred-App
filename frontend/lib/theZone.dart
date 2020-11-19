import 'dart:async';
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TheZone(),
    ));

String old_content, old_title, store_username;

TextEditingController _contentController = TextEditingController()..text = '';
TextEditingController _titleController = TextEditingController()..text = '';

class TheZone extends StatefulWidget {
  @override
  _TheZoneState createState() => _TheZoneState();
}

class PostInfo {
  final String username;
  final String content;
  final String title;
  final bool reqStatus;

  PostInfo({this.username, this.content, this.title, @required this.reqStatus});

  // converts json to UserInfo object
  factory PostInfo.fromJson(bool status, Map<String, dynamic> json) {
    if (json == null) {
      return PostInfo(
        reqStatus: status,
      );
    }

    return PostInfo(
        reqStatus: status,
        username: json['username'],
        content: json['content'],
        title: json['title']);
  }
}

class PostNode {
  final String timestamp;
  final String uniqueIdentifier;
  final String username;
  final String content;
  final String title;
  final String peopleAgree;
  final String peopleDisagree;
  final bool reqStatus;
  final String comments; // TYPE TO BE CHANGED TO COMMENT NODE

  PostNode(
      {this.timestamp,
      this.uniqueIdentifier,
      this.username,
      this.content,
      this.title,
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
      peopleAgree: json['peopleAgree'],
      peopleDisagree: json['peopleDisagree'],
      comments: json['comments'],
    );
  }
}

void storePrevValues() {
  old_content = _contentController.text;
  old_title = _titleController.text;
}

List<PostNode> allZonePosts = [];

class _TheZoneState extends State<TheZone> {
  bool _status = true;
  List data;
  Future<PostNode> _futurePostNode;

  String username = "";

  String content = "";

  String title = "";

  Future<PostInfo> createPost(String content, String title) async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/addPost',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'username': store_username,
        'content': content,
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      PostInfo userData = PostInfo.fromJson(true, jsonDecode(response.body));
      setState(() {
        this.username = userData.username;
        this.content = userData.content;
        this.title = userData.title;

        _contentController..text = userData.content;
        _titleController..text = userData.title;
        print(userData.content);

        storePrevValues();
      });
      // Return posts data
    } else {
      return null;
    }
  }

  Future<List<PostNode>> getPosts() async {
    // Make the request and store the response
    final http.Response response = await http.post(
      'http://localhost:8080/api/getPosts',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      List<PostNode> allPosts = [];
      // Store the session token
      //print("Post GET -> RESPONSE:" + response.body.toString());
      //print(jsonDecode(response.body)['questions']);
      // Get the questions, options and correctAnswers and store them in the class variables
      for (Map<String, dynamic> postNode
          in jsonDecode(response.body)["posts"] as List) {
        print("*********************");
        print(PostNode.fromJson(true, postNode).uniqueIdentifier);
        print("*********************");

        allPosts += [PostNode.fromJson(true, postNode)];
        print(allPosts[0].content);
      }
      // DEBUGGING STATEMENTS
      print('DEBUGGING: Post Node Get');
      print("\n\nPostNodes: " + allPosts[0].timestamp);
      print(allPosts.length);
      setState(() {
        allZonePosts = allPosts;
        print("in api" + allZonePosts.toString());
      });
      // Return posts data
    } else {
      return null;
    }
  }

  Future<List<PostNode>> _futurePosts;

  @override
  void initState() {
    super.initState();
    FlutterSession().get('token').then((token) {
      FlutterSession().get('username').then((username) => {
            setState(() {
              String store_username = username.toString();
            })
          });
    });
    setState(() {
      print(store_username);
      _futurePosts = getPosts();
      print("FUTURE POSTS" + _futurePosts.toString());
      print("init" + allZonePosts.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pushNamed("/homepage")),
          title: Text("The Zone", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: 120,
            padding: EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200]),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Search",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                        children: List.generate(allZonePosts.length, (index) {
                      return makeFeed(index);
                    })),
                    // makeFeed(
                    //     userName: 'Aiony Haust',
                    //     userImage: 'profile_icon.png',
                    //     feedTime: '1 hr ago',
                    //     feedText:
                    //         'All the Lorem Ipsum generators on the Internet tend to repeat predefined.',
                    //     feedImage: 'assets/images/SportsCred_logo.png',
                    //     postRank: '3000',
                    //     comments: '322'),
                    // makeFeed(
                    //     userName: 'Azamat Zhanisov',
                    //     userImage: 'profile_icon.png',
                    //     feedTime: '3 mins ago',
                    //     feedText:
                    //         "All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.",
                    //     feedImage: 'assets/images/SportsCred_logo.png',
                    //     postRank: '309',
                    //     comments: '22'),
                    // makeFeed(
                    //     userName: 'Azamat Zhanisov',
                    //     userImage: 'profile_icon.png',
                    //     feedTime: '3 mins ago',
                    //     feedText:
                    //         "All the Lorem Ipsum generators on the Internet tend to repeat predefined.",
                    //     feedImage: 'assets/images/SportsCred_logo.png',
                    //     postRank: '3',
                    //     comments: '0'),
                    Center(
                        child: Text(
                      "All Caught Up!",
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            onPressed: () {
              // Respond to button press
            },
            tooltip: 'Create Post',
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }

  Widget makeFeed(int index) {
    int rank = allZonePosts[index].peopleAgree.length -
        allZonePosts[index].peopleDisagree.length;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                onSelected: handleClick,
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
            ListTile(
              leading: Icon(Icons.sentiment_satisfied_alt),
              title: Text(allZonePosts[index].title),
              subtitle: Text(
                'Posted by ' +
                    allZonePosts[index].username +
                    ': ' +
                    allZonePosts[index].timestamp,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                allZonePosts[index].content,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                // FlatButton(
                //   textColor: const Color(0xFF6200EE),
                //   onPressed: () {
                //     // Perform some action
                //   },
                //   child: const Text('AGREE'),
                // ),
                // FlatButton(
                //   textColor: const Color(0xFF6200EE),
                //   onPressed: () {
                //     // Perform some action
                //   },
                //   child: const Text('DISAGREE'),
                // ),
                IconButton(
                    alignment: Alignment.bottomLeft,
                    icon: new Icon(Icons.arrow_upward_sharp),
                    onPressed: () {
                      //editPost();
                    }),
                Text(rank.toString()),
                IconButton(
                    icon: new Icon(Icons.arrow_downward_sharp),
                    onPressed: () {
                      //editPost();
                    }),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {},
                ),
                Text(allZonePosts[index].comments.toString()),

                // TODO: Edit this to only be visible to user of that profile
                // IconButton(
                //     icon: new Icon(Icons.edit),
                //     onPressed: () {
                //       //editPost();
                //     }),
                // IconButton(
                //     icon: new Icon(Icons.delete),
                //     onPressed: () {
                //       //editPost();
                //     })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        break;
      case 'Delete':
        break;
    }
  }

  Widget makeAgree() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeDisagree() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_down, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeAgreeButton({isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Agree",
              style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeDisagreeButton({isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_down,
              color: isActive ? Colors.red : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Disagree",
              style: TextStyle(color: isActive ? Colors.red : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeCommentButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chat, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Comment",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  Widget makeShareButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Share",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
