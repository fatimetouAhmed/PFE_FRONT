import 'dart:io';
import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
    });
  }

  Future<void> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.186.113:8000/api/predict'),
    );
    request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
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
          getImage().then((_) => uploadImage(File(_image!.path)));
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