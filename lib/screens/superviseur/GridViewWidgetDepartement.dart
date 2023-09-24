import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/screens/superviseur/GridViewWidgetFiliere.dart';

import '../../bar/masterpagesuperviseur.dart';
import '../../consturl.dart';
import '../../models/departementssuperviseurs.dart';
import 'package:http/http.dart' as http;
class GridViewWidget extends StatefulWidget {
  final int id;
  final String accessToken;
  const GridViewWidget({Key? key, required this.id,required this.accessToken}) : super(key: key);

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<DepartementsSuperviseurs> departementsList = [];
  Future<List<DepartementsSuperviseurs>> fetchDepartements(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'departementssuperviseurs/read/'+ id),headers: headers);
    var departements = <DepartementsSuperviseurs>[];
    for (var u in jsonDecode(response.body)) {
      var date_debut = DateFormat('yyyy-MM-dd').parse(u['date_debut']);
      var date_fin = DateFormat('yyyy-MM-dd').parse(u['date_fin']);// Adjust the date format here
      departements.add(DepartementsSuperviseurs(u['id'],u['id_sup'],u['id_dep'],'', u['departement'], date_debut,date_fin));
    }
    return departements;
  }

  @override
  void initState() {
    super.initState();
    fetchDepartements(widget.id.toString()).then((departements) {
      setState(() {
        departementsList = departements;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<DepartementsSuperviseurs>>(
          future: fetchDepartements(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<DepartementsSuperviseurs>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var departements = snapshot.data!;

              return GridView.builder(
                itemCount: departements.length,
                itemBuilder: (context,index){
                  if (departements[index].date_debut.isBefore(DateTime.now()) &&
                      departements[index].date_fin.isAfter(DateTime.now())) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              size: 90,
                              color: colors.withOpacity(0.9),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("action push");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>MasterPageSupeurviseur(child:GridViewWidgetFiliere(id:  departements[index].id_dep, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                                      ), // Replace AutrePage() with the name of your other page.
                                );
                              },
                              child: Text(
                                departements[index].departement,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // Text(departements[index].date as String,style: TextStyle(fontSize: 18),)
                          ],
                        ),
                      ),
                    );
                  }
                  else{
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        elevation: 5.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_clock,
                              size: 60,
                              color: colors.withOpacity(0.9),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      content: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "Vous n'êtes plus superviseur de ce département, vous ne pouvez donc plus accéder à ses informations",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                departements[index].departement,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),

                            // Text(departements[index].date as String,style: TextStyle(fontSize: 18),)
                          ],
                        ),
                      ),
                    );
                  }

                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
              );
            }}),);
  }

}