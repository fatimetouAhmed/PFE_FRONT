import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/admin/Departement.dart';
import '../screens/admin/stats.dart';
import '../screens/lists/historiques.dart';
import '../screens/lists/notifications.dart';
import 'appbar.dart';
import 'drawer.dart';

class MasterPage2 extends StatefulWidget {
  final Widget child;
  final int index;
  final String accessToken;

  MasterPage2({required this.child, required this.index,required this.accessToken});

  @override
  _MasterPage2State createState() => _MasterPage2State();
}

class _MasterPage2State extends State<MasterPage2> {
  late Widget _currentWidget ;
  // = Notifications(accessToken: ''); // Set a default value
  int _currentIndex = 0;
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
          _currentWidget = BarChartAPI();
          break;
        case 1:
          _currentWidget = Notifications(accessToken: widget.accessToken);
          break;
        case 2:
          _currentWidget = Historiques();
          break;
        case 3:
          _currentWidget = GridViewWidget(accessToken: widget.accessToken);
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

     // appBar: CustomAppBar(),
      body:  _currentWidget,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40, // Définir la largeur souhaitée de l'icône
                height: 40, // Définir la hauteur souhaitée de l'icône
                child: Icon(Icons.notification_important),
              ),
              Positioned(
                top: -1,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  child: Text(
                    '23',
                    // Remplacez ceci par le véritable nombre de notifications
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),


          Icon(Icons.history, size: 30),
          Icon(Icons.archive, size: 30),
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
