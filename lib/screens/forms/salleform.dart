import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import '../../models/salle.dart';
import '../lists/listsalle.dart';
import 'package:quickalert/quickalert.dart';
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
  FocusNode nom = FocusNode();
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
    return
      Scaffold(
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
                                  Salle(int.parse(idController.text), nomController.text),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MasterPage( index: 0,
                                          child:
                                          ListSalle(),
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
