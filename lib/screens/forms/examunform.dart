import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpage.dart';
import '../../models/examun.dart';
import '../../models/filliere.dart';
import '../../models/semestre_etudiant.dart';
import '../lists/listexamun.dart';
import '../lists/listfiliere.dart';
import '../lists/listsemestre_etudiant.dart';
import 'package:intl/intl.dart';
class ExamunForm extends StatefulWidget {
  final Examun examun;

  ExamunForm({Key? key, required this.examun}) : super(key: key);

  @override
  _ExamunFormState createState() => _ExamunFormState();
}

class _ExamunFormState extends State<ExamunForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController heure_debController =new TextEditingController();
  TextEditingController heure_finController = new TextEditingController();
  TextEditingController id_matController = new TextEditingController();
  TextEditingController id_salController = new TextEditingController();
  String? selectedOption1;
  String? selectedOption2;
  List<String> matiereList = [];
  List<String> salleList = [];

  @override
  void initState() {
    super.initState();
    fetchMatieres().then((_) {
      setState(() {
        idController.text = this.widget.examun.id.toString();
        typeController.text = this.widget.examun.type.toString();
        heure_debController.text = this.widget.examun.heure_deb.toString();
        heure_finController.text = this.widget.examun.heure_fin.toString();
        id_salController.text = this.widget.examun.id_sal.toString();
      });
    });
    fetchSalles().then((_) {
      setState(() {
        idController.text = this.widget.examun.id.toString();
        typeController.text = this.widget.examun.type.toString();
        heure_debController.text = this.widget.examun.heure_deb.toString();
        heure_finController.text = this.widget.examun.heure_fin.toString();
        id_salController.text = this.widget.examun.id_sal.toString();
      });
    });
  }

  Future<List<Examun>> fetchSemestre_Etudians() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/'));
    var examuns = <Examun>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var type= u['id'];
      var heure_deb= u['heure_deb'];
      var heure_fin = u['heure_fin'];
      var id_mat = u['id_mat'];
      var id_sal = u['id_sal'];

      if (id != null && type!= null && heure_deb!= null && heure_fin!= null && id_mat != null && id_sal!= null ) {
        examuns.add(Examun(id,type,heure_deb,heure_fin, id_mat, id_sal));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return examuns;
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
  Future<void> fetchSalles() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/salles/nom/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        salleList.add(salle['nom'] as String);
      }
    }
    print(salleList);
  }
  Future<int?> fetchMatieresId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/matiere/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchSallesId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/salle/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(Examun examun) async {
    if (examun.id == 0) {

      await http.post(
        Uri.parse('http://127.0.0.1:8000/examuns/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'type': examun.type,
          'heure_deb': examun.heure_deb.toIso8601String(),
          'heure_fin': examun.heure_fin.toIso8601String(),
          'id_mat': examun.id_mat.toString(),
          'id_sal': examun.id_sal.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/examuns/' + examun.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'type': examun.type,
          'heure_deb': examun.heure_deb.toIso8601String(),
          'heure_fin': examun.heure_fin.toIso8601String(),
          'id_mat': examun.id_mat.toString(),
          'id_sal': examun.id_sal.toString(),
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
                              int? id = await fetchMatieresId(selectedOption1!);
                              id_matController.text = id.toString();
                              print(id_matController.text);
                              print("matieres");
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
                          items: salleList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption2 = newValue;
                            // print(selectedOption2);
                            if (selectedOption2 != null) {
                              int? id = await fetchSallesId(selectedOption2!);
                              id_salController.text = id.toString();
                              print(id_salController.text);
                              print("Salle");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Salle',
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
                          controller: id_salController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter Description'),
                          controller: typeController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          controller: heure_debController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date" //label text of field
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                heure_debController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                        ),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'Enter Description'),
                        //   controller: heure_debController,
                        // ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextField(
                          controller: heure_finController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date" //label text of field
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                heure_finController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
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
                          int? idMat = int.tryParse(id_matController.text);
                          int? idSal = int.tryParse(id_salController.text);

                          if (id != null && idMat != null && idSal != null) {
                            await save(
                              Examun(
                                id,
                                typeController.text,
                                DateTime.parse(heure_debController.text),
                                DateTime.parse(heure_finController.text),
                                idMat,
                                idSal,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>MasterPage(child:  ListExamun(),)
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
