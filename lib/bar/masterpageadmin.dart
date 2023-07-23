import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';

import 'appbar.dart';
import 'drawer.dart';

class MasterPage extends StatelessWidget {
  final Widget child; // Ajout du paramètre 'child'
  //String accessToken = '';

  MasterPage({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar:CustomAppBar(),
      // body: AmazingCharts(),
      body:Container(
        child: child, // Affichez le widget enfant passé en paramètre
      ),
      bottomNavigationBar: SideBar(),
    );
  }
}