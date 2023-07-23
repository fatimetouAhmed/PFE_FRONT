import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';

import '../../models/semestre.dart';


class SemestreForm extends StatefulWidget {
  final Semestre semestre;

  SemestreForm({Key? key, required this.semestre}) : super(key: key);

  @override
  _SemestreFormState createState() => _SemestreFormState();
}

class _SemestreFormState extends State<SemestreForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nomController =new  TextEditingController();
  TextEditingController id_filController = new TextEditingController();

  String? selectedOption;
  List<String> semestreList = [];
  int? fetchedId;

  @override
  void initState() {
    super.initState();
    fetchFilieres().then((_) {
      setState(() {
        idController.text = this.widget.semestre.id.toString();
        nomController.text = this.widget.semestre.nom;
        id_filController.text = this.widget.semestre.id_fil.toString();
      });
    });
  }

  Future<List<Semestre>> fetchSemestres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/semestres/semestre_filiere/'));
    var semestres = <Semestre>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var nom = u['nom'];
      var id_fil = u['id_fil'];
      var filiere = u['filiere'];

      if (id != null && nom != null &&  id_fil != null && filiere != null) {
        semestres.add(Semestre(id, nom, id_fil, filiere));
      } else {
        print('Incomplete data for Semestre object');
      }
    }

    return semestres;
  }

  Future<void> fetchFilieres() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/nomfiliere/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var filiere in data) {
        semestreList.add(filiere['nom'] as String);
      }
    }
    print(semestreList);
  }

  Future<int?> fetchFilieresId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/semestres/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
    //  print(jsonData);
      return jsonData;
    }

    return null;
  }

  Future<void> save(Semestre semestre) async {
    if (semestre.id == 0) {
      await http.post(
        Uri.parse('http://127.0.0.1:8000/semestres/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': semestre.nom,
          'id_fil': semestre.id_fil.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/semestres/' + semestre.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': semestre.nom,
          'id_fil': semestre.id_fil.toString(),
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
                        child: DropdownButtonFormField<String>(
                          // print(selectedOption),
                          value: selectedOption,
                          items: semestreList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption = newValue;
                            print(selectedOption);
                            if (selectedOption != null) {
                              int? id = await fetchFilieresId(selectedOption!);
                              id_filController.text = id.toString();

                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Filiere',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: id_filController,
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
                          int? idFil = int.tryParse(id_filController.text);

                          if (id != null && idFil != null) {
                            await save(
                              Semestre(
                                id,
                                nomController.text,
                                idFil,
                                '',
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>MasterPage(child:  ListSemestre(),)
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
