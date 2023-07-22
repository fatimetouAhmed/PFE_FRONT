import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpage.dart';
import '../../models/salle.dart';
import '../lists/listsalle.dart';

class SalleForm extends StatefulWidget {
  final Salle salle;

  SalleForm({Key? key, required this.salle}) : super(key: key);

  @override
  _SalleFormState createState() => _SalleFormState();
}
int i=0;
Future save(salle) async {
  if (salle.id == 0) {
    i=0;
    await http.post(
      Uri.parse('http://127.0.0.1:8000/salles/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': salle.nom,
      }),
    );
  } else {
    i=1;
    await http.put(
      Uri.parse('http://127.0.0.1:8000/salles/' + salle.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': salle.nom,
      }),
    );
  }
}

class _SalleFormState extends State<SalleForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(this.widget.salle.nom);
    setState(() {
      idController.text = this.widget.salle.id.toString();
      nomController.text = this.widget.salle.nom;
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
                        Salle(int.parse(idController.text), nomController.text),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MasterPage(
                                child:
                                ListSalle(),
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
