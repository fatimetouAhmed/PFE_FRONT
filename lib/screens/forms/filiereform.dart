import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpage.dart';
import '../../models/filliere.dart';
import '../lists/listfiliere.dart';

class FiliereForm extends StatefulWidget {
  final Filiere filiere;

  FiliereForm({Key? key, required this.filiere}) : super(key: key);

  @override
  _FiliereFormState createState() => _FiliereFormState();
}

class _FiliereFormState extends State<FiliereForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController id_depController = new TextEditingController();

  String? selectedOption;
  List<String> departmentList = [];
  int? fetchedId;

  @override
  void initState() {
    super.initState();
    print(this.widget.filiere.nom);

    fetchDepartements().then((_) {
      setState(() {
        idController.text = this.widget.filiere.id.toString();
        nomController.text = this.widget.filiere.nom;
        descriptionController.text = this.widget.filiere.description;
        id_depController.text = this.widget.filiere.id_dep.toString();
      });
    });
  }

  Future<List<Filiere>> fetchFilieres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/filiere_departement/'));
    var filieres = <Filiere>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var nom = u['nom'];
      var description = u['description'];
      var id_dep = u['id_dep'];
      var departement = u['departement'];

      if (id != null && nom != null && description != null && id_dep != null && departement != null) {
        filieres.add(Filiere(id, nom, description, id_dep, departement));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

   // print(filieres);
    return filieres;
  }

  Future<void> fetchDepartements() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/departements/nomdepartement'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var department in data) {
        departmentList.add(department['nom'] as String);
      }
    }
    print(departmentList);
  }

  Future<int?> fetchDepartementsId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
     // print(jsonData); // Print the response body for debugging
     //
     //  if (jsonData != null && jsonData is Map) {
     //    if (jsonData.containsKey('id')) {
     //      int departementId = jsonData['id'] as int;
     //     // print(departementId);
     //      return departementId;
     //    }
     //  }
    }

    return null;
  }

  Future<void> save(Filiere filiere) async {
    if (filiere.id == 0) {
      await http.post(
        Uri.parse('http://127.0.0.1:8000/filieres/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': filiere.nom,
          'description': filiere.description,
          'id_dep': filiere.id_dep.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/filieres/' + filiere.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': filiere.nom,
          'description': filiere.description,
          'id_dep': filiere.id_dep.toString(),
        }),
      );
    }
  }
int? iddep=0;
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
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter Name'),
                          controller: nomController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter Description'),
                          controller: descriptionController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: DropdownButtonFormField<String>(
                         // print(selectedOption),
                          value: selectedOption,
                          items: departmentList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption = newValue;
                            print(selectedOption);
                            if (selectedOption != null) {
                              int? id = await fetchDepartementsId(selectedOption!);
                              id_depController.text = id.toString();

                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: id_depController,
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
                          int? idDep = int.tryParse(id_depController.text);

                          if (id != null && idDep != null) {
                            await save(
                              Filiere(
                                id,
                                nomController.text,
                                descriptionController.text,
                                idDep,
                                '',
                              ),
                            );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>MasterPage(child:  ListFiliere(),)
                                ),
                              );

                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Invalid ID or Department ID"),
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
