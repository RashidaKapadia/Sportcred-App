import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Http post request to create an album
Future<Album> createAlbum(String title) async {
  // Make the request and store the response
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  // If successful the response will contain album information in json,
  // parse the json body data and convert into our Album object
  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  // converts json to Album object
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

class HTTPRequestExample extends StatefulWidget {
  HTTPRequestExample({Key key}) : super(key: key);

  @override
  _HTTPRequestExampleState createState() {
    return _HTTPRequestExampleState();
  }
}

class _HTTPRequestExampleState extends State<HTTPRequestExample> {
  // Default textbox event functionality
  final TextEditingController _controller = TextEditingController();

  // Variable that will contain an Album in the future
  Future<Album> _futureAlbum;

  Widget displayQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          child: Text('Create Data'),
          onPressed: () {
            setState(() {
              // Call the HTTP request to make an album
              _futureAlbum = createAlbum(_controller.text);
            });
          },
        ),
      ],
    );
  }

  Widget showAsyncStatus() {
    return FutureBuilder<Album>(
      future: _futureAlbum, // WHY?
      builder: (context, snapshot) {
        // context ????
        // Snapshot is data returned from processed HTTP requset ?????
        if (snapshot.hasData) {
          return Text(snapshot.data.title);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child:
                (_futureAlbum == null) ? displayQuestion() : showAsyncStatus()),
      ),
    );
  }
}
