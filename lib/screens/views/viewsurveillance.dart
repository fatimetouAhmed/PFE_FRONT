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
import '../../models/surveillance.dart';
import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../../widgets/rounded_button.dart';
import '../forms/etudiantform.dart';
class ViewSurveillance extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewSurveillance({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewSurveillance> createState() => _ViewSurveillanceState();
}

class _ViewSurveillanceState extends State<ViewSurveillance> {
  List<Surveillance> surveillancetsList = [Surveillance(0, DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'),0, 0,'','', )];
  Future<List<Surveillance>> fetchSurveillances(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer ${widget.accessToken}",
    };

    var response = await http.get(Uri.parse(baseUrl+'surveillances/'+id), headers: headers);
    if (response.statusCode != 200) {
      // Handle the error when the API request is not successful (e.g., status code is not 200 OK).
      throw Exception('Failed to fetch surveillances.');
    }

    var jsonList = jsonDecode(response.body);

    if (jsonList is List) {
      var surveillances = <Surveillance>[];
      for (var u in jsonList) {
        print(u); // Affiche les données pour déboguer

        var DateDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_debut']);
        var DateFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_fin']);

        print(DateDeb);
        print(DateFin);

        surveillances.add(Surveillance(
            u['id'], DateDeb, DateFin, u['surveillant_id'], u['salle_id'], u['superviseur'], u['departement']
        ));
      }


      return surveillances;
    } else {
      // Handle the case when the JSON response is not a list.
      throw Exception('Invalid JSON format: Expected a list of surveillances.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSurveillances(widget.id.toString()).then((surveillances) {
      setState(() {
        this.surveillancetsList = surveillances;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                          title:'Surveillant  :    '+surveillancetsList[0].surveillant,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: Icons.near_me,
                          title:'Salle  :    '+surveillancetsList[0].salle,
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date debut   :    '+DateFormat('yyyy-MM-dd').format(surveillancetsList[0].date_debut),
                        ),
                        SettingsItem(
                          onTap: () {},
                          // icons: CupertinoIcons.repeat,
                          title:'Date fin   :    '+DateFormat('yyyy-MM-dd').format(surveillancetsList[0].date_fin),
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

