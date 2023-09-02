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
import '../../models/matiere.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType class

import '../forms/etudiantform.dart';
class EtudiantHome extends StatefulWidget {
  final String accessToken;

  EtudiantHome({Key? key, required this.accessToken}) : super(key: key);


  @override
  State<EtudiantHome> createState() => _EtudiantHomeState();
}

class _EtudiantHomeState extends State<EtudiantHome> {

  List<Etudiant> etudiantsList = [];

  Future<List<Etudiant>> fetchEtudiants() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'etudiants/'),headers: headers);
    var etudiants = <Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

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
      etudiants.add(Etudiant(id, nom, prenom,photo,genre, date_N,lieu_n,email,telephone,nationalite,date_insecription));
    }
    return etudiants;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'matieres/' + id),headers: headers);
  }
  @override
  void initState() {
    super.initState();
    fetchEtudiants().then((matieres) {
      setState(() {
        this.etudiantsList = matieres;
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
              child: SizedBox(height: 340, child: _head()),
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
                            'Etudiants',
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
                                          index: 0,  accessToken: widget.accessToken,

                                          child:
                                          EtudiantForm(id: 0, nom: '', prenom: '', photo: '', genre: '', date_N:DateTime.parse('0000-00-00 00:00:00'), lieu_n: '', email: '', telephone: 0, nationalite: '', date_insecription:DateTime.parse('0000-00-00 00:00:00'), accessToken: widget.accessToken,)
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
                          child: FutureBuilder<List<Etudiant>>(
                            future: fetchEtudiants(),
                            builder: (BuildContext context, AsyncSnapshot<List<Etudiant>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                var etudiants = snapshot.data!;
                                return ListView.separated(
                                  itemCount: etudiants.length,
                                  separatorBuilder: (BuildContext context, int index) =>
                                      SizedBox(height: 16), // Spacing of 16 pixels between each item
                                  itemBuilder: (BuildContext context, int index) {
                                    var etudiant = etudiants[index];
                                    return InkWell(
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            height: 136,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(22),
                                              color: Colors.blue,
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
                                              width: size.width - 200,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Avatar(
                                                          margin: EdgeInsets.only(right: 20),
                                                          size: 60,
                                                          image: 'images/etudiants/'+etudiant.photo,
                                                        ),
                                                        Text(
                                                          etudiant.nom,
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => MasterPage(
                                                                    index: 0,  accessToken: widget.accessToken
                                                                    ,
                                                                    child:
                                                                    EtudiantForm(
                                                                      id: etudiant.id,
                                                                      nom: etudiant.nom,
                                                                      prenom: etudiant.prenom,
                                                                      photo: etudiant.photo,
                                                                      genre: etudiant.genre,
                                                                      date_N: etudiant.date_N,
                                                                      lieu_n: etudiant.lieu_n,
                                                                      email: etudiant.email,
                                                                      telephone: etudiant.telephone,
                                                                      nationalite: etudiant.nationalite,
                                                                      date_insecription: etudiant.date_insecription,
                                                                      accessToken: widget.accessToken,
                                                                    )

                                                                ),),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                            size: 24.0,
                                                            semanticLabel: 'Edit',
                                                          ),
                                                        ),
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
                                                                    await delete(etudiant.id.toString());
                                                                    setState(() {});
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => MasterPage(
                                                                          index: 0,  accessToken: widget.accessToken,

                                                                          child: EtudiantHome(  accessToken: widget.accessToken
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  color: Colors.blue,
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
                                                      color: Colors.blue,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(22),
                                                        topRight: Radius.circular(22),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      etudiant.id.toString(),
                                                      style: Theme.of(context).textTheme.button,
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
            height: 240,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 340,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Color.fromRGBO(250, 250, 250, 0.1),
                      child: Icon(
                        Icons.notification_add_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestion des Matieres',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 140,
        left: 37,
        child: Container(
          height: 170,
          width: 320,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total des Matieres',
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
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '50',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}