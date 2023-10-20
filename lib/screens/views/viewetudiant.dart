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

import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../forms/etudiantform.dart';
class ViewEtudiant extends StatefulWidget {
  final String accessToken;
final int id;
  ViewEtudiant({Key? key, required this.accessToken, required this.id,
   // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewEtudiant> createState() => _ViewEtudiantState();
}

class _ViewEtudiantState extends State<ViewEtudiant> {

  List<Etudiant> etudiantsList = [Etudiant(0, '', '', '', '', DateTime.parse('0000-00-00 00:00:00'), '', '',0,'', DateTime.parse('0000-00-00 00:00:00'),0)];

  Future<List<Etudiant>> fetchEtudiants(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'annees/etudiants/'+id),
        headers: headers
    );
    var etudiants = <Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List) {
      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['nom'];
        var prenom = u['prenom'];
        var photo = u['photo'];
        var genre= u['genre'];
        var date_N = DateFormat('yyyy-MM-dd').parse(u['date_N']);
        var lieu_n = u['lieu_n'];
        var email = u['email'];
        var telephone = u['telephone'];
        var nationalite = u['nationalite'];
        var date_insecription = DateFormat('yyyy-MM-dd').parse(u['date_insecription']);
        var id_fil=u['id_fil'];
        etudiants.add(Etudiant(id, nom, prenom,photo,genre, date_N,lieu_n,email,telephone,nationalite,date_insecription,id_fil));
      }
    } else {
      print("La réponse JSON ne contient pas une liste d'étudiants.");
    }

    return etudiants;
  }
  //
  // Future delete(id) async {
  //   var headers = {
  //     "Authorization": "Bearer ${widget.accessToken}",
  //   };
  //   await http.delete(Uri.parse(baseUrl+'matieres/' + id),headers: headers);
  // }
  @override
  void initState() {
    super.initState();
    //etudiantsList.add(Etudiant(0, '', '', '', '', DateTime.parse('0000-00-00 00:00:00'), '', '',0,'', DateTime.parse('0000-00-00 00:00:00'))); // Add this line if you still need to add null to the list
    fetchEtudiants(widget.id.toString()).then((etudiants) {
      setState(() {
        this.etudiantsList = etudiants;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
        //  backgroundColor: Colors.white.withOpacity(.94),

        body:
        Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card

              CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Image.asset('images/etudiants/${etudiantsList[0].photo}',height: 150,width: 150,fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: 20,),

        Expanded(child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Colors.blueAccent],
                // colors: [Colors.black54,Color.fromRGBO(0, 41, 102, 1)]
              )
          ),
          child:
              SettingsGroup(
                settingsGroupTitle: '',
                items: [

                  SettingsItem(
                    onTap: () {},
                    // icons: Icons.near_me,
                    title: etudiantsList[0].nom,
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:etudiantsList[0].prenom,
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.delete_solid,
                    title: etudiantsList[0].email,
                    titleStyle: TextStyle(
                      // color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:etudiantsList[0].genre,
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:etudiantsList[0].lieu_n,
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,

                    title: DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_N),
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:etudiantsList[0].telephone.toString(),
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:etudiantsList[0].nationalite,
                  ),
                  SettingsItem(
                    onTap: () {},
                    // icons: CupertinoIcons.repeat,
                    title:DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_insecription),
                  ),


                ],
              ),
        )
        )
            ],
          ),
        ),
      );

  }
}

