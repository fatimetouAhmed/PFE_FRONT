import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../models/examun.dart';
import 'notifications.dart';

class GridViewWidgetExamun extends StatefulWidget {
  final int id;
  final String accessToken;
  const GridViewWidgetExamun({Key? key, required this.id,required this.accessToken}) : super(key: key);
  @override
  State<GridViewWidgetExamun> createState() => _GridViewWidgetExamunState();
}

class _GridViewWidgetExamunState extends State<GridViewWidgetExamun> {

  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<Examun> examunsList = [];
  Future<List<Examun>> fetchExamuns(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/'+ id),headers: headers);
    var data = utf8.decode(response.bodyBytes);

    var examuns = <Examun>[];
    for (var u in jsonDecode(data)) {// Adjust the date format here
      var heureDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_deb']);
      var heureFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_fin']);

      examuns.add(Examun(u['id'],u['type'],heureDeb,heureFin, u['id_mat'], u['id_sal']));}
    return examuns;
  }

  @override
  void initState() {
    super.initState();
    fetchExamuns(widget.id.toString()).then((examuns) {
      setState(() {
        examunsList = examuns;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<Examun>>(
          future: fetchExamuns(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List<Examun>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var examuns = snapshot.data!;

              return GridView.builder(
                itemCount: examuns.length,
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
                                MaterialPageRoute(builder: (context) =>MasterPage(child:Notifications(id: examuns[index].id, accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 0,),
                                ),  // Replace AutrePage() with the name of your other page.
                              );
                            },
                            child: Text(
                              examuns[index].type,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            DateFormat('MM-dd HH:mm').format(examuns[index].heure_deb),
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