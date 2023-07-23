import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/models/departement.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';

import '../../bar/masterpageadmin.dart';


class DepartementForm extends StatefulWidget {
  final Departement departement;

  DepartementForm({Key? key, required this.departement}) : super(key: key);

  @override
  _DepartementFormState createState() => _DepartementFormState();
}
int i=0;
Future save(departement) async {
  if (departement.id == 0) {
    i=0;
    await http.post(
      Uri.parse('http://127.0.0.1:8000/departements/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': departement.nom,
      }),
    );
  } else {
    i=1;
    await http.put(
      Uri.parse('http://127.0.0.1:8000/departements/' + departement.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': departement.nom,
      }),
    );
  }
}

class _DepartementFormState extends State<DepartementForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(this.widget.departement.nom);
    setState(() {
      idController.text = this.widget.departement.id.toString();
      nomController.text = this.widget.departement.nom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
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
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Entrez nom'),
                    controller: nomController,
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("Submit"),
                    minWidth: double.infinity,
                    onPressed: () async {
                      await save(
                        Departement(int.parse(idController.text), nomController.text),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MasterPage(
                                child:
                                ListDepartement(),
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
