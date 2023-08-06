import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'bar/masterpageadmin.dart';
void main() {
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent
  // ));
  runApp(MyApp(accessToken:''));
}

class MyApp extends StatelessWidget {
  final String accessToken;
  MyApp({Key? key,required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginScreen(accessToken:accessToken),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // debugShowMaterialGrid: false,
//
//       home: LoginScreen(),
//     );
//   }
// }



// import 'dart:ffi';
// import 'package:pfe_front/chart.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//
//       debugShowCheckedModeBanner: false,
//       home: Chart(),
//     );
//   }
// }