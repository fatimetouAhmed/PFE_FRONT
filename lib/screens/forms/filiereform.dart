import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../models/filliere.dart';
import '../lists/listfiliere.dart';
import 'package:quickalert/quickalert.dart';
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
  FocusNode nom = FocusNode();
  FocusNode description = FocusNode();

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
      Set<String> uniqueDepartments = {}; // Using a Set to ensure unique values
      for (var department in data) {
        uniqueDepartments.add(department['nom'] as String);
      }
      departmentList = uniqueDepartments.toList(); // Convert back to a list
    }
    print(departmentList);
  }


  Future<int?> fetchDepartementsId(String nom) async {
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/$nom'));

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
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
    return   Scaffold(
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
                height: 360,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            focusNode: description,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              labelText: 'description',
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
                                int? id = await fetchDepartementsId(selectedOption!);
                                print(id);
                                id_depController.text = id.toString();
                              }
                            },
                            items: departmentList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => departmentList.map((e) => Text(e)).toList(),
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
