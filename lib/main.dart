import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
//import 'package:pfe_front_flutter/screens/lists/viewetudiant.dart';
import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'bar/masterpageadmin.dart';
void main() {
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
      home:
      LoginScreen(accessToken:accessToken),
    );
  }
}
