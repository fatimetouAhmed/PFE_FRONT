import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/semestre.dart';
import 'Matiere.dart';
class GridViewWidgetSemestre extends StatefulWidget {
  final int id;
  final String accessToken;
  const GridViewWidgetSemestre({Key? key, required this.id,required this.accessToken}) : super(key: key);
  @override
  State<GridViewWidgetSemestre> createState() => _GridViewWidgetSemestreState();
}

class _GridViewWidgetSemestreState extends State<GridViewWidgetSemestre> {

  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<Semestre> semestresList = [];
  Future<List<Semestre>> fetchSemestres(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestres/semestre/'+ id),headers: headers);
    var data = utf8.decode(response.bodyBytes);

    var semestres = <Semestre>[];
    for (var u in jsonDecode(data)) {// Adjust the date format here
      var dateDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_debut']);
      var dateFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_fin']);

      semestres.add(Semestre(u['id'],u['nom'],u['id_fil'],dateDeb,dateFin,""));}
    return semestres;
  }

  @override
  void initState() {
    super.initState();
    fetchSemestres(widget.id.toString()).then((semestres) {
      setState(() {
        semestresList = semestres;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<Semestre>>(
          future: fetchSemestres(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<Semestre>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var semestres = snapshot.data!;

              return GridView.builder(
                itemCount: semestres.length,
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
                            Icons.e_mobiledata,
                            size: 60,
                            color: colors.withOpacity(0.9),
                          ),
                          GestureDetector(
                            onTap: () {
                              // print(examuns[index].id_mat);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>MasterPage(child:GridViewWidgetMatiere(id: semestres[index].id, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                                ),  // Replace AutrePage() with the name of your other page.
                              );
                            },
                            child: Text(
                              semestres[index].nom,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(semestres[index].date_debut),
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(semestres[index].date_fin),
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