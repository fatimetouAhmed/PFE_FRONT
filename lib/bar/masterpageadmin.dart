import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfe_front_flutter/screens/admin/dashbordAnne.dart';
import 'package:pfe_front_flutter/screens/lists/listpv.dart';
import '../screens/admin/Departement.dart';
import '../screens/admin/dashbordSurveillance.dart';
import '../screens/admin/dashord.dart';
import '../screens/admin/stats.dart';
import '../screens/lists/historiques.dart';
import '../screens/lists/notifications.dart';
import 'appbar.dart';
import 'apropos.dart';
import 'drawer.dart';

class MasterPage extends StatefulWidget {
  final Widget child;
  final int index;
  final String accessToken;

  MasterPage({required this.child, required this.index,required this.accessToken});

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  late Widget _currentWidget ;
  // = Notifications(accessToken: ''); // Set a default value
  int _currentIndex = 0;
  Color defaultColor=Colors.blueAccent;
  @override
  void initState(){
    super.initState();
    _currentWidget=this.widget.child;
    _currentIndex=this.widget.index;
  }
  void handleDestinationTap(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      switch (selectedIndex) {
        case 0:
          _currentWidget =DashBoardAnnee();
          break;
        case 1:
          _currentWidget = BarChartAPI();
          break;
        case 2:
          _currentWidget = Notifications(accessToken: widget.accessToken);
          break;
        // case 3:
        //   // _currentWidget = DashBoardSurveillance(accessToken: widget.accessToken, nomDep: '',);
        //   break;
        case 3:
          // _currentWidget = Apropos();
          break;
      // Add more cases for other indices if needed
        default:
        // Handle default case or leave empty if not needed
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // Widget selectedChild = widget.child; // Default widget is the passed child

    return Scaffold(
      // drawer:NavBar(accessToken:widget.accessToken,),
      appBar: CustomAppBar(),
      body:  _currentWidget,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _currentIndex == 0 ? Colors.white : defaultColor),
          Icon(Icons.table_chart, size: 30, color: _currentIndex == 1 ? Colors.white : defaultColor),
          Icon(Icons.notification_important,size: 30, color: _currentIndex == 2 ? Colors.white : defaultColor),
          // Icon(Icons.monitor, size: 30, color: _currentIndex == 3 ? Colors.white : defaultColor),
          Icon(Icons.info_rounded, size: 30, color: _currentIndex == 3 ? Colors.white : defaultColor),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) => handleDestinationTap(index),
        letIndexChange: (index) => true,
      ),
    );
  }
}
