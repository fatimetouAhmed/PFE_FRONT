import 'package:flutter/material.dart';

import '../screens/lists/historiques.dart';
import '../screens/lists/notifications.dart';
import 'masterpageadmin.dart';

class SideBar extends StatefulWidget {
 
  @override
  _SideBarState createState() => _SideBarState();
}
Color indicatorColor = Colors.blue.shade300;
class _SideBarState extends State<SideBar> {
  int index = 0;

  void handleDestinationTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });

    // Perform actions based on the selected index
    switch (selectedIndex) {
      case 0:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
              child: Notifications(),
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
              child: Notifications(),
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
              child: Notifications(),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: indicatorColor,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Color(0xFFf1f5fb),
            selectedIndex: index,
            onDestinationSelected: handleDestinationTap,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              NavigationDestination(
                icon: Icon(Icons.notification_important),
                label: 'Notifications',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'Historiques',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
