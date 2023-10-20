import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_front_flutter/screens/admin/dashbordAnne.dart';
import 'package:pfe_front_flutter/screens/admin/stats.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import 'package:pfe_front_flutter/screens/login/login_page.dart';

import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'bar/masterpageadmin.dart';
import 'notification_manager/notification_manager.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
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
      LoginPage(accessToken:accessToken),
    );
  }
}

