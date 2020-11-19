import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/user.dart';
import 'package:frontend/trivia/triviaOngoing.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';

class TriviaSearchOpponentPage extends StatefulWidget {
  String category;
  TriviaSearchOpponentPage(this.category);

  @override
  _TriviaSearchOpponentPageState createState() =>
      _TriviaSearchOpponentPageState(category);
}

class _TriviaSearchOpponentPageState extends State<TriviaSearchOpponentPage> {
  String category;
  _TriviaSearchOpponentPageState(this.category);

  Future<List<UserInfo>> _futureUsers;
  TextEditingController editingController = TextEditingController();
  List<UserInfo> filteredUsers = List<UserInfo>();
  String selectedUsername;

  var isSelected = false;
  String username = "";

  @override
  void initState() {
    loadUsername();
    _futureUsers = getUsers();
    super.initState();
  }

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
      });
    });
  }

  void filterSearchResults(String query, List<UserInfo> users) {
    List<UserInfo> dummySearchList = List<UserInfo>();
    dummySearchList.addAll(users);
    if (query.isNotEmpty) {
      List<UserInfo> dummyListData = List<UserInfo>();
      dummySearchList.forEach((item) {
        if (item.firstname.toLowerCase().contains(query.toLowerCase()) ||
            item.lastname.toLowerCase().contains(query.toLowerCase()) ||
            item.username.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredUsers.clear();
        filteredUsers.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredUsers.clear();
        filteredUsers.addAll(users);
      });
    }
  }

  Widget searchBar(List<UserInfo> users) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value, users);
        },
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget listUsers() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredUsers.length,
            padding: EdgeInsets.all(0),
            // physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${filteredUsers[index].firstname} ${filteredUsers[index].lastname}',
                                style: TextStyle(
                                  color: (filteredUsers[index].username ==
                                          username)
                                      ? Colors.grey
                                      : Colors.black,
                                )),
                            Text('${filteredUsers[index].username}',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ))
                          ]),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3.0)),
                      onPressed: () {
                        setState(() {
                          if (filteredUsers[index].username != username) {
                            selectedUsername = filteredUsers[index].username;
                          }
                        });
                      }));
            }));
  }

  goToTrivia() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TriviaOngoing(
            username: username,
            category: category,
            opponent: selectedUsername,
            triviaMode: TriviaMode.MULTI_INVITER)));
  }

  Widget body(BuildContext context, List<UserInfo> users) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(children: [
        vmargin20(h1("Choose your Opponent!",
            color: Colors.deepOrange, textAlign: TextAlign.center)),
        h1("You: " + username),
        h3("vs", color: Colors.grey),
        // Because if nesting issues, we have this inefficiency
        (selectedUsername == null) ? searchBar(users) : h2(selectedUsername),
        (selectedUsername == null)
            ? listUsers()
            : margin10(plainButton(
                text: "Change Opponent",
                onPressed: () {
                  setState(() {
                    selectedUsername = null;
                  });
                })),
        (selectedUsername != null)
            ? vmargin30(
                orangeButtonLarge(text: "Play!", onPressed: () => goToTrivia()))
            : Text("..."),
      ]),
    ));
  }

  Widget loadUsers(BuildContext context) {
    return FutureBuilder<List<UserInfo>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return body(context, snapshot.data);
        } else {
          return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pushNamed("/trivia/mode")),
          title: Text("1-1 Trivia", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.deepOrange),
      body: loadUsers(context),
    );
  }
}
