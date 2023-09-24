import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:quickalert/quickalert.dart';
import '../../consturl.dart';
import '../../models/etudiermat.dart';
import '../lists/listetudiermat.dart';


class EtudierMatForm extends StatefulWidget {
  final EtudierMat etudierMat;
  final String accessToken;

  EtudierMatForm({Key? key, required this.etudierMat,required this.accessToken}) : super(key: key);

  @override
  _EtudierMatFormState createState() => _EtudierMatFormState();
}

class _EtudierMatFormState extends State<EtudierMatForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController id_matController =new  TextEditingController();
  TextEditingController id_etuController =new TextEditingController();
  FocusNode id_mat = FocusNode();
  FocusNode id_etu = FocusNode();
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
    final headers = <String, String>{
      'Authorization': 'Bearer ${widget.accessToken}',
    };
    var response = await http.get(Uri.parse(baseUrl+'etudiermatiere/'),headers: headers);
    var etudiermats = <EtudierMat>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var id_mat = u['id_mat'];
      var id_etu = u['id_etu'];
      var etudiant = u['etudiant'];
      var matiere = u['matiere'];
      if (id != null && id_mat != null && id_etu!= null ) {
        etudiermats.add(EtudierMat(id,  id_etu,id_mat,etudiant,matiere));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return etudiermats;
  }

  Future<void> fetchEtudiants() async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${widget.accessToken}',
    };
    var response = await http.get(Uri.parse(baseUrl+'etudiants/nometudiant/'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var etudiant in data) {
        etudiantList.add(etudiant['nom'] as String);
      }
    }
    print(etudiantList);
  }
  Future<void> fetchMatieres() async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${widget.accessToken}',
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
  Future<int?> fetchMatiereId(String nom) async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${widget.accessToken}',
    };
    var response = await http.get(Uri.parse(baseUrl+'etudiermatiere/matiere/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      //print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchEtudiantsId(String nom) async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${widget.accessToken}',
    };
    var response = await http.get(Uri.parse(baseUrl+'semestre_etudiants/etudiant/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(EtudierMat etudierMat) async {
    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer ${widget.accessToken}',
    };
    if (etudierMat.id == 0) {
      await http.post(
        Uri.parse(baseUrl+'etudiermatiere/'),headers: headers,
        body: jsonEncode(<String, dynamic>{
          'id_etu': etudierMat.id_etu.toString(),
          'id_mat': etudierMat.id_mat.toString(),
        }),
      );
    } else {
      await http.put(
        Uri.parse(baseUrl+'etudiermatiere/' + etudierMat.id.toString()),headers: headers
        ,
        body: jsonEncode(<String, dynamic>{
          'id_etu': etudierMat.id_etu.toString(),
          'id_mat': etudierMat.id_mat.toString(),
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                                int? id = await fetchEtudiantsId(selectedOption1!);
                                print(id);
                                id_etuController.text = id.toString();
                              }
                            },
                            items: etudiantList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => etudiantList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Etudiant',
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
                                int? id = await fetchMatiereId(selectedOption2!);
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
                              int? idmat = int.tryParse(id_matController.text);
                              int? idEtu = int.tryParse(id_etuController.text);

                              if (id != null && idmat != null && idEtu != null) {
                                await save(
                                  EtudierMat(
                                    id,
                                    idmat,
                                    idEtu,
                                    '',
                                    ''
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  ListEtudierMat(  accessToken: widget.accessToken
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
