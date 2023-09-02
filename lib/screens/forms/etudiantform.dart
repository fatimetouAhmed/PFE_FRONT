import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
import 'package:quickalert/quickalert.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';
import '../../models/semestre.dart';
import '../lists/listetudiant.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // Import MediaType class

class EtudiantForm extends StatefulWidget {
  final int id;
  final String nom;
  final String prenom;
  final String photo;
  final String genre;
  final DateTime date_N;
  final String lieu_n;
  final String email;
  final int telephone;
  final String nationalite;
  final DateTime date_insecription;
  final String accessToken;


  EtudiantForm({Key? key, required this.id, required this.nom,required this.prenom,required this.photo,
    required this.genre,
    required this.date_N,
    required this.lieu_n,
    required this.email,
    required this.telephone,
    required this.nationalite,
    required this.date_insecription,
    required this.accessToken}) : super(key: key);

  @override
  _EtudiantFormState createState() => _EtudiantFormState();
}

class _EtudiantFormState extends State<EtudiantForm> {

  TextEditingController idController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();
  TextEditingController prenomController = new TextEditingController();
  TextEditingController photoController = new TextEditingController();
  TextEditingController genreController = new TextEditingController();
  TextEditingController date_NController = new TextEditingController();
  TextEditingController lieu_nController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController telephoneController = new TextEditingController();
  TextEditingController nationaliteController = new TextEditingController();
  TextEditingController date_insecriptionController = new TextEditingController();
  FocusNode nom = FocusNode();
  FocusNode prenom = FocusNode();
 // FocusNode photo = FocusNode();
  FocusNode genre = FocusNode();
  FocusNode date_N = FocusNode();
  FocusNode lieu_n = FocusNode();
  FocusNode email = FocusNode();
  FocusNode telephone = FocusNode();
  FocusNode nationalite = FocusNode();
  FocusNode date_insecription = FocusNode();

  List<String> etudiantList = [];
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      idController.text = this.widget.id.toString();
      nomController.text = this.widget.nom;
      prenomController.text = this.widget.prenom;
      photoController.text = this.widget.photo.toString();
      genreController.text = this.widget.genre;
      date_NController.text = this.widget.date_N.toString();
      lieu_nController.text = this.widget.lieu_n;
      emailController.text = this.widget.email;
      telephoneController.text = this.widget.telephone.toString();
      nationaliteController.text = this.widget.genre;
      date_insecriptionController.text = this.widget.date_insecription.toString();
    });

  }

  Future<List<Etudiant>> fetchEtudiants() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://192.168.225.113/etudiants/'),headers: headers);
    var etudiants = <Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var nom = u['nom'];
      var prenom = u['prenom'];
      var photo = u['photo'];
      var genre= u['genre'];
      var date_N = DateFormat('yyyy-MM-dd').parse(u['date_N']);
      var lieu_n = u['lieu_n'];
      var email = u['email'];
      var telephone = u['telephone'];
      var nationalite = u['nationalite'];
      var date_insecription = DateFormat('yyyy-MM-dd').parse(u['date_insecription']);
      if (id != null && nom != null &&  prenom != null && photo != null && genre != null && date_N != null) {
        etudiants.add(Etudiant(id, nom, prenom,photo,genre, date_N,lieu_n,email,telephone,nationalite,date_insecription));
      } else {
        print('Incomplete data for Etudiant object');
      }
    }

    return etudiants;
  }


  Future<void> save( int id, String nom,
      String prenom,
      String genre,
      DateTime date_N,
      String lieu_n,
      String email,
      int telephone,
      String nationalite,
      DateTime date_insecription,File imageFile) async {
    var request;
    if (id == 0) {
       request = http.MultipartRequest('POST', Uri.parse(baseUrl+'etudiants/'));
    } else {
      request = http.MultipartRequest('PUT', Uri.parse(baseUrl+'etudiants/'+id.toString()));
    }
    //print("Image path: ${imageFile.path}");
    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse(baseUrl+'api/pv'),
    // );
    request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
    request.fields['nom'] = nom;
    request.fields['prenom'] = prenom;
    request.fields['genre'] = genre;
    request.fields['date_N'] = date_N.toIso8601String();
    request.fields['lieu_n'] = lieu_n;
    request.fields['email'] = email;
    request.fields['telephone'] = telephone.toString();
    request.fields['nationalite'] = nationalite;
    request.fields['date_insecription'] = date_insecription.toIso8601String();
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    print("image path");
    print(imageFile.path);
    var response = await request.send();
    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
    }else {
      print('Error uploading image: ${response.statusCode}');
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
                height: 420,
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
                      SizedBox(height: 15),
                      Row( // Wrapping the first two Padding widgets in a Row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child:                       Padding(
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
                                      borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(width: 2, color: Colors.blue,)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust the spacing between the two fields
                          Expanded(
                            child:                       Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                focusNode: prenom,
                                controller: prenomController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'prenom',
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
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row( // Wrapping the first two Padding widgets in a Row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                focusNode: genre,
                                controller: genreController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'genre',
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
                          ),
                          SizedBox(width: 10), // Adjust the spacing between the two fields
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.datetime,
                                focusNode: date_N,
                                controller: date_NController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'date_N',
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
                                      date_NController.text = formattedDate; //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                      Row( // Wrapping the first two Padding widgets in a Row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                focusNode: lieu_n,
                                controller: lieu_nController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'lieu_n',
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
                          ),
                          SizedBox(width: 10), // Adjust the spacing between the two fields
                          Expanded(
                            child:                       Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                focusNode: email,
                                controller: emailController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'email',
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
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row( // Wrapping the first two Padding widgets in a Row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child:   Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                focusNode: nationalite,
                                controller: nationaliteController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'nationalite',
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
                          ),
                          SizedBox(width: 10), // Adjust the spacing between the two fields
                          Expanded(
                            child:                      Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                focusNode: telephone,
                                controller: telephoneController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'telephone',
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
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row( // Wrapping the first two Padding widgets in a Row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child:   Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  getImage().then((_) => photoController.text=_image!.path.toString());
                                  print(_image!.path) ;
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_a_photo), // Icône de la caméra
                                    // SizedBox(width: 8), // Espacement entre l'icône et le texte
                                    // Text('Prendre une photo'),
                                  ],
                                ),
                              ),
                            ),

                          ),
                          SizedBox(width: 10), // Adjust the spacing between the two fields
                          Expanded(
                            child:                      Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                keyboardType: TextInputType.datetime,
                                focusNode: date_insecription,
                                controller: date_insecriptionController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  labelText: 'date_insecription',
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
                                      date_insecriptionController.text = formattedDate; //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
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
                              int? idtel=int.tryParse(telephoneController.text);
                              if (id != null && idtel != null ) {
                                String imagePath = photoController.text; // Chemin du fichier image
                                File imageFile = File(imagePath);
                                print(_image!.name) ;
                                print(_image!) ;
                                print(photoController.text) ;
                                await save(

                                  id,
                                  nomController.text,
                                  prenomController.text,
                                  genreController.text,
                                  DateTime.parse(date_NController.text),
                                  lieu_nController.text,
                                  emailController.text,
                                  idtel,
                                  nationaliteController.text,
                                  DateTime.parse(date_insecriptionController.text),File(_image!.path),

                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,child:  EtudiantHome(  accessToken: widget.accessToken
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