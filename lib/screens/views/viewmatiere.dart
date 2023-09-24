import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/models/matiere.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';

import '../../models/filliere.dart';
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewMatiere extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewMatiere({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewMatiere> createState() => _ViewMatiereState();
}

class _ViewMatiereState extends State<ViewMatiere> {

  List<Matiere> matieresList = [Matiere(0, '', 0, 0,)];

  Future<List<Matiere>> fetchMatieres(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'matieres/'+id),headers: headers);
    var matieres = <Matiere>[];
    for (var u in jsonDecode(response.body)) {
      matieres.add(Matiere(u['id'], u['libelle'],u['nbre_heure'],u['credit']));
    }
    print(matieres);
    return matieres;
  }

  @override
  void initState() {
    super.initState();
    fetchMatieres(widget.id.toString()).then((matieres) {
      setState(() {
        this.matieresList = matieres;
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
            Text('Matiere details',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
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
                height: 250,
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
                          title:'Libelle         :          '+matieresList[0].libelle,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Credit           :            '+matieresList[0].credit.toString(),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.delete_solid,
                          title: 'Nombre des heures :          '+matieresList[0].nbre_heure.toString(),
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

