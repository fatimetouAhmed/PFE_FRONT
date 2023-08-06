// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
//
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:pfe_front_flutter/constants.dart';
// import 'package:pfe_front_flutter/screens/forms/surveillanceform.dart';
// import '../models/surveillance.dart';
// import '../screens/lists/listsurveillant.dart';
// import '../screens/lists/notifications.dart';
// import '../screens/login_screen.dart';
// import 'appbarsuperviseur.dart';
// import 'package:http/http.dart' as http;
//
// class MasterPageSupeurviseur extends StatefulWidget {
//
//
//   MasterPageSupeurviseur({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _MasterPageSupeurviseurState createState() => _MasterPageSupeurviseurState();
// }
//
// class _MasterPageSupeurviseurState extends State<MasterPageSupeurviseur> {
//   // Set a default value
//   int _currentIndex = 0;
//   List<Widget> pages=[
//     Container(),
//     Container(),
//     Container(),
//     Container(),
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       // appBar: CustomAppBar(),
//       body: getBody(),
//       bottomNavigationBar:getFooter(),
//       floatingActionButton: SafeArea(
//           child: SizedBox(child: FloatingActionButton(
//             onPressed: (){},
//             child: Icon(Icons.add,size: 20,),
//           ),)
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//   Widget getBody(){
//     return IndexedStack(
//       index: _currentIndex,
//       children: pages,
//     );
//   }
//   Widget getFooter(){
//     List<IconData> iconItems = [
//       CupertinoIcons.home,
//       CupertinoIcons.bell,
//       CupertinoIcons.time,
//       CupertinoIcons.person,
//     ];
//     return AnimatedBottomNavigationBar(
//       onTap:(index){
//         //_currentIndex=index;
//         setTab(index);
//       },
//       backgroundColor: Colors.blue, // Replace with your color
//       icons: iconItems, // Make sure you have defined iconItems
//       splashColor: Colors.green, // Replace with your color
//       inactiveColor: Colors.black.withOpacity(0.5), // Replace with your color
//       activeIndex: _currentIndex,
//     );
//   }
//   setTab(index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
// }
