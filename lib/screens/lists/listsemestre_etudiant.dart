import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/forms/semestre_etudiant.dart';
import '../../../constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/semestre_etudiant.dart';

class ListSemestre_Etudiant extends StatefulWidget {
  final String accessToken;

  ListSemestre_Etudiant({Key? key,required this.accessToken}) : super(key: key);

  @override
  _ListSemestre_EtudiantState createState() => _ListSemestre_EtudiantState();
}

class _ListSemestre_EtudiantState extends State<ListSemestre_Etudiant> {
  List<Semestre_Etudiant> semestre_etudiantsList = [];

  Future<List<Semestre_Etudiant>> fetchSemestre_Etudiants() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestre_etudiants/'),headers: headers);
    var semestre_etudiants = <Semestre_Etudiant>[];
    for (var u in jsonDecode(response.body)) {
      semestre_etudiants.add(Semestre_Etudiant(u['id'], u['id_sem'], u['id_etu']));
    }
   // print(semestre_etudiants);
    return semestre_etudiants;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'semestre_etudiants/' + id),headers: headers);
  }

  @override
  void initState() {
    super.initState();
    fetchSemestre_Etudiants().then((semestre_etudiant) {
      setState(() {
        semestre_etudiantsList = semestre_etudiant;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return      SafeArea(
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
                          'SmestresEtudiants',
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
                                      index: 0,accessToken: widget.accessToken,
                                      child:
                                      Semestre_EtudiantForm(semestre_etudiant: Semestre_Etudiant(0,0,0),  accessToken: widget.accessToken
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
                    child:Scaffold(
                      body: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        child: FutureBuilder<List<Semestre_Etudiant>>(
                          future: fetchSemestre_Etudiants(),
                          builder: (BuildContext context, AsyncSnapshot<List<Semestre_Etudiant>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              var semestre_etudiants = snapshot.data!;
                              return ListView.separated(
                                itemCount: semestre_etudiants.length,
                                separatorBuilder: (BuildContext context, int index) =>
                                    SizedBox(height: 16), // Spacing of 16 pixels between each item
                                itemBuilder: (BuildContext context, int index) {
                                  var semestre_etudiant = semestre_etudiants[index];
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
                                                        semestre_etudiant.id_sem.toString(),
                                                        style: Theme.of(context).textTheme.button,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        semestre_etudiant.id_etu.toString(),
                                                        style: Theme.of(context).textTheme.button,
                                                      ),
                                                      SizedBox(width: 8),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => MasterPage(
                                                                index: 0,accessToken: widget.accessToken,
                                                                child:
                                                              Semestre_EtudiantForm(
                                                                semestre_etudiant: semestre_etudiant,  accessToken: widget.accessToken

                                                              ),),

                                                            ),
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
                                                                  await delete(semestre_etudiant.id.toString());
                                                                  setState(() {});
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => MasterPage(
                                                                        index: 0,accessToken: widget.accessToken,
                                                                        child: ListSemestre_Etudiant(accessToken: widget.accessToken),
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
                                                    semestre_etudiant.id.toString(),
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
                        'Gestion des SemestreEtudiants',
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
                      'Total des SemestreEtudiants',
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
