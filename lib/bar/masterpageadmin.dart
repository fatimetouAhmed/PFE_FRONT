import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/lists/historiques.dart';
import '../screens/lists/notifications.dart';
import 'appbar.dart';
import 'drawer.dart';

class MasterPage extends StatefulWidget {
  String accessToken = '';
  final Widget child;

  MasterPage({required this.child});

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int index = 0;

  void handleDestinationTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
    switch (selectedIndex) {
      case 0:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
              child: Notifications(accessToken: widget.accessToken),
            ),
          ),
        );
        break;
      case 1:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
              child: Notifications(accessToken: widget.accessToken),
            ),
          ),
        );
        break;
      case 2:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
              child: Historiques(),
            ),
          ),
        );
        break;
      case 3:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
              child: Notifications(accessToken: widget.accessToken),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedChild = widget.child; // Default widget is the passed child

    return Scaffold(
      drawer: NavBar(accessToken: widget.accessToken ),
      appBar: CustomAppBar(),
      body: Container(
        child: selectedChild,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.history, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) => handleDestinationTap(index),
        letIndexChange: (index) => true,
      ),
    );
  }
}
