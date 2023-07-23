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
      Uri.parse('http://192.168.8.102:8000/api/predict'),
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
        actions: [
          IconButton(

            icon: Icon(Icons.logout),
            onPressed: () {
              // Vous pouvez mettre ici le code pour déconnecter l'utilisateur et aller à la page de connexion
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? ElevatedButton(
              onPressed: () {
                getImage().then((_) => uploadImage(File(_image!.path)));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Couleur bleue
                onPrimary: Colors.white, // Texte en blanc
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bord arrondi
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Prendre une photo',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
                : Image.file(File(_image!.path)),
          ],
        ),
      ),
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
