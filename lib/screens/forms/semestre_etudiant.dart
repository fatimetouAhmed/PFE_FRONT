import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../models/filliere.dart';
import '../../models/semestre_etudiant.dart';
import '../lists/listfiliere.dart';
import '../lists/listsemestre_etudiant.dart';

class Semestre_EtudiantForm extends StatefulWidget {
  final Semestre_Etudiant semestre_etudiant;

  Semestre_EtudiantForm({Key? key, required this.semestre_etudiant}) : super(key: key);

  @override
  _Semestre_EtudiantFormState createState() => _Semestre_EtudiantFormState();
}

class _Semestre_EtudiantFormState extends State<Semestre_EtudiantForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController id_semController =new  TextEditingController();
  TextEditingController id_etuController =new TextEditingController();

  String? selectedOption1;
  String? selectedOption2;
  List<String> etudiantList = [];
  List<String> semestreList = [];

  @override
  void initState() {
    super.initState();
    fetchEtudiants().then((_) {
      setState(() {
        idController.text = this.widget.semestre_etudiant.id.toString();
        id_semController.text = this.widget.semestre_etudiant.id_sem.toString();
        id_etuController.text = this.widget.semestre_etudiant.id_etu.toString();
      });
    });
    fetchSemestres().then((_) {
      setState(() {
        idController.text = this.widget.semestre_etudiant.id.toString();
        id_semController.text = this.widget.semestre_etudiant.id_sem.toString();
        id_etuController.text = this.widget.semestre_etudiant.id_etu.toString();
      });
    });
  }

  Future<List<Semestre_Etudiant>> fetchSemestre_Etudians() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/semestre_etudiants/'));
    var semestre_etudiants = <Semestre_Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_sem = u['id_sem'];
      var id_etu = u['id_etu'];

      if (id != null && id_sem != null && id_etu!= null ) {
        semestre_etudiants.add(Semestre_Etudiant(id, id_sem, id_etu));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return semestre_etudiants;
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
  Future<void> fetchSemestres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/semestres/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var semestre in data) {
        semestreList.add(semestre['nom'] as String);
      }
    }
    print(semestreList);
  }
  Future<int?> fetchSemestresId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/semestre_etudiants/semestre/$nom'));

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
  Future<void> save(Semestre_Etudiant semestre_etudiant) async {
    if (semestre_etudiant.id == 0) {
      await http.post(
        Uri.parse('http://127.0.0.1:8000/semestre_etudiants/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_sem': semestre_etudiant.id_sem.toString(),
          'id_etu': semestre_etudiant.id_etu.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/semestre_etudiants/' + semestre_etudiant.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_sem': semestre_etudiant.id_sem.toString(),
          'id_etu': semestre_etudiant.id_etu.toString(),
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
                          items: semestreList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption1 = newValue;
                          //  print(selectedOption1);
                            if (selectedOption1 != null) {
                              int? id = await fetchSemestresId(selectedOption1!);
                              id_semController.text = id.toString();
                              print(id_semController.text);
                              print("semestre");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Semestre',
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
                          controller: id_semController,
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
                          int? idSem = int.tryParse(id_semController.text);
                          int? idEtu = int.tryParse(id_etuController.text);

                          if (id != null && idSem != null && idEtu != null) {
                            await save(
                              Semestre_Etudiant(
                                id,
                                idSem,
                                idEtu,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>MasterPage(child:  ListSemestre_Etudiant(),)
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
