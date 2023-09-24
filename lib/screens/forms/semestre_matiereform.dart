import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/semestre_etudiant.dart';
import '../../models/semestresmatieres.dart';
import '../lists/listesemestre_matiere.dart';
import '../lists/listsemestre_etudiant.dart';
import 'package:quickalert/quickalert.dart';
class Semestre_MatiereForm extends StatefulWidget {
  final SemestresMatieres semestre_matiere;
  final String accessToken;


  Semestre_MatiereForm({Key? key, required this.semestre_matiere,required this.accessToken}) : super(key: key);

  @override
  _Semestre_MatiereFormState createState() => _Semestre_MatiereFormState();
}

class _Semestre_MatiereFormState extends State<Semestre_MatiereForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController id_semController =new  TextEditingController();
  TextEditingController id_matController =new TextEditingController();
  FocusNode id_sem = FocusNode();
  FocusNode id_mat = FocusNode();
  String? selectedOption1;
  String? selectedOption2;
  List<String> matiereList = [];
  List<String> semestreList = [];

  @override
  void initState() {
    super.initState();
    fetchEtudiants().then((_) {
      setState(() {
        idController.text = this.widget.semestre_matiere.id.toString();
        id_semController.text = this.widget.semestre_matiere.id_sum.toString();
        id_matController.text = this.widget.semestre_matiere.id_mat.toString();
      });
    });
    fetchSemestres().then((_) {
      setState(() {
        idController.text = this.widget.semestre_matiere.id.toString();
        id_semController.text = this.widget.semestre_matiere.id_sum.toString();
        id_matController.text = this.widget.semestre_matiere.id_mat.toString();
      });
    });
  }
  Future<List<SemestresMatieres>> fetchSemestre_Matieres() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestresmatieres/read'),headers: headers);
    var semestre_matieres = <SemestresMatieres>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_sem = u['id_sem'];
      var id_mat = u['id_mat'];
      var matiere = u['matiere_libelle'];
      var semestre = u['semestre'];

      if (id != null && id_sem != null && id_mat!= null && matiere != null && semestre != null) {
        semestre_matieres.add(SemestresMatieres(id, id_sem, id_mat,matiere,semestre));
      }
      // else {
      //   print('Incomplete data for Semestre Matiere object');
      // }
    }
    return semestre_matieres;
  }

  Future<void> fetchEtudiants() async {
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
  Future<void> fetchSemestres() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestres/'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var semestre in data) {
        semestreList.add(semestre['nom'] as String);
      }
    }
    print(semestreList);
  }
  Future<int?> fetchSemestresId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'semestre_etudiants/semestre/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      //print(jsonData);
      return jsonData;
    }

    return null;
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
  Future<void> save(SemestresMatieres semestre_matiere) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
      'Content-Type': 'application/json;charset=UTF-8',

    };
    if (semestre_matiere.id == 0) {
      await http.post(
        Uri.parse(baseUrl+'semestresmatieres/'),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'id_mat': semestre_matiere.id_mat.toString(),
          'id_sem': semestre_matiere.id_sum.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse(baseUrl+'semestresmatieres/' + semestre_matiere.id.toString()),
        headers: headers,
        body: jsonEncode(<String, dynamic>{

          'id_mat': semestre_matiere.id_mat.toString(),
          'id_sem': semestre_matiere.id_sum.toString(),
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
                height: 300,
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
                                int? id = await fetchSemestresId(selectedOption2!);
                                print(id);
                                id_semController.text = id.toString();
                              }
                            },
                            items: semestreList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => semestreList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Semestre',
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
                              int? idSem = int.tryParse(id_semController.text);
                              int? idEtu = int.tryParse(id_matController.text);

                              if (id != null && idSem != null && idEtu != null) {
                                await save(
                                  SemestresMatieres(
                                    id,
                                    idSem,
                                    idEtu,
                                    '',
                                    ''
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  ListSemestre_Matiere(  accessToken: widget.accessToken
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