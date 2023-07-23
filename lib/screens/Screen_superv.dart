import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/notifications.dart';

import '../bar/masterpagesuperviseur.dart';

class SupervisorScreen extends StatelessWidget {
  final String accessToken;
  const SupervisorScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterPageSupeurviseur(child:Notifications())
    ;
  }
}
