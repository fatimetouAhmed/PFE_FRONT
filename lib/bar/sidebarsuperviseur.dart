import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import 'package:pfe_front_flutter/screens/login_screen.dart';

import '../screens/lists/historiques.dart';
import '../screens/lists/notifications.dart';
import 'masterpagesuperviseur.dart';

class SideBarSuperviseur extends StatefulWidget {
  @override
  _SideBarSuperviseurState createState() => _SideBarSuperviseurState();
}
Color indicatorColor = Colors.blue.shade300;
class _SideBarSuperviseurState extends State<SideBarSuperviseur> {
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
            builder: (context) => MasterPageSupeurviseur(
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
            builder: (context) => MasterPageSupeurviseur(
              child: ListSurveillance(),
            ),
          ),
        );
        break;
      case 2:
        indicatorColor = Colors.blue.shade300;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen()
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
                icon: Icon(Icons.notification_important),
                label: 'Notifications',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_2),
                label: 'Surveillants',
              ),
              NavigationDestination(
                icon: Icon(Icons.logout),
                label: 'Déconnection',
              ),
            ],
          ),
        );
      },
    );
  }
}
