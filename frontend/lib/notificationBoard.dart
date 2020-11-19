import 'package:flutter/material.dart';
import 'package:frontend/requests/notifications.dart';
import 'package:frontend/trivia/triviaOngoing.dart';
import 'package:frontend/trivia/triviaResultMultiplayer.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import 'navbar.dart';

class NotificationBoard extends StatefulWidget {
  @override
  _NotificationBoardState createState() => _NotificationBoardState();
}

class _NotificationBoardState extends State<NotificationBoard> {
  var isSelected = false;
  String username = "";
  Future<List<UserNotification>> _futureNotifications;

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
        _futureNotifications = getNotifications(username);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  gotoTrivia(BuildContext context, int actionId) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TriviaOngoing(
            username: username,
            gameId: actionId,
            triviaMode: TriviaMode.MULTI_ACCEPTER)));
  }

  gotoTriviaResults(BuildContext context, int actionId) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            TriviaResultMulti(username: username, gameId: actionId)));
  }

  // Action factory
  Widget getActions(BuildContext context, int id, int actionId, String type,
      String category) {
    if (type == "invite" && category == "trivia") {
      return greyButtonFullWidth(
        () {
          deleteNotifications(username, [id]);
          gotoTrivia(context, actionId);
        },
        Text("Accept Invitation"),
      );
    } else if (type == "results" && category == "trivia") {
      return greyButtonFullWidth(
        () {
          markReadNotifications(username, [id]);
          gotoTriviaResults(context, actionId);
        },
        Text("See Results"),
      );
    } else {
      return Text("");
    }
  }

  // Tag factory
  Widget getTag(String value) {
    if (value == "trivia") {
      return tag(value, 240, 210, 160); // orange
    } else if (value == "invite") {
      return tag(value, 190, 200, 250); // blue
    } else if (value == "results") {
      return tag(value, 190, 245, 160); // green
    } else {
      return tag(value, 220, 220, 220); // grey
    }
  }

  Widget notificationHeader(int id, String type, String category) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      vmargin5(Row(children: [
        getTag(type),
        hmargin5(getTag(category)),
      ])),
      GestureDetector(
          child: Icon(Icons.delete, color: Colors.red[300], size: 20),
          onTap: () {
            deleteNotifications(username, [id]);
          })
    ]);
  }

  Widget notification({
    BuildContext context,
    String type,
    String category,
    String title,
    int id,
    int actionId,
  }) {
    //
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200], width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        notificationHeader(id, type, category),
        hmargin5(bold(title)),
        Text("N-id: " + id.toString() + " gameId: " + actionId.toString()),
        vmargin5(getActions(context, id, actionId, type, category))
      ]),
    );
  }

  Widget notificationsList(
      BuildContext context, List<UserNotification> notifications) {
    return Container(
      child: (notifications.length == 0)
          ? Center(child: margin20(Text("No new notifications")))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              padding: EdgeInsets.all(0),
              // physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: (notifications[index].read)
                      ? Colors.grey[200]
                      : Colors.white,
                  contentPadding: EdgeInsets.all(0),
                  title: notification(
                      context: context,
                      id: notifications[index].notificationId,
                      type: notifications[index].type,
                      category: notifications[index].category,
                      actionId: notifications[index].infoId,
                      title: notifications[index].message),
                );
              }),
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder<List<UserNotification>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return notificationsList(context, snapshot.data);
          } else {
            return margin10(CircularProgressIndicator());
          }
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.brown[300]),
        bottomNavigationBar: NavBar(1),
        body: body(context));
  }
}
