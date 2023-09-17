import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfe_front_flutter/screens/forms/surveillanceform.dart';
import 'package:pfe_front_flutter/screens/surveillant/addpv.dart';
import '../models/surveillance.dart';
import '../screens/lists/listsurveillant.dart';
import '../screens/lists/notifications.dart';
import '../screens/login_screen.dart';
import '../screens/superviseur/GridViewWidgetDepartement.dart';
import 'appbarsuperviseur.dart';
import 'package:http/http.dart' as http;

import 'appbarsurveillant.dart';

class MasterPageSurveillant extends StatefulWidget {
  late final Widget child;
  final String accessToken;
  final int index;
  MasterPageSurveillant({
    Key? key,
    required this.child,
    required this.accessToken,
    required this.index,
  }) : super(key: key);

  @override
  _MasterPageSurveillantState createState() => _MasterPageSurveillantState();
}

class _MasterPageSurveillantState extends State<MasterPageSurveillant> {
 late Widget _currentWidget ; // Set a default value
  int _currentIndex = 0;

  final colors=Colors.blueAccent;
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
        Uri.parse('http://192.168.186.113:8000/notifications/nb_notifications_no_read/'),
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
          _currentWidget = PvForm(accessToken: widget.accessToken, id: 0, description: '', nni: '', tel: 0, photo: '',);
          break;
        case 1:
          _currentWidget = PvForm(accessToken: widget.accessToken, id: 0, description: '', nni: '', tel: 0, photo: '',);
          break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(accessToken: widget.accessToken),
          ),
        );

        break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: CustomAppBar(),
      body: Container(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: CustomAppBarSurveillant(),
          body: _currentWidget,
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       // StackWidgetFiliere(id: widget.id,)
          //       Stack(
          //         children: [
          //           Container(
          //             decoration: BoxDecoration(
          //               // borderRadius: BorderRadius.circular(30),
          //               color: colors,
          //             ),
          //             height: 200,
          //             child:
          //             ListTile(
          //               contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          //               title: Text('Hello Ahad!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //                   color: Colors.white
          //               )),
          //               subtitle: Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                   color: Colors.white54
          //               )),
          //               trailing: const CircleAvatar(
          //                 radius: 30,
          //                 backgroundImage: AssetImage('images/image2.jpg'),
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(top: 130.0),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white
          //               ),
          //               height: 500,
          //               child: widget.child,
          //               // color: Colors.white,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            height: 60.0,
            items: [
              Icon(Icons.home, size: 30),
              Icon(Icons.add, size: 30),
              Icon(Icons.logout, size: 30),
            ],
            onTap: handleDestinationTap,
            // Rest of the CurvedNavigationBar properties...
          ),


        ),
      ),

    );
  }
}
