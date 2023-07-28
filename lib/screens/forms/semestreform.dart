import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
import 'package:quickalert/quickalert.dart';
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
  FocusNode nom = FocusNode();
  FocusNode id_fil = FocusNode();
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          focusNode: nom,
                          controller: nomController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'nom',
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
                            value: selectedOption,
                            onChanged: (String? newValue) async {
                              print(selectedOption);
                              setState(() {
                                selectedOption = newValue!;
                              });

                              if (selectedOption != null) {
                                int? id = await fetchFilieresId(selectedOption!);
                                print(id);
                                id_filController.text = id.toString();
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
                                'filiere',
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
