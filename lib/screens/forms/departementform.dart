import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/models/departement.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:quickalert/quickalert.dart';
import '../../bar/masterpageadmin.dart';

class DepartementForm extends StatefulWidget {
  final Departement departement;
  final String accessToken;

  DepartementForm({Key? key, required this.departement, required this.accessToken}) : super(key: key);

  @override
  _DepartementFormState createState() => _DepartementFormState();
}

class _DepartementFormState extends State<DepartementForm> {
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  FocusNode nom = FocusNode();

  @override
  void initState() {
    super.initState();
    idController.text = widget.departement.id.toString();
    nomController.text = widget.departement.nom;
  }

  Future<void> save(departement) async {
    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer ${widget.accessToken}',
    };

    if (departement.id == 0) {
      await http.post(
        Uri.parse('http://192.168.186.113:8000/departements/'),
        headers: headers,
        body: jsonEncode(<String, String>{
          'nom': departement.nom,
        }),
      );
    } else {
      await http.put(
        Uri.parse('http://192.168.186.113:8000/departements/' + departement.id.toString()),
        headers: headers,
        body: jsonEncode(<String, String>{
          'nom': departement.nom,
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
            SizedBox(height: 25),
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 200,
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
                          focusNode: nom,
                          controller: nomController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'nom',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
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
                              await save(
                                Departement(int.parse(idController.text), nomController.text),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MasterPage(
                                    index: 0,
                                    child: ListDepartement(accessToken: widget.accessToken),accessToken: widget.accessToken,
                                  ),
                                ),
                              );
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

  Column backgroundContainer(BuildContext context) {
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
                child: Center(
                  child: Text(
                    'Adding',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
