import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../../bar/masterpagesuperviseur.dart';
import '../../../models/filieresmatieres.dart';
import '../../models/filliere.dart';
import 'GridViewWidgetMatiere.dart';

class GridViewWidgetFiliere extends StatefulWidget {
  final int id;
  final String accessToken;
  const GridViewWidgetFiliere({Key? key, required this.id,required this.accessToken}) : super(key: key);
  @override
  State<GridViewWidgetFiliere> createState() => _GridViewWidgetFiliereState();
}

class _GridViewWidgetFiliereState extends State<GridViewWidgetFiliere> {

  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<Filiere> fileresList = [];
  Future<List<Filiere>> fetchFilieres(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
       "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/'+ id),headers: headers);
    var data = utf8.decode(response.bodyBytes);

    var departements = <Filiere>[];
    for (var u in jsonDecode(data)) {// Adjust the date format here
      departements.add(Filiere(u['id'],u['nom'], u['description'],0,''));
    }
    return departements;
  }

  @override
  void initState() {
    super.initState();
    fetchFilieres(widget.id.toString()).then((fileres) {
      setState(() {
        fileresList = fileres;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<Filiere>>(
          future: fetchFilieres(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<Filiere>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var filieres = snapshot.data!;

              return GridView.builder(
                itemCount: filieres.length,
                itemBuilder: (context,index){
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
                              Icons.fact_check_outlined,
                              size: 60,
                              color: colors.withOpacity(0.9),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>MasterPageSupeurviseur(child:GridViewWidgetMatiere(id: filieres[index].id, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                               ),  // Replace AutrePage() with the name of your other page.
                                );
                              },
                              child: Text(
                                filieres[index].nom,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Text(
                              filieres[index].description,
                              style: TextStyle(fontSize: 12),
                            ),

                          ],
                        ),
                      ),
                    );

                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
              );
            }}),);
  }

}