import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/user.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "$i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value);
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index]}'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          searchBar(),
          listUsers(),
        ],
      ),
    );
  }
}

// ----------

class TriviaSearchOpponentPage extends StatefulWidget {
  @override
  _TriviaSearchOpponentPageState createState() =>
      _TriviaSearchOpponentPageState();
}

class _TriviaSearchOpponentPageState extends State<TriviaSearchOpponentPage> {
  Future<List<UserInfo>> _futureUsers;

  var isSelected = false;
  String username = "";

  @override
  void initState() {
    super.initState();
    loadUsername();
    _futureUsers = getUsers();
  }

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
      });
    });
  }

  Widget searchList(List<UserInfo> users) {
    for (UserInfo user in users) {
      print(user.firstname);
    }
    return Text("hi");
  }

  Widget loadUsers() {
    return FutureBuilder<List<UserInfo>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return searchList(snapshot.data);
        } else {
          return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            vmargin30(h1("Choose your Opponent!")),
            h1("You"),
            h3("vs", color: Colors.grey),
            loadUsers(),
          ]),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/trivia/mode")),
            title: Text("1-1 Trivia", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.deepOrange),
        body: MyHomePage()
        // body(context),
        );
  }
}
