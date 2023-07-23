import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/sidebarsuperviseur.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';

import 'appbarsuperviseur.dart';

class MasterPageSupeurviseur extends StatelessWidget {
  final Widget child; // Ajout du paramètre 'child'

  MasterPageSupeurviseur({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(),
      // body: AmazingCharts(),
      body:Container(
        child: child, // Affichez le widget enfant passé en paramètre
      ),
      bottomNavigationBar: SideBarSuperviseur(),
    );
  }
}