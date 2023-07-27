import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/sidebarsuperviseur.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/bar/sidebaradmin.dart';

import 'appbarsuperviseur.dart';

class MasterPageSupeurviseur extends StatelessWidget {
  final Widget child; // Ajout du paramètre 'child'
  final String accessToken;
  MasterPageSupeurviseur({Key? key,required this.child, required this.accessToken}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(),
      // body: AmazingCharts(),
      body:Container(
        child: child, // Affichez le widget enfant passé en paramètre
      ),
      bottomNavigationBar: SideBarSuperviseur(accessToken: accessToken),
    );
  }
}