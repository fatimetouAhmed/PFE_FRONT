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

import '../../models/filliere.dart';
import '../../models/semestre.dart';
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewSemestre extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewSemestre({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewSemestre> createState() => _ViewSemestreState();
}

class _ViewSemestreState extends State<ViewSemestre> {
  List<Semestre> semestresList = [Semestre(0, '', 0, DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'),'')];

  Future<List<Semestre>> fetchFilieres(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestres/semestre_filiere/'+id),headers: headers);
    var semestres = <Semestre>[];
    for (var u in jsonDecode(response.body)) {
      // print('Parsed JSON object: $u');
      var dateDeb = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(u['date_debut']);
      var dateFin = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(u['date_fin']);

      semestres.add(Semestre(u['id'], u['nom'], u['id_fil'],dateDeb,dateFin, u['filiere']));
    }
    //print(semestres);
    return semestres;
  }



  @override
  void initState() {
    super.initState();
    fetchFilieres(widget.id.toString()).then((semestres) {
      setState(() {
        this.semestresList = semestres;
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
                height: 350,
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
                          title:'Nom   :    '+semestresList[0].nom,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date debut   :    '+DateFormat('yyyy-MM-dd').format(semestresList[0].date_debut),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date fin   :    '+DateFormat('yyyy-MM-dd').format(semestresList[0].date_fin),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.delete_solid,
                          title: 'Filiere    :   '+semestresList[0].filiere,
                          titleStyle: TextStyle(
                            // color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
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

