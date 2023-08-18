import 'dart:convert';

import 'package:flutter/material.dart';

import '../../bar/masterpageadmin.dart';
import '../../models/departement.dart';
import 'package:http/http.dart' as http;

import 'Filiere.dart';
class GridViewWidget extends StatefulWidget {
 // final int id;
  final String accessToken;
  const GridViewWidget({Key? key,
   // required this.id,
    required this.accessToken}) : super(key: key);

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<Departement> departementsList = [];
  Future<List<Departement>> fetchDepartements() async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/departements/'),headers: headers);
    var departements = <Departement>[];
    for (var u in jsonDecode(response.body)) {// Adjust the date format here
      departements.add(Departement(u['id'],u['nom']));
    }
    return departements;
  }

  @override
  void initState() {
    super.initState();
    fetchDepartements().then((departements) {
      setState(() {
        departementsList = departements;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<Departement>>(
          future: fetchDepartements(),
          builder: (BuildContext context, AsyncSnapshot<List<Departement>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var departements = snapshot.data!;

              return GridView.builder(
                itemCount: departements.length,
                itemBuilder: (context,index){
                  // if (departements[index].date_debut.isBefore(DateTime.now()) &&
                  //     departements[index].date_fin.isAfter(DateTime.now())) {
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
                                  MaterialPageRoute(builder: (context) =>MasterPage(child:GridViewWidgetFiliere(id:  departements[index].id, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                                      ), // Replace AutrePage() with the name of your other page.
                                );
                              },
                              child: Text(
                                departements[index].nom,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // Text(departements[index].date as String,style: TextStyle(fontSize: 18),)
                          ],
                        ),
                      ),
                    );
                 // }
                  },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
              );
            }}),);
  }

}