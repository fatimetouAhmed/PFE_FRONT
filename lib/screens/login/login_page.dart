import 'package:pfe_front_flutter/screens/superviseur/GridViewWidgetDepartement.dart';
import 'package:pfe_front_flutter/screens/SurveillantSalleScreen.dart';
import 'package:pfe_front_flutter/screens/surveillant/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pfe_front_flutter/screens/superviseur/GridViewWidgetDepartement.dart';
import 'package:pfe_front_flutter/screens/SurveillantSalleScreen.dart';
import 'package:pfe_front_flutter/screens/surveillant/home.dart';
//import '../bar/masterpageadmin.dart';
//import '../bar/masterpagesuperviseur.dart';
//import '../bar/masterpagesurveillant.dart';

//import 'admin/dashbordAnne.dart';
//import 'admin/dashord.dart';
//import 'admin/stats.dart';
//import 'lists/notifications.dart';
import 'package:pfe_front_flutter/consturl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../bar/masterpageadmin.dart';
import '../../bar/masterpagesuperviseur.dart';
import '../../bar/masterpagesurveillant.dart';
import '../admin/dashbordAnne.dart';
import 'common/theme_helper.dart';
import 'widgets/header_widget.dart';

class LoginPage extends StatefulWidget{
  final String accessToken;
  LoginPage({Key? key, required this.accessToken}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accessTokenController = TextEditingController();
  int id_user=0;
  Future<int> fetchUserId(String accessToken1) async {
    var headers = {
      "Authorization": "Bearer $accessToken1",
    };
    var url = Uri.parse(baseUrl+'current_user_id');

    try {
      var response = await http.get(url, headers: headers);

      print('FetchUserId URL: $url');
      print('FetchUserId Headers: $headers');
      print('FetchUserId Response Code: ${response.statusCode}');
      print('FetchUserId Response Body: ${response.body}');

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        print('FetchUserId JSON Data: $jsonData');
        return jsonData as int; // Make sure the JSON data is an integer
      } else {
        print('FetchUserId Request Failed');
        return 0;
      }
    } catch (e) {
      print('FetchUserId Exception: $e');
      return 0;
    }
  }

  Future<String> loginUser(String email, String password) async {
    var url = Uri.parse(baseUrl+'token');
    var response = await http.post(
      url,
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var accessToken = responseBody['access_token'];
      accessTokenController.text = accessToken;
      return accessToken;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> fetchSurveillantInfo(String accessToken) async {
    var headers = {
      "Authorization": "Bearer $accessToken",
    };
    var url = Uri.parse(baseUrl+'get_surveillant_info/');

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        return jsonData; // Retourne les informations du surveillant sous forme de Map
      } else {
        throw Exception('Échec de la récupération des informations du surveillant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des informations du surveillant : $e');
    }
  }

  Future<void> checkAccess(BuildContext context, String accessToken) async {
    List<String> urlsToCheck = [
      baseUrl+'surveillant',
      baseUrl+'superv',
      baseUrl+'admin',

    ];

    bool accessGranted = false;
    String validUrl = '';

    for (String url in urlsToCheck) {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        id_user=await fetchUserId(accessToken);
        accessGranted = true;
        validUrl = url;
        break;
      }
    }
    // id_user=await http.get();
    if (accessGranted) {

      // Envoyer l'utilisateur vers un écran spécifique en fonction de la validUrl

      if (validUrl == baseUrl+'surveillant') {
        var surveillantInfo = await fetchSurveillantInfo(accessToken);
        if (surveillantInfo['typecompte'] == 'principale') {
          // Redirigez vers l'écran de la caméra
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MasterPageSurveillant(accessToken: accessToken,
                index:0,
                child: CameraScreen(accessToken: accessToken),)
              ,
            ),
          );} else if (surveillantInfo['typecompte'] == 'salle') {
          print(accessToken);
          // Redirigez vers l'écran du surveillant de salle
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveillantSalleScreen(
                accessToken: accessToken,
              ),
            ),
          );
        }

      } else if (validUrl == baseUrl+'superv') {
        print(id_user);
        id_user=await fetchUserId(accessToken);
        print(id_user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>MasterPageSupeurviseur(child:GridViewWidget(id: id_user,accessToken: accessToken,),accessToken: accessToken, index: 0,),
            //HomeSceen(id: id_user,),
          ),
        );

      } else if (validUrl == baseUrl+'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
                index: 0,
                child: DashBoardAnnee(),accessToken: accessToken
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Your access is denied.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              child: TextField(
                                controller:widget.emailController,
                                decoration: ThemeHelper().textInputDecoration('email', 'Entrez votre email'),
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              child: TextField(
                                  controller: widget.passwordController,
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration('Password', 'Entez votre password'),
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 30.0),

                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),
                                onPressed: ()async {
                                  var email = widget.emailController.text;
                                  var password = widget.passwordController.text;

                                  try {
                                    var accessToken = await widget.loginUser(email, password);
                                    await widget.checkAccess(context, accessToken);
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text('Failed to login.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),

                          ],
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );

  }
}