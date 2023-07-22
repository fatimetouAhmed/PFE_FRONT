import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';

import '../../bar/masterpage.dart';
import '../../models/matiere.dart';


class AddMatiereForm extends StatefulWidget {
  final Matiere matiere;

  AddMatiereForm({Key? key, required this.matiere}) : super(key: key);

  @override
  _AddMatiereFormState createState() => _AddMatiereFormState();
}

Future save(matiere) async {
  if (matiere.id == 0) {
    await http.post(
      Uri.parse('http://127.0.0.1:8000/matieres/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'libelle': matiere.libelle,
        'nbre_heure': matiere.nbre_heure.toString(),
        'credit': matiere.credit.toString(),
      }),
    );
  }
  else {

    await http.put(
      Uri.parse('http://127.0.0.1:8000/matieres/' + matiere.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'libelle': matiere.libelle,
        'nbre_heure': matiere.nbre_heure.toString(),
        'credit': matiere.credit.toString(),
      }),
    );
  }
}

class _AddMatiereFormState extends State<AddMatiereForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController libelleController = new TextEditingController();
  TextEditingController nbre_heureController = new TextEditingController();
  TextEditingController creditController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(this.widget.matiere.libelle);
    setState(() {
      idController.text = this.widget.matiere.id.toString();
      libelleController.text = this.widget.matiere.libelle;
      nbre_heureController.text = this.widget.matiere.nbre_heure.toString();
      creditController.text = this.widget.matiere.credit.toString();
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
                    decoration: InputDecoration(hintText: 'Entrez libelle'),
                    controller: libelleController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Entrez nbre_heure'),
                    controller: nbre_heureController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Entrez credit'),
                    controller: creditController,
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("Submit"),
                    minWidth: double.infinity,
                    onPressed: () async {
                      await save(
                        Matiere(int.parse(idController.text), libelleController.text,int.parse(nbre_heureController.text),int.parse(creditController.text)),
                      );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            MasterPage(
                            child:
                            MatiereHome(),
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
