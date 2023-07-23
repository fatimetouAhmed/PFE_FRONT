import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import '../../models/examun.dart';
import '../../models/filliere.dart';
import '../../models/semestre_etudiant.dart';
import '../../models/surveillance.dart';
import '../lists/listexamun.dart';
import '../lists/listfiliere.dart';
import '../lists/listsemestre_etudiant.dart';
import 'package:intl/intl.dart';
class SurveillanceForm extends StatefulWidget {
  final Surveillance surveillance;

  SurveillanceForm({Key? key, required this.surveillance}) : super(key: key);

  @override
  _SurveillanceFormState createState() => _SurveillanceFormState();
}

class _SurveillanceFormState extends State<SurveillanceForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController date_debController = new TextEditingController();
  TextEditingController date_finController =new TextEditingController();
  TextEditingController surveillant_idController = new TextEditingController();
  TextEditingController salle_idController = new TextEditingController();
  String? selectedOption1;
  String? selectedOption2;
  List<String> surveillantList = [];
  List<String> salleList = [];

  @override
  void initState() {
    super.initState();
    fetchSurveillances().then((_) {
      setState(() {
        idController.text = this.widget.surveillance.id.toString();
        date_debController.text = this.widget.surveillance.date_debut.toString();
        date_finController.text = this.widget.surveillance.date_fin.toString();
        surveillant_idController.text = this.widget.surveillance.surveillant_id.toString();
        salle_idController.text = this.widget.surveillance.salle_id.toString();
      });
    });
    fetchSalles().then((_) {
      setState(() {
        idController.text = this.widget.surveillance.id.toString();
        date_debController.text = this.widget.surveillance.date_debut.toString();
        date_finController.text = this.widget.surveillance.date_fin.toString();
        surveillant_idController.text = this.widget.surveillance.surveillant_id.toString();
        salle_idController.text = this.widget.surveillance.salle_id.toString();
      });
    });
  }

  Future<List<Surveillance>> fetchSurveillances() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/surveillances/surveillance/'));

    if (response.statusCode != 200) {
      // Handle the error when the API request is not successful (e.g., status code is not 200 OK).
      throw Exception('Failed to fetch surveillances.');
    }

    var jsonList = jsonDecode(response.body);

    if (jsonList is List) {
      var surveillances = <Surveillance>[];
      for (var u in jsonList) {
        var DateDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_debut']);
        var DateFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_fin']);
        surveillances.add(Surveillance(u['id'], DateDeb, DateFin, u['surveillant_id'], u['salle_id']));
      }
      return surveillances;
    } else {
      // Handle the case when the JSON response is not a list.
      throw Exception('Invalid JSON format: Expected a list of surveillances.');
    }
  }

  Future<void> fetchNomSurveillances() async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/surveillances/surveillances/nom'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var surveillance in data) {
        surveillantList.add(surveillance['prenom'] as String);
      }
    }
    print(surveillantList);
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
  Future<int?> fetchSurveillanceId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/surveillances/surveillances/$nom'));

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
  Future<void> save(Surveillance surveillance) async {
    if (surveillance.id == 0) {

      await http.post(
        Uri.parse('http://127.0.0.1:8000/surveillances/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'date_deb': surveillance.date_debut.toIso8601String(),
          'date_fin': surveillance.date_fin.toIso8601String(),
          'surveillant_id': surveillance.surveillant_id.toString(),
          'salle_id': surveillance.salle_id.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://127.0.0.1:8000/surveillances/' + surveillance.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'date_deb': surveillance.date_debut.toIso8601String(),
          'date_fin': surveillance.date_fin.toIso8601String(),
          'surveillant_id': surveillance.surveillant_id.toString(),
          'salle_id': surveillance.salle_id.toString(),
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
                          items: surveillantList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption1 = newValue;
                            //  print(selectedOption1);
                            if (selectedOption1 != null) {
                              int? id = await fetchSurveillanceId(selectedOption1!);
                              surveillant_idController.text = id.toString();
                              print(surveillant_idController.text);
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Surveillaces',
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
                              salle_idController.text = id.toString();
                              print(salle_idController.text);
                              print("Salle");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Salles',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: surveillant_idController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: salle_idController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          controller: date_finController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date fn" //label text of field
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
                                date_debController.text = formattedDate; //set output date to TextField value.
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
                          controller: date_finController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date fin" //label text of field
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
                                date_finController.text = formattedDate; //set output date to TextField value.
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
                          int? idSur = int.tryParse(surveillant_idController.text);
                          int? idSal = int.tryParse(salle_idController.text);

                          if (id != null && idSur != null && idSal != null) {
                            await save(
                             Surveillance(
                                id,
                                DateTime.parse(date_debController.text),
                                DateTime.parse(date_finController.text),
                                idSur,
                                idSal,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>MasterPageSupeurviseur(child:  ListSurveillance(),)
                              ),
                            );

                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Invalid ID or Surveillance ID or Salle ID"),
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
