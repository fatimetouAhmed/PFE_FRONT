import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/models/semestresmatieres.dart';
import '../../consturl.dart';
import '../../models/etudiermat.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
class ViewSemestreMatiere extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewSemestreMatiere({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewSemestreMatiere> createState() => _ViewSemestreMatiereState();
}

class _ViewSemestreMatiereState extends State<ViewSemestreMatiere> {
  List<SemestresMatieres> semestrematieresList = [SemestresMatieres(0,0,0,'','')];

  Future<List<SemestresMatieres>> fetchSemestre_Matieres(id) async {
    // print('execute1');
    // print(id);
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestresmatieres/read/'+id),headers: headers);
    var semestre_matieres = <SemestresMatieres>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_sem = u['id_sem'];
      var id_mat = u['id_mat'];
      var matiere = u['matiere'];
      var semestre = u['semestre'];

      if (id != null && id_sem != null && id_mat!= null && matiere != null && semestre != null) {
        //print(id+''+id_mat+''+id_sem+''+matiere+''+semestre);
        semestre_matieres.add(SemestresMatieres(id, id_sem, id_mat,matiere,semestre));
        print(semestre_matieres);
      }
      // else {
      //   print('Incomplete data for Semestre Matiere object');
      // }
    }
    return semestre_matieres;
  }

  @override
  void initState() {
    super.initState();
    fetchSemestre_Matieres(widget.id.toString()).then((semestrematieres) {
     // print('execute');
      setState(() {
        this.semestrematieresList = semestrematieres;
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
                              +semestrematieresList[0].semestres,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Matiere   :    '
                              +semestrematieresList[0].matieres,
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

