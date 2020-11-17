import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/user.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';

class TriviaSearchOpponentPage extends StatefulWidget {
  @override
  _TriviaSearchOpponentPageState createState() =>
      _TriviaSearchOpponentPageState();
}

class _TriviaSearchOpponentPageState extends State<TriviaSearchOpponentPage> {
  Future<List<UserInfo>> _futureUsers;
  TextEditingController editingController = TextEditingController();
  List<UserInfo> filteredUsers = List<UserInfo>();
  String selected;

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
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredUsers.length,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${filteredUsers[index].firstname} ${filteredUsers[index].lastname}'),
          );
        },
      ),
    );
  }

  Widget body(BuildContext context, List<UserInfo> users) {
    return Container(
      width: double.infinity,
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            vmargin30(h1("Choose your Opponent!", color: Colors.deepOrange)),
            h1("You"),
            h3("vs", color: Colors.grey),
            searchBar(users),
            listUsers(),
          ]),
    );
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
