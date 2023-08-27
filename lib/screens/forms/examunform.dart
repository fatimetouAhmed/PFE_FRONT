import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/examun.dart';
import 'package:quickalert/quickalert.dart';
import '../lists/listexamun.dart';
import 'package:intl/intl.dart';
class ExamunForm extends StatefulWidget {
  final Examun examun;
  final String accessToken;


  ExamunForm({Key? key, required this.examun,required this.accessToken}) : super(key: key);

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
  FocusNode type = FocusNode();
  FocusNode id_mat = FocusNode();
  FocusNode heure_deb = FocusNode();
  FocusNode heure_fin = FocusNode();
  FocusNode id_sal = FocusNode();
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
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'examuns/'),headers: headers);
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

    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'matieres/nom/'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var matiere in data) {
        matiereList.add(matiere['libelle'] as String);
      }
    }
    print(matiereList);
  }
  Future<void> fetchSalles() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'salles/nom/'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        salleList.add(salle['nom'] as String);
      }
    }
    print(salleList);
  }
  Future<int?> fetchMatieresId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'examuns/matiere/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchSallesId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'examuns/salle/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(Examun examun) async {

    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
      'Content-Type': 'application/json;charset=UTF-8',

    };
    if (examun.id == 0) {

      await http.post(
        Uri.parse(baseUrl+'examuns/'),
        headers: headers,
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
        Uri.parse(baseUrl+'examuns/' + examun.id.toString()),
        headers: headers,
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
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [

            background_container(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 560,
                width: 340,
                child: Form(
                  child: Column(
                    children: [
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Entrez id'),
                          controller: idController,
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          focusNode: type,
                          controller: typeController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'type',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blue,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: heure_deb,
                          controller: heure_debController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'heure_deb',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blue,)),
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
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: heure_fin,
                          controller: heure_finController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'heure_fin',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blue,)),
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
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption1,
                            onChanged: (String? newValue) async {
                              print(selectedOption1);
                              setState(() {
                                selectedOption1 = newValue!;
                              });

                              if (selectedOption1 != null) {
                                int? id = await fetchMatieresId(selectedOption1!);
                                print(id);
                                id_matController.text = id.toString();
                              }
                            },
                            items: matiereList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => matiereList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Matiere',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption2,
                            onChanged: (String? newValue) async {
                              print(selectedOption2);
                              setState(() {
                                selectedOption2 = newValue!;
                              });

                              if (selectedOption2 != null) {
                                int? id = await fetchSallesId(selectedOption2!);
                                print(id);
                                id_salController.text = id.toString();
                              }
                            },
                            items: salleList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => salleList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Salle',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),
                          ),
                        ),
                      ),

                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Operation Completed Successfully!',
                            confirmBtnColor: Colors.blue,
                          ).then((value) async {
                            if (value == null) {
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
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  ListExamun(  accessToken: widget.accessToken
                                        ),)
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
                            }
                          });
                        },

                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                          width: 120,
                          height: 50,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'f',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(
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
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                child:   Center(
                  child: Text(
                    'Adding',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  //   ),
                  //
                  // ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
