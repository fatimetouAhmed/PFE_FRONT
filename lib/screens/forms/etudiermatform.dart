import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpage.dart';

import '../../models/etudiermat.dart';
import '../lists/listetudiermat.dart';


class EtudierMatForm extends StatefulWidget {
  final EtudierMat etudierMat;

  EtudierMatForm({Key? key, required this.etudierMat}) : super(key: key);

  @override
  _EtudierMatFormState createState() => _EtudierMatFormState();
}

class _EtudierMatFormState extends State<EtudierMatForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController id_matController =new  TextEditingController();
  TextEditingController id_etuController =new TextEditingController();

  String? selectedOption1;
  String? selectedOption2;
  List<String> etudiantList = [];
  List<String> matiereList = [];

  @override
  void initState() {
    super.initState();
    fetchEtudiants().then((_) {
      setState(() {
        idController.text = this.widget.etudierMat.id.toString();
        id_matController.text = this.widget.etudierMat.id_mat.toString();
        id_etuController.text = this.widget.etudierMat.id_etu.toString();
      });
    });
    fetchMatieres().then((_) {
      setState(() {
        idController.text = this.widget.etudierMat.id.toString();
        id_matController.text = this.widget.etudierMat.id_mat.toString();
        id_etuController.text = this.widget.etudierMat.id_etu.toString();
      });
    });
  }

  Future<List<EtudierMat>> fetchEtudierMats() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/etudiermatiere/'));
    var etudiermats = <EtudierMat>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_mat = u['id_mat'];
      var id_etu = u['id_etu'];

      if (id != null && id_mat != null && id_etu!= null ) {
        etudiermats.add(EtudierMat(id,  id_etu,id_mat));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return etudiermats;
  }

  Future<void> fetchEtudiants() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/etudiants/nometudiant/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var etudiant in data) {
        etudiantList.add(etudiant['nom'] as String);
      }
    }
    print(etudiantList);
  }
  Future<void> fetchMatieres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/matieres/nom/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var matiere in data) {
        matiereList.add(matiere['libelle'] as String);
      }
    }
    print(matiereList);
  }
  Future<int?> fetchMatiereId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/etudiermatiere/matiere/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      //print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchEtudiantsId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/semestre_etudiants/etudiant/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(EtudierMat etudierMat) async {
    if (etudierMat.id == 0) {
      await http.post(
        Uri.parse('http://127.0.0.1:8000/etudiermatiere/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_etu': etudierMat.id_etu.toString(),
          'id_mat': etudierMat.id_mat.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/etudiermatiere/' + etudierMat.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_etu': etudierMat.id_etu.toString(),
          'id_mat': etudierMat.id_mat.toString(),
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Form(
                  child: Column(
                    children: [
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: idController,
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: DropdownButtonFormField<String>(
                          // print(selectedOption),
                          value: selectedOption1,
                          items: matiereList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption1 = newValue;
                            //  print(selectedOption1);
                            if (selectedOption1 != null) {
                              int? id = await fetchMatiereId(selectedOption1!);
                              id_matController.text = id.toString();
                              print(id_matController.text);
                              print("matiere");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Matiere',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: DropdownButtonFormField<String>(
                          // print(selectedOption),
                          value: selectedOption2,
                          items: etudiantList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption2 = newValue;
                            // print(selectedOption2);
                            if (selectedOption2 != null) {
                              int? idetu = await fetchEtudiantsId(selectedOption2!);
                              id_etuController.text = idetu.toString();
                              print(id_etuController.text);
                              print("etudiant");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Etudiant',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: id_matController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: id_etuController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text("Submit"),
                        onPressed: () async {
                          int? id = int.tryParse(idController.text);
                          int? idmat = int.tryParse(id_matController.text);
                          int? idEtu = int.tryParse(id_etuController.text);

                          if (id != null && idmat != null && idEtu != null) {
                            await save(
                              EtudierMat(
                                id,
                                idmat,
                                idEtu,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>MasterPage(child:  ListEtudierMat(),)
                              ),
                            );

                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Invalid ID or Etudiant ID or Semestre ID"),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
