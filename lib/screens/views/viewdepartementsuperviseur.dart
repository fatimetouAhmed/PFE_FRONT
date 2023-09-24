import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/departementssuperviseurs.dart';
import '../../models/etudiant.dart';

import '../../models/filliere.dart';
import '../../models/semestre.dart';
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewDepartementSuperviseur extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewDepartementSuperviseur({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewDepartementSuperviseur> createState() => _ViewDepartementSuperviseurState();
}

class _ViewDepartementSuperviseurState extends State<ViewDepartementSuperviseur> {
 List<DepartementsSuperviseurs> departementsuperviseursList = [DepartementsSuperviseurs(0, 0, 0,'','', DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'))];

  Future<List<DepartementsSuperviseurs>> fetchDepartementSuperviseurs(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'departementssuperviseurs/read_data/'+id),headers: headers);
    var departementsuperviseurs = <DepartementsSuperviseurs>[];
    for (var u in jsonDecode(response.body)) {
      var dateDeb = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(u['date_debut']);
      var dateFin = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(u['date_fin']);
      departementsuperviseurs.add(DepartementsSuperviseurs(u['id'], u['id_sup'], u['id_dep'], u['superviseur'], u['departement'],dateDeb,dateFin));
    }
    //print(semestres);
    return departementsuperviseurs;
  }

  @override
  void initState() {
    super.initState();
    fetchDepartementSuperviseurs(widget.id.toString()).then((departementsuperviseurs) {
      setState(() {
        this.departementsuperviseursList = departementsuperviseurs;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            SizedBox(width: 40), // Réduire l'espace entre l'icône et le texte
            Text('Semestre details',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            Container(height: 24,width: 24,)
          ],
        ),
      ),
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
                height: 300,
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
                          title:'Superviseur  :    '+departementsuperviseursList[0].superviseur,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: Icons.near_me,
                          title:'Superviseur  :    '+departementsuperviseursList[0].departement,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date debut   :    '+DateFormat('yyyy-MM-dd').format(departementsuperviseursList[0].date_debut),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date fin   :    '+DateFormat('yyyy-MM-dd').format(departementsuperviseursList[0].date_fin),
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

