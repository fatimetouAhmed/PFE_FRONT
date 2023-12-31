import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/models/surveillance.dart';
import 'package:pfe_front_flutter/screens/forms/departementform.dart';
import 'package:pfe_front_flutter/screens/views/viewsurveillance.dart';
import '../../../constants.dart';
import '../../bar/masterpageadmin2.dart';
import '../../consturl.dart';
import '../../models/departement.dart';
import '../forms/surveillanceform.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class ListSurveillance extends StatefulWidget {
  final String accessToken;
  final String nomDep;
  final String nomNiv;
  ListSurveillance({Key? key, required this.accessToken, required this.nomDep, required this.nomNiv}) : super(key: key);
  @override
  State<ListSurveillance> createState() => _ListSurveillanceState();
}

class _ListSurveillanceState extends State<ListSurveillance> {
  List<Surveillance> surveillancetsList = [];
  Future<int?> fetch_User_current_Id() async {

    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'current_user_id/'),headers: headers);


    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<List<Surveillance>> fetchSurveillances(String dep,String niv) async {
    // var headers = {
    //   "Content-Type": "application/json; charset=utf-8",
    //   "Authorization": "Bearer ${widget.accessToken}",
    // };

    var response = await http.get(Uri.parse(baseUrl+'scolarites/Surveillances/$dep/$niv'),
        // headers: headers
    );
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
  Future<int?> fetchSuperviseurId() async {
    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/current_user_id/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse('http://127.0.0.1:8000/surveillances/' + id),headers: headers);
  }
  int id=0;
  @override
  void initState() {
    super.initState();
    fetchData(); // Call the async method to fetch data
  }

  Future<void> fetchData() async {
    int id = await fetchSuperviseurId() as int;
    print(id);
    print(widget.accessToken);
    fetchSurveillances(widget.nomDep,widget.nomNiv).then((surveillances) {
      setState(() {
        surveillancetsList = surveillances;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      // MasterPage(
      // child:
      SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 190, child: _head()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Surveillances',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MasterPage(
                                        accessToken:widget.accessToken,
                                        index: 0,
                                        child:
                                        SurveillanceForm(surveillance: Surveillance(0,  DateTime.parse('0000-00-00 00:00:00'), DateTime.parse('0000-00-00 00:00:00'),0,0,'',''), accessToken: widget.accessToken,),
                                      ),
                                ),
                                // ),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40.0,
                              semanticLabel: 'Add',
                              weight: 600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kDefaultPadding / 2),
                    Container(
                      height: MediaQuery.of(context).size.height - 370,
                      child:                    Scaffold(
                        body: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding,
                            vertical: kDefaultPadding / 2,
                          ),
                          child: FutureBuilder<List<Surveillance>>(
                            future: fetchSurveillances(widget.nomDep,widget.nomNiv),
                            builder: (BuildContext context, AsyncSnapshot<List<Surveillance>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                var surveillances = snapshot.data!;
                                return ListView.separated(
                                  itemCount: surveillances.length,
                                  separatorBuilder: (BuildContext context, int index) =>
                                      SizedBox(height: 16), // Spacing of 16 pixels between each item
                                  itemBuilder: (BuildContext context, int index) {
                                    var surveillance = surveillances[index];
                                    return InkWell(
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            height: 136,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(22),
                                              color: Colors.blueAccent,
                                              boxShadow: [kDefaultShadow],
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: SizedBox(
                                              height: 136,
                                              width: size.width - 100,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          surveillance.surveillant,
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        SizedBox(width: 8),
                                                        // Text(
                                                        //   surveillance.surveillant_id.toString(),
                                                        //   style: Theme.of(context).textTheme.button,
                                                        // ),
                                                        // SizedBox(width: 8),
                                                        // Text(
                                                        //   surveillance.salle_id.toString(),
                                                        //   style: Theme.of(context).textTheme.button,
                                                        // ),
                                                        // SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => MasterPage(accessToken:widget.accessToken,
                                                                  index: 0,
                                                                  child:
                                                                  SurveillanceForm(
                                                                    surveillance: surveillance, accessToken: widget.accessToken,
                                                                  ),),

                                                              ),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.blueAccent,
                                                            size: 24.0,
                                                            semanticLabel: 'Edit',
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Alert(
                                                              context: context,
                                                              type: AlertType.warning,
                                                              title: "Confirmation",
                                                              desc: "Are you sure you want to delete this item?",
                                                              buttons: [
                                                                DialogButton(
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                                                  ),
                                                                  onPressed: () {
                                                                    print("Cancel button clicked");
                                                                    Navigator.pop(context);
                                                                  },
                                                                  color: Colors.red,
                                                                  radius: BorderRadius.circular(20.0),
                                                                ),
                                                                DialogButton(
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                                                  ),
                                                                  onPressed: () async {
                                                                    await delete(surveillance.id.toString());
                                                                    setState(() {});
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => MasterPage(
                                                                          child: ListSurveillance(accessToken: widget.accessToken, nomDep: widget.nomDep, nomNiv: widget.nomNiv,),accessToken: widget.accessToken,index: 0,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  color: Colors.blueAccent,
                                                                  radius: BorderRadius.circular(20.0),
                                                                ),
                                                              ],
                                                            ).show();
                                                          },

                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 24.0,
                                                            semanticLabel: 'Delete',
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: kDefaultPadding * 1.5,
                                                      vertical: kDefaultPadding / 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blueAccent,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(22),
                                                        topRight: Radius.circular(22),
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.remove_red_eye_outlined,
                                                        size: 30, // Taille de l'icône
                                                        color: Colors.white, // Couleur de l'icône
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => MasterPage(
                                                              index: 0,  accessToken: widget.accessToken,
                                                              child:
                                                              ViewSurveillance(  accessToken: widget.accessToken, id:surveillance.id,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // ),
      );
  }
}

// const double kDefaultPadding = 20.0;

Widget _head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,

            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
      Positioned(
        top: 10,
        left: 37    ,
        child: Container(
          height: 140,
          width: 340,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total des Surveillants',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '65',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      )
    ],
  );
}

