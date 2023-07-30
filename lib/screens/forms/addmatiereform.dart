import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';
import 'package:quickalert/quickalert.dart';
import '../../bar/masterpageadmin.dart';
import '../../models/matiere.dart';


class AddMatiereForm extends StatefulWidget {
  final Matiere matiere;
  final String accessToken;



  AddMatiereForm({Key? key, required this.matiere, required this.accessToken}) : super(key: key);

  @override
  _AddMatiereFormState createState() => _AddMatiereFormState();
}
Future save(String accessToken, Matiere matiere) async {
  final headers = <String, String>{
    'Content-Type': 'application/json;charset=UTF-8',
    'Authorization': 'Bearer $accessToken'
  };
  if (matiere.id == 0) {

    await http.post(
      Uri.parse('http://127.0.0.1:8000/matieres/'),
      headers: headers,

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
      headers: headers,

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
  FocusNode libelle = FocusNode();
  FocusNode nbre_heure = FocusNode();
  FocusNode credit = FocusNode();
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(height: 25),
            background_container(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 350,
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
                          focusNode: libelle,
                          controller: libelleController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'libelle',
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
                          focusNode: nbre_heure,
                          controller: nbre_heureController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'nbre_heure',
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
                          focusNode: credit,
                          controller: creditController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'credit',
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
                              await save(widget.accessToken,
                                Matiere(int.parse(idController.text), libelleController.text,int.parse(nbre_heureController.text),int.parse(creditController.text)),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MasterPage(
                                        index: 0,  accessToken: widget.accessToken,

                                          child:
                                        MatiereHome( accessToken: widget.accessToken
                                        ),
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
