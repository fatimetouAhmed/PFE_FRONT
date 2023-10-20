import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/login/login_page.dart';
import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'package:pfe_front_flutter/consturl.dart';

class CameraScreen extends StatefulWidget {
  final String accessToken;

  const CameraScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nniController = TextEditingController();
  TextEditingController telController = TextEditingController();
  bool showForm = false;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print(_image);
      showForm = true; // Passer au formulaire après avoir pris la photo
    });
  }

  Future<void> uploadImage(
      File imageFile, String description, String nni, int tel) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'api/pv'),
    );
    request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    request.fields['description'] = description; // Description
    request.fields['nni'] = nni; // NNI (string)
    request.fields['tel'] = tel.toString(); // Numéro de téléphone (int)
    print("photo: ${imageFile.path}");

    var response = await request.send();
    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      showAlertDialog(context, 'Résultat de la prédiction', result);
      // Réinitialisez le formulaire et l'image après l'envoi réussi
      setState(() {
        showForm = false;
        _image = null;
        descriptionController.clear();
        nniController.clear();
        telController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveillant'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(accessToken: widget.accessToken),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: showForm
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextFormField(
              controller: nniController,
              decoration: InputDecoration(
                labelText: 'NNI',
              ),
            ),
            TextFormField(
              controller: telController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Appuyez sur ce bouton pour télécharger la photo et les informations
                uploadImage(File(_image!.path), descriptionController.text,
                    nniController.text, int.parse(telController.text));
              },
              child: Text('Enregistrer'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appuyez sur ce bouton pour annuler et revenir à la capture photo
                setState(() {
                  showForm = false;
                });
              },
              child: Text('Annuler'),
            ),
          ],
        )
            : _image == null
            ? Text(
          'Appuyez sur le bouton + pour ajouter une description et une photo',
          style: TextStyle(fontSize: 18.0),
        )
            : Image.file(File(_image!.path)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
}
