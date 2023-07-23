import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../models/matiere.dart';

class MatiereHome extends StatefulWidget {
  MatiereHome({Key? key}) : super(key: key);

  @override
  State<MatiereHome> createState() => _MatiereHomeState();
}

class _MatiereHomeState extends State<MatiereHome> {
  List<Matiere> matieresList = [];

  Future<List<Matiere>> fetchMatieres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/matieres/'));
    var matieres = <Matiere>[];
    for (var u in jsonDecode(response.body)) {
      matieres.add(Matiere(u['id'], u['libelle'],u['nbre_heure'],u['credit']));
    }
    print(matieres);
    return matieres;
  }

  Future delete(id) async {
    await http.delete(Uri.parse('http://127.0.0.1:8000/matieres/' + id));
  }

  // List<Matiere> matieres = []; // Liste des départements
  // Future fetchMatieres() async {
  //
  //   var response = await http.get(Uri.parse('http://127.0.0.1:8000/matieres/'));
  //   var matieres = <Matiere>[];
  //   for (var u in jsonDecode(response.body)) {
  //     print('Parsed JSON object: $u');
  //     matieres.add(Matiere(u['id'], u['libelle'],u['nbre_heure'],u['credit']));
  //   }
  //   print(matieres);
  //   return matieres;
  // }
  @override
  void initState() {
    super.initState();

    // Charger les départements lors de l'initialisation du widget
    fetchMatieres().then((matieres) {
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
                                  child:
                                  AddMatiereForm(matiere: Matiere(0, '',0,0)),
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
                            future: fetchMatieres(),
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
                                                        Text(
                                                          matiere.libelle,
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          matiere.nbre_heure.toString(),
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          matiere.credit.toString(),
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => MasterPage(child:
                                                                    AddMatiereForm(
                                                                  matiere: matiere,
                                                                ),
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
                                                            bool confirmed = await showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Confirmation"),
                                                                  content: Text("Are you sure you want to delete this item?"),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text("No"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop(false);
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text("Yes"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop(true);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );

                                                            if (confirmed != null && confirmed) {
                                                              await delete(matiere.id.toString());
                                                              setState(() {});
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => MasterPage(
                                                                    child: MatiereHome(),
                                                                  ),
                                                                ),
                                                              );
                                                            }
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
                                                      matiere.id.toString(),
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
