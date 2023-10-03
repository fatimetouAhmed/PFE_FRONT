import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/superviseur/GridViewWidgetDepartement.dart';
import 'package:pfe_front_flutter/screens/SurveillantSalleScreen.dart';
import 'package:pfe_front_flutter/screens/surveillant/home.dart';

import '../bar/masterpageadmin.dart';
import '../bar/masterpagesuperviseur.dart';
import '../bar/masterpagesurveillant.dart';
import '../components/page_title_bar.dart';
import '../components/upside.dart';
import '../constants.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';
import '../widgets/rounded_password_field.dart';
import 'admin/stats.dart';
import 'lists/notifications.dart';
import 'package:pfe_front_flutter/consturl.dart';

class LoginScreen extends StatelessWidget {
  final String accessToken;
  LoginScreen({Key? key, required this.accessToken}) : super(key: key);
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
                child: BarChartAPI(),accessToken: accessToken
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "images/login2.jpg",
                ),
                const PageTitleBar(title: ''),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'OpenSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Form(
                          child: Column(
                            children: [
                              RoundedInputField(
                                controller: emailController,
                                hintText: "Email",
                                icon: Icons.email,
                              ),
                              RoundedPasswordField(
                                controller: passwordController,
                              ),
                              // switchListTile(),
                              RoundedButton(
                                text: 'LOGIN',
                                press: () async {
                                  var email = emailController.text;
                                  var password = passwordController.text;

                                  try {
                                    var accessToken =
                                    await loginUser(email, password);
                                    await checkAccess(context, accessToken);
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
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Forgot password?',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget switchListTile() {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 40),
    child: SwitchListTile(
      dense: true,
      title: const Text(
        'Remember Me',
        style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
      ),
      value: true,
      activeColor: kPrimaryColor,
      onChanged: (val) {},
    ),
  );
}