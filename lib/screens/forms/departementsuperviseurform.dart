import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
import 'package:quickalert/quickalert.dart';
import '../../consturl.dart';
import '../../models/departementssuperviseurs.dart';
import '../../models/semestre.dart';
import '../lists/listedepartementsuperviseur.dart';


class DepartementSuperviseurForm extends StatefulWidget {
  final DepartementsSuperviseurs departementsSuperviseurs;
  final String accessToken;


  DepartementSuperviseurForm({Key? key, required this.departementsSuperviseurs,required this.accessToken}) : super(key: key);

  @override
  _DepartementSuperviseurFormState createState() => _DepartementSuperviseurFormState();
}

class _DepartementSuperviseurFormState extends State<DepartementSuperviseurForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController id_depController = new TextEditingController();
  TextEditingController id_supController = new TextEditingController();
  TextEditingController date_debController =new TextEditingController();
  TextEditingController date_finController = new TextEditingController();

  FocusNode id_sup = FocusNode();
  FocusNode id_dep = FocusNode();
  FocusNode date_deb = FocusNode();
  FocusNode date_fin = FocusNode();
  String? selectedOption1;
  List<String> supeurviseurList = [];
  String? selectedOption2;
  List<String> departementList = [];
  int? fetchedId;

  int? fetchedId2;
  void initState() {
    super.initState();
    fetchSuperviseurs().then((_) {
      setState(() {
        idController.text = this.widget.departementsSuperviseurs.id.toString();
        id_supController.text = this.widget.departementsSuperviseurs.id_sup.toString();
        id_depController.text = this.widget.departementsSuperviseurs.id_dep.toString();
        date_debController.text = this.widget.departementsSuperviseurs.date_debut.toString();
        date_finController.text = this.widget.departementsSuperviseurs.date_fin.toString();
      });
    });
    fetchDepartements().then((_) {
      setState(() {
        idController.text = this.widget.departementsSuperviseurs.id.toString();
        id_supController.text = this.widget.departementsSuperviseurs.id_sup.toString();
        id_depController.text = this.widget.departementsSuperviseurs.id_dep.toString();
        date_debController.text = this.widget.departementsSuperviseurs.date_debut.toString();
        date_finController.text = this.widget.departementsSuperviseurs.date_fin.toString();
      });
    });
  }

  Future<List<DepartementsSuperviseurs>> fetchSemestres() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'departementssuperviseurs/read_data/'),headers: headers);
    var departementsuperviseurs = <DepartementsSuperviseurs>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_sup = u['id_sup'];
      var superviseur = u['superviseur'];
      var id_dep = u['id_dep'];
      var departement = u['departement'];
      var date_deb= u['date_deb'];
      var date_fin = u['date_fin'];
      if (id != null &&   id_sup != null &&   id_dep != null && date_deb != null && date_fin != null && superviseur != null&& departement != null) {
        departementsuperviseurs.add(DepartementsSuperviseurs(id, id_sup,id_dep,date_deb,date_fin, superviseur,departement));
      } else {
        print('Incomplete data for Semestre object');
      }
    }

    return departementsuperviseurs;
  }
  Future<void> fetchDepartements() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'departements/nomdepartement'),headers: headers);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var filiere in data) {
        departementList.add(filiere['nom'] as String);
      }
    }
  }
  Future<int?> fetchDepartementsId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'departementssuperviseurs/departement/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      //  print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> fetchSuperviseurs() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'nomsuperviseur/'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var filiere in data) {
        supeurviseurList.add(filiere['nom'] as String);
      }
    }
  }
  Future<int?> fetchSuperviseursId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'id_superviseur/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      //  print(jsonData);
      return jsonData;
    }

    return null;
  }

  Future<void> save(DepartementsSuperviseurs departementsuperviseur) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
      'Content-Type': 'application/json;charset=UTF-8',

    };
    if (departementsuperviseur.id == 0) {
      await http.post(
        Uri.parse(baseUrl+'departementssuperviseurs/'),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'id_sup': departementsuperviseur.id_sup.toString(),
          'id_dep': departementsuperviseur.id_dep.toString(),
          'date_debut': departementsuperviseur.date_debut.toIso8601String(),
          'date_fin': departementsuperviseur.date_fin.toIso8601String(),
        }),
      );
    } else {
      await http.put(
        Uri.parse(baseUrl+'departementssuperviseurs/' + departementsuperviseur.id.toString()),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'id_sup': departementsuperviseur.id_sup.toString(),
          'id_dep': departementsuperviseur.id_dep.toString(),
          'date_debut': departementsuperviseur.date_debut.toIso8601String(),
          'date_fin': departementsuperviseur.date_fin.toIso8601String(),
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
                height: 400,
                width: 370,
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
                                int? id = await fetchSuperviseursId(selectedOption1!);
                                print(id);
                                id_supController.text = id.toString();
                              }
                            },
                            items: supeurviseurList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => supeurviseurList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Superviseur',
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
                                int? id = await fetchDepartementsId(selectedOption2!);
                                print(id);
                                id_depController.text = id.toString();
                              }
                            },
                            items: departementList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => departementList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Departement',
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: date_deb,
                          controller: date_debController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'Date_deb',
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
                                date_debController.text = formattedDate; //set output date to TextField value.
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
                          focusNode: date_fin,
                          controller: date_finController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'date_fin',
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
                                date_finController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
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
                              int? idDep = int.tryParse(id_depController.text);
                              int? idSup = int.tryParse(id_supController.text);
                              if (id != null  && idDep != null&& idSup != null) {
                                await save(
                                  DepartementsSuperviseurs(
                                    id,
                                    idSup,
                                    idDep,
                                    '',
                                    '',
                                    DateTime.parse(date_debController.text),
                                    DateTime.parse(date_finController.text),
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  ListDepartementSuperviseur(  accessToken: widget.accessToken
                                        ),)
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
