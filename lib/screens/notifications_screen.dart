import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validator/models/notification.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/notification_handler.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int notificationsCount = 0;
  List<OVDNotification> notifications;

  void getNotifications() async {
    List<OVDNotification> list = await OVDNotificationHandler.getNotifications();
    setState(() {
      notifications = list;
      notificationsCount = notifications.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notificationsCount == 0
          ? Container(
              padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
              child: Center(
                child: Text(
                  'No notificaitons',
                  textAlign: TextAlign.center,
                  style: kTextStyleError,
                ),
              ),
            )
          : Container(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: notificationsCount,
                    itemBuilder: (BuildContext context, int index) {
                      String message = notifications[index].message;
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction) {
                          OVDNotificationHandler.deleteNotification(notifications[index].id);
                          setState(() {
                            notifications.removeAt(index);
                            notificationsCount = notifications.length;
                          });
                        },
                        secondaryBackground: Container(
                          child: Center(
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          color: Colors.red,
                        ),
                        background: Container(),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                          child: ListTile(
                            trailing: Icon(
                              FontAwesomeIcons.bell,
                              color: Colors.orange,
                              size: 20.0,
                            ),
                            title: Text(
                              notifications[index].message == null ? '' : notifications[index].message,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${notifications[index].timeStamp}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {},
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kMainColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
