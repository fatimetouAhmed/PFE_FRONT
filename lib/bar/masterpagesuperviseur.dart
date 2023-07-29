import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfe_front_flutter/screens/forms/surveillanceform.dart';
import '../models/surveillance.dart';
import '../screens/lists/listsurveillant.dart';
import '../screens/lists/notifications.dart';
import '../screens/login_screen.dart';
import 'appbarsuperviseur.dart';
import 'package:http/http.dart' as http;

class MasterPageSupeurviseur extends StatefulWidget {
  final Widget child;
  final String accessToken;
  final int index;
  MasterPageSupeurviseur({
    Key? key,
    required this.child,
    required this.accessToken,
    required this.index,
  }) : super(key: key);

  @override
  _MasterPageSupeurviseurState createState() => _MasterPageSupeurviseurState();
}

class _MasterPageSupeurviseurState extends State<MasterPageSupeurviseur> {
  Widget _currentWidget = Notifications(accessToken: ''); // Set a default value
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentWidget = this.widget.child;
    _currentIndex = this.widget.index;
  }

  Future<int> fetchCountNotifications() async {
    try {
      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer ${widget.accessToken}",
      };
      var response = await http.get(
        Uri.parse('http://127.0.0.1:8000/notifications/nb_notifications_no_read/'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        int count = jsonData as int;
        return count;
      } else {
        // Handle error scenarios, such as when the API call fails
        print('API Error: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Exception during API call: $e');
      return 0;
    }
  }

  void handleDestinationTap(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      switch (selectedIndex) {
        case 0:
          _currentWidget = Notifications(accessToken: widget.accessToken);
          break;
        case 1:
          _currentWidget = ListSurveillance(accessToken: widget.accessToken);
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(accessToken: widget.accessToken),
            ),
          );
          break;
      // case 3:
      //   _currentWidget = SurveillanceForm(surveillance: Surveillance(0,  DateTime.parse('0000-00-00 00:00:00'), DateTime.parse('0000-00-00 00:00:00'),0,0), accessToken: widget.accessToken,);
      //   break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _currentWidget,
      bottomNavigationBar: FutureBuilder<int>(
        future: fetchCountNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CurvedNavigationBar(
              index: _currentIndex,
              height: 60.0,
              items: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.notification_important),
                    ),
                    Positioned(
                      top: -1,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          "0", // Use the default value or 0 during waiting state
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.person_2, size: 30),
                Icon(Icons.logout, size: 30),
              ],
              onTap: (value){
                handleDestinationTap;
                setState(() {
                  _currentIndex=value;
                  _currentWidget=widget.child;

                });
              },
              // Rest of the CurvedNavigationBar properties...
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              int notificationCount = snapshot.data ?? 0;
              return CurvedNavigationBar(
                index: _currentIndex,
                height: 60.0,
                items: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.notification_important),
                      ),
                      Positioned(
                        top: -1,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 10,
                            minHeight: 10,
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.person_2, size: 30),
                  Icon(Icons.logout, size: 30),
                ],
                onTap: handleDestinationTap,
                // Rest of the CurvedNavigationBar properties...
              );
            } else {
              return Text('Error: Unable to fetch notification count');
            }
          }
          // Handle other connection states if necessary
          return SizedBox.shrink();
        },
      ),
    );
  }
}
