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
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewFiliere extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewFiliere({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewFiliere> createState() => _ViewFiliereState();
}

class _ViewFiliereState extends State<ViewFiliere> {
  List<Filiere> filieresList = [Filiere(0, '', '', 0,'')];

  Future<List<Filiere>> fetchFilieres(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'filieresfiliere_by_id/'+id),headers: headers);
    var filieres = <Filiere>[];
    for (var u in jsonDecode(response.body)) {
      // print('Parsed JSON object: $u');
      filieres.add(Filiere(u['id'], u['nom'], u['description'],u['id_dep'], u['departement']));
    }
    print(filieres);
    return filieres;
  }

  @override
  void initState() {
    super.initState();
    fetchFilieres(widget.id.toString()).then((filieres) {
      setState(() {
        this.filieresList = filieres;
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
                          title:'Nom   :    '+filieresList[0].nom,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Description   :    '+filieresList[0].description,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.delete_solid,
                          title: 'Departement    :   '+filieresList[0].departement,
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

