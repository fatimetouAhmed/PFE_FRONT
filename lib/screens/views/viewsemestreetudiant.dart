import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/models/semestresmatieres.dart';
import '../../consturl.dart';
import '../../models/etudiermat.dart';
import '../../models/semestre_etudiant.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
class ViewSemestreEtudiant extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewSemestreEtudiant({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewSemestreEtudiant> createState() => _ViewSemestreEtudiantState();
}

class _ViewSemestreEtudiantState extends State<ViewSemestreEtudiant> {

  List<Semestre_Etudiant> semestre_etudiantsList = [Semestre_Etudiant(0,0,0,'','')];

  Future<List<Semestre_Etudiant>> fetchSemestre_Etudiants(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestre_etudiants/read/'+id),headers: headers);
    var semestre_etudiants = <Semestre_Etudiant>[];
    for (var u in jsonDecode(response.body)) {
      semestre_etudiants.add(Semestre_Etudiant(u['id'], u['id_sem'], u['id_etu'],u['semestre'],u['etudiant']));
    }
    // print(semestre_etudiants);
    return semestre_etudiants;
  }

  @override
  void initState() {
    super.initState();
    fetchSemestre_Etudiants(widget.id.toString()).then((semestreetudiants) {
      // print('execute');
      setState(() {
        this.semestre_etudiantsList = semestreetudiants;
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
            Text('Etudier Matiere details',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
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
                height: 200,
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
                          title:'Semestre   :    '
                              +semestre_etudiantsList[0].semestre,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Etudiant   :    '
                              +semestre_etudiantsList[0].etudiant,
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

