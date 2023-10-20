import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';

import '../../models/etudiermat.dart';
import '../../models/examun.dart';
import '../../models/filliere.dart';
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewExamun extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewExamun({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewExamun> createState() => _ViewExamunState();
}

class _ViewExamunState extends State<ViewExamun> {
  List<Examun> examunsList = [Examun(0, '', DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'), 0, 0,'','')];

  Future<List<Examun>> fetchExamuns(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'examuns/'+id),headers: headers);
    var examuns = <Examun>[];
    for (var u in jsonDecode(response.body)) {
      // print(u['heure_deb']);
      // print(u['heure_fin']);

      var heureDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_deb']);
      var heureFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_fin']);

      examuns.add(Examun(u['id'],u['type'],heureDeb,heureFin, u['id_mat'], u['id_sal'], u['matiere'], u['salle']));
    }
    print(examuns);
    return examuns;
  }

  @override
  void initState() {
    super.initState();
    fetchExamuns(widget.id.toString()).then((examuns) {
      setState(() {
        this.examunsList = examuns;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:
      SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [

            background_container(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 450,
                width: 340,
                child:
                Column(
                  children: [
                    SettingsGroup(
                      settingsGroupTitle: '',
                      items: [

                        SettingsItem(
                          onTap: () {},
                          // icons: Icons.near_me,
                          title:'Type   :    '+examunsList[0].type,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date Debut   :    '+DateFormat('yyyy-MM-dd').format(examunsList[0].date_deb),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date fin   :    '+DateFormat('yyyy-MM-dd').format(examunsList[0].date_fin),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Matiere   :    '+examunsList[0].matiere,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Salle   :    '+examunsList[0].salle,
                        ),

                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                child:   Center(
                  child: Text(
                    'Details',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  //   ),
                  //
                  // ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }


}

