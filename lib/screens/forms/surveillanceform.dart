import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/surveillance.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
class SurveillanceForm extends StatefulWidget {
  final Surveillance surveillance;
  final String accessToken;
  SurveillanceForm({Key? key, required this.surveillance,required this.accessToken}) : super(key: key);

  @override
  _SurveillanceFormState createState() => _SurveillanceFormState();
}

class _SurveillanceFormState extends State<SurveillanceForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController date_debController = new TextEditingController();
  TextEditingController date_finController =new TextEditingController();
  TextEditingController surveillant_idController = new TextEditingController();
  TextEditingController salle_idController = new TextEditingController();

  FocusNode date_deb = FocusNode();
  FocusNode date_fin = FocusNode();
  String? selectedOption1;
  String? selectedOption2;
  List<String> surveillantList = [];
  List<String> salleList = [];
int id=0;


  Future<void> fetchData() async {
    id=await fetchSuperviseurId(widget.accessToken) as int;
    print(id);
    fetchSurveillances(id).then((_) {
      setState(() {
        idController.text = this.widget.surveillance.id.toString();
        date_debController.text = this.widget.surveillance.date_debut.toString();
        date_finController.text = this.widget.surveillance.date_fin.toString();
        surveillant_idController.text = this.widget.surveillance.surveillant_id.toString();
        salle_idController.text = this.widget.surveillance.salle_id.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchNomSurveillances().then((_) {
      setState(() {
        idController.text = this.widget.surveillance.id.toString();
        date_debController.text = this.widget.surveillance.date_debut.toString();
        date_finController.text = this.widget.surveillance.date_fin.toString();
        surveillant_idController.text = this.widget.surveillance.surveillant_id.toString();
        salle_idController.text = this.widget.surveillance.salle_id.toString();
      });
    });
    fetchSalles().then((_) {
      setState(() {
        idController.text = this.widget.surveillance.id.toString();
        date_debController.text = this.widget.surveillance.date_debut.toString();
        date_finController.text = this.widget.surveillance.date_fin.toString();
        surveillant_idController.text = this.widget.surveillance.surveillant_id.toString();
        salle_idController.text = this.widget.surveillance.salle_id.toString();
      });
    });
  }
  Future<int?> fetchSuperviseurId(String token) async {
    var response = await http.get(
      Uri.parse(baseUrl+'current_user_id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }

  Future<List<Surveillance>> fetchSurveillances(int id) async {
    var response = await http.get(
      Uri.parse(baseUrl+'surveillances/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },
    );
    if (response.statusCode != 200) {
      // Handle the error when the API request is not successful (e.g., status code is not 200 OK).
      throw Exception('Failed to fetch surveillances.');
    }

    var jsonList = jsonDecode(response.body);

    if (jsonList is List) {
      var surveillances = <Surveillance>[];
      for (var u in jsonList) {
        print(u); // Affiche les données pour déboguer

        var DateDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_debut']);
        var DateFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['date_fin']);

        print(DateDeb);
        print(DateFin);

        surveillances.add(Surveillance(
            u['id'], DateDeb, DateFin, u['surveillant_id'], u['salle_id'], u['superviseur'], u['departement']
        ));
      }
      return surveillances;
    } else {
      // Handle the case when the JSON response is not a list.
      throw Exception('Invalid JSON format: Expected a list of surveillances.');
    }
  }

  Future<void> fetchNomSurveillances() async {
    var response = await http.get(
      Uri.parse(baseUrl+'surveillances/surveillances/nom/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var surveillance in data) {
        surveillantList.add(surveillance['prenom'] as String);
      }
    }
    print(surveillantList);
  }
  Future<void> fetchSalles() async {
    var response = await http.get(Uri.parse(baseUrl+'salles/nom/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        salleList.add(salle['nom'] as String);
      }
    }
    print(salleList);
  }
  Future<int?> fetchSurveillanceId(String nom) async {
    var response = await http.get(
      Uri.parse(baseUrl+'surveillances/surveillances/$nom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchSallesId(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'examuns/salle/$nom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(Surveillance surveillance) async {
    if (surveillance.id == 0) {

      await http.post(
        Uri.parse(baseUrl+'surveillances/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer ${widget.accessToken}',
        },

        body: jsonEncode(<String, dynamic>{
          'date_debut': surveillance.date_debut.toIso8601String(),
          'date_fin': surveillance.date_fin.toIso8601String(),
          'surveillant_id': surveillance.surveillant_id,
          'salle_id': surveillance.salle_id,
        }),
      );
    } else {
      await http.put(
        Uri.parse(baseUrl+'surveillances/' + surveillance.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'date_debut': surveillance.date_debut.toIso8601String(),
          'date_fin': surveillance.date_fin.toIso8601String(),
          'surveillant_id': surveillance.surveillant_id,
          'salle_id': surveillance.salle_id,
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
                height: 400,
                width: 370,
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
                                int? id = await fetchSurveillanceId(selectedOption1!);
                                print(id);
                                surveillant_idController.text = id.toString();
                              }
                            },
                            items: surveillantList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => surveillantList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Surveillance',
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
                                int? id = await fetchSallesId(selectedOption2!);
                                print(id);
                                salle_idController.text = id.toString();
                              }
                            },
                            items: salleList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => salleList.map((e) => Text(e)).toList(),
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
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: date_deb,
                          controller: date_debController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'Date_deb',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blue,)),
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                date_debController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: date_fin,
                          controller: date_finController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'date_fin',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blue,)),
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                date_finController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
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
                              int? idDep = int.tryParse(surveillant_idController.text);
                              int? idSup = int.tryParse(salle_idController.text);
                              if (id != null  && idDep != null&& idSup != null) {
                                await save(
                                  Surveillance(
                                    id,   DateTime.parse(date_debController.text),
                                    DateTime.parse(date_finController.text),
                                    idSup,
                                    idDep,
                                    '',
                                    '',

                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  ListSurveillance(  accessToken: widget.accessToken
                                        ),)
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
      Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Form(
                  child: Column(
                    children: [
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: idController,
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: DropdownButtonFormField<String>(
                          // print(selectedOption),
                          value: selectedOption1,
                          items: surveillantList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption1 = newValue;
                            //  print(selectedOption1);
                            if (selectedOption1 != null) {
                              int? id = await fetchSurveillanceId(selectedOption1!);
                              print('hhh');
                              surveillant_idController.text = id.toString();
                              print(surveillant_idController.text);
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Surveillaces',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: DropdownButtonFormField<String>(
                          // print(selectedOption),
                          value: selectedOption2,
                          items: salleList.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            selectedOption2 = newValue;
                            // print(selectedOption2);
                            if (selectedOption2 != null) {
                              int? id = await fetchSallesId(selectedOption2!);
                              salle_idController.text = id.toString();
                              print(salle_idController.text);
                              print("Salle");
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Salles',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: surveillant_idController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          controller: salle_idController,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          controller: date_finController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date fn" //label text of field
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                date_debController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                        ),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'Enter Description'),
                        //   controller: heure_debController,
                        // ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextField(
                          controller: date_finController, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Date fin" //label text of field
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                date_finController.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text("Submit"),
                        onPressed: ()  async {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Operation Completed Successfully!',
                            confirmBtnColor: Colors.blue,
                          ).then((value) async {
                            if (value == null) {
                              int? id = int.tryParse(idController.text);
                              int? idSur = int.tryParse(surveillant_idController.text);
                              int? idSal = int.tryParse(salle_idController.text);

                              if (id != null && idSur != null && idSal != null) {
                                await save(
                                  Surveillance(
                                    id,
                                    DateTime.parse(date_debController.text),
                                    DateTime.parse(date_finController.text),
                                    idSur,
                                    idSal,
                                    '',
                                    ''
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPageSupeurviseur(child:
                                      ListSurveillance(accessToken: widget.accessToken,),accessToken: widget.accessToken, index: 1,)
                                  ),
                                );

                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Invalid ID or Surveillance ID or Salle ID"),
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

                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
