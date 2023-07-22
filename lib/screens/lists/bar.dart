// import 'dart:js';
//
// import 'package:flutter/material.dart';
// class SideBar extends StatefulWidget {
//   @override
//   _SideBarState createState() => _SideBarState();
// }
//
// class _SideBarState extends State<SideBar> {
//   int index = 0;
//
//   void handleDestinationTap(int selectedIndex) {
//     setState(() {
//       index = selectedIndex;
//     });
//
//     // Perform actions based on the selected index
//     switch (selectedIndex) {
//       case 0:
//       // Action for "Home" tapped
//         print('Home tapped');
//         break;
//       case 1:
//       // Action for "Notifications" tapped
//         print('Notifications tapped');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MasterPage(
//               child: Notifications(),
//             ),
//           ),
//         );
//         break;
//       case 2:
//       // Action for "Historiques" tapped
//         print('Historiques tapped');
//         break;
//       case 3:
//       // Action for "Settings" tapped
//         print('Settings tapped');
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBarTheme(
//       data: NavigationBarThemeData(
//         indicatorColor: Colors.blue.shade300,
//         labelTextStyle: MaterialStateProperty.all(
//           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ),
//       child: NavigationBar(
//         height: 60,
//         backgroundColor: Color(0xFFf1f5fb),
//         selectedIndex: index,
//         onDestinationSelected: handleDestinationTap,
//         destinations: [
//           NavigationDestination(
//             icon: Icon(Icons.home),
//             label: 'home',
//           ),
//           InkWell(
//             onTap: () => handleDestinationTap(1),
//             child: NavigationDestination(
//               icon: Icon(Icons.notification_important),
//               label: 'Notifications',
//             ),
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.history),
//             label: 'Historiques',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
