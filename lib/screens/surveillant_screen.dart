import 'dart:io';
import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../consturl.dart';

class CameraScreen extends StatefulWidget {
  final String accessToken;

  const CameraScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print(_image);
    });
  }

  Future<void> uploadImage(int id,String nom,
      String prenom,
      String genre,
      DateTime date_N,
      String lieu_n,
      String email,
      int telephone,
      String nationalite,
      DateTime date_insecription,File imageFile) async {
    //print("Image path: ${imageFile.path}");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl+'api/pv'),
    );
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
      showAlertDialog(context, 'Prediction result', result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveillant'),
        backgroundColor: Colors.blue, // Couleur bleue pour l'app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Vous pouvez mettre ici le code pour déconnecter l'utilisateur et aller à la page de connexion
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(accessToken: widget.accessToken),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _image == null
            ? Text(
          'Prendre une photo',
          style: TextStyle(fontSize: 18.0),
        )
            : Image.file(File(_image!.path)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage().then((_) => uploadImage(3,'sidi','ahmed','m',DateTime.parse('2023-09-14 00:00:00.000'),'mmm','kklk',090990,'nmnmnm',DateTime.parse('2023-09-14 00:00:00.000'),File(_image!.path)));
        },
        child: Icon(Icons.add_a_photo), // Icône de la caméra
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Bouton de la caméra en bas à droite
    );
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
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