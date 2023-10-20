import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import 'package:pfe_front_flutter/screens/views/viewmatiere.dart';
import '../../../constants.dart';
import '../../bar/masterpageadmin2.dart';
import '../../consturl.dart';
import '../../models/matiere.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class MatiereHome extends StatefulWidget {
  final String accessToken;
final String nom;
  MatiereHome({Key? key, required this.accessToken, required this.nom}) : super(key: key);


  @override
  State<MatiereHome> createState() => _MatiereHomeState();
}

class _MatiereHomeState extends State<MatiereHome> {

  List<Matiere> matieresList = [];

  Future<List<Matiere>> fetchMatieres(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/matieres/$nom'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Matiere> matieres = [];

      for (var matiere in jsonResponse) {
        matieres.add(Matiere(
          matiere['id'],
          matiere['libelle'],
          matiere['nbr_heure'],
          matiere['credit'],
          matiere['filiere'],
        ));
      }

      return matieres;
    } else {
      throw Exception('Failed to load data from API');
    }
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
    fetchMatieres(widget.nom).then((matieres) {
      setState(() {
        this.matieresList = matieres;
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
                            'Matieres',
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
                                  AddMatiereForm(matiere: Matiere(0, '',0,0,'',),  accessToken: widget.accessToken, nom: widget.nom,
                                  ),
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
                          child: FutureBuilder<List<Matiere>>(
                            future: fetchMatieres(widget.nom),
                            builder: (BuildContext context, AsyncSnapshot<List<Matiere>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                var matieres = snapshot.data!;
                                return ListView.separated(
                                  itemCount: matieres.length,
                                  separatorBuilder: (BuildContext context, int index) =>
                                      SizedBox(height: 16), // Spacing of 16 pixels between each item
                                  itemBuilder: (BuildContext context, int index) {
                                    var matiere = matieres[index];
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
                                                          matiere.libelle,
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
                                                                    AddMatiereForm(
                                                                  matiere: matiere,  accessToken: widget.accessToken, nom: widget.nom,

                                                                    ),
                                                              ),),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.blueAccent,
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
                                                                    await delete(matiere.id.toString());
                                                                    setState(() {});
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => MasterPage(
                                                                          index: 0,  accessToken: widget.accessToken,

                                                                            child: MatiereHome(  accessToken: widget.accessToken, nom: widget.nom,
                                                                        ),
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
                                                              ViewMatiere(  accessToken: widget.accessToken, id: matiere.id,
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

            ],
          ),
        ),
      )
    ],
  );
}
