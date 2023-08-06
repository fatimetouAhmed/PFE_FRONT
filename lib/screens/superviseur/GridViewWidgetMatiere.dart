import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../../bar/masterpagesuperviseur.dart';
import '../../../models/filieresmatieres.dart';

import 'GridViewWidgetExamun.dart';
class GridViewWidgetMatiere extends StatefulWidget {
  final int id;
  final String accessToken;
  const GridViewWidgetMatiere({Key? key, required this.id,required this.accessToken}) : super(key: key);
  @override
  State<GridViewWidgetMatiere> createState() => _GridViewWidgetMatiereState();
}

class _GridViewWidgetMatiereState extends State<GridViewWidgetMatiere> {

  final colors=Colors.blueAccent;
  List<FilieresMatieres> fileresList = [];
  Future<List<FilieresMatieres>> fetchMatieres(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
       "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieresmatieres/'+ id),headers: headers);
    var data = utf8.decode(response.bodyBytes);

    var departements = <FilieresMatieres>[];
    for (var u in jsonDecode(data)) {// Adjust the date format here
      departements.add(FilieresMatieres(u['id'],u['id_mat'],0, u['matieres'],''));
    }
    return departements;
  }

  @override
  void initState() {
    super.initState();
    fetchMatieres(widget.id.toString()).then((fileres) {
      setState(() {
        fileresList = fileres;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<FilieresMatieres>>(
          future: fetchMatieres(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<FilieresMatieres>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var matieres = snapshot.data!;

              return GridView.builder(
                itemCount: matieres.length,
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
                            Icons.description,
                            size: 60,
                            color: colors.withOpacity(0.9),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(matieres[index].id_mat);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>MasterPageSupeurviseur(child:GridViewWidgetExamun(id: matieres[index].id_mat, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                                ),  // Replace AutrePage() with the name of your other page.
                              );
                            },
                            child: Text(
                              matieres[index].matieres,
                              style: TextStyle(fontSize: 18),
                            ),
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