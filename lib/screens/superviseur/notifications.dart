import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../consturl.dart';
import '../../models/notification.dart';

class Notifications extends StatefulWidget {
  final int id;
  final String accessToken;

  Notifications({Key? key,required this.id, required this.accessToken}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationModel> notificationsList = [];

  Future<List<NotificationModel>> fetchNotifications(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      // "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'notifications/'+id),headers: headers);
    var data = utf8.decode(response.bodyBytes);
    var notifications = <NotificationModel>[];
    for (var u in jsonDecode(data)) {
      var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date']);
      notifications.add(NotificationModel(u['id'], u['content'], date, u['is_read'],u['image']));
    }
    return notifications;
  }
  Future update(id) async {
    await http.put(Uri.parse(baseUrl+'notifications/' + id));
  }

  void _showNotificationContent(String content,int id) async{
    print(id);
    await update(id.toString());
    showDialog(
      context: context,
      builder: (BuildContext context)  {
        return CustomPopupDialog(content: content);
      },
    );
    await fetchNotifications(widget.id.toString()).then((notifications) {
      setState(() {
        notificationsList = notifications;
      });
    });
    //await fetchNotifications();
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications(widget.id.toString()).then((notifications) {
      setState(() {
        notificationsList = notifications;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double textSize = 14;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
          //  _top(),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                  color: Colors.white,
                ),
                child: FutureBuilder<List<NotificationModel>>(
                  future: fetchNotifications(widget.id.toString()),
                  builder: (BuildContext context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      var notifications = snapshot.data!;
                      return ListView.builder(
                        itemCount: notifications.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var notification = notifications[index];
                         // Widget avatarWidget;
                          Widget avatarWidget = CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                          );

                          if (notification.image.startsWith("images/")) {
                            avatarWidget = CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(notification.image),
                              backgroundColor: Colors.transparent,
                            );
                          } else if (notification.image.startsWith("/data/")) {
                            File imageFile = File(notification.image); // Créer un objet File
                            if (imageFile.existsSync()) {
                              // Charger et afficher l'image
                              avatarWidget = CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(imageFile),
                                backgroundColor: Colors.transparent,
                              );
                            } else {
                              print("Le fichier image n'existe pas à l'emplacement spécifié.");
                            }
                          } else {
                            avatarWidget = CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage("default_image.png"),
                              backgroundColor: Colors.transparent,
                            );
                          }

                          return GestureDetector(
                            onTap: () => _showNotificationContent(notification.content, notification.id),
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              elevation: 0,
                              child: Row(
                                children: [
                                  avatarWidget,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('HH:mm').format(notification.date),
                                              style: TextStyle(
                                                  color: Colors.grey, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          notification.content,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupDialog extends StatelessWidget {
  final String content;

  CustomPopupDialog({required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

Widget _top() {
  return Container(
    padding: EdgeInsets.only(top: 30, left: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications\n',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
