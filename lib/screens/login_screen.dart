import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/screens/surveillant_screen.dart';
import 'package:pfe_front_flutter/screens/Admin_screen.dart';
import 'package:pfe_front_flutter/screens/Screen_superv.dart';
import '../bar/masterpageadmin.dart';
import '../bar/masterpagesuperviseur.dart';
import '../components/page_title_bar.dart';
import '../components/under_part.dart';
import '../components/upside.dart';
import '../constants.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';
import '../widgets/rounded_password_field.dart';
import 'lists/notifications.dart';

class LoginScreen extends StatelessWidget {
  final String accessToken;
  LoginScreen({Key? key, required this.accessToken}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accessTokenController = TextEditingController();

  Future<String> loginUser(String email, String password) async {
    var url = Uri.parse('http://127.0.0.1:8000/token');
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

  Future<void> checkAccess(BuildContext context, String accessToken) async {
    List<String> urlsToCheck = [
      'http://127.0.0.1:8000/surveillant',
      'http://127.0.0.1:8000/superv',
      'http://127.0.0.1:8000/admin',
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
        accessGranted = true;
        validUrl = url;
        break;
      }
    }

    if (accessGranted) {
      // Envoyer l'utilisateur vers un écran spécifique en fonction de la validUrl
      if (validUrl == 'http://127.0.0.1:8000/surveillant') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>CameraScreen(accessToken: accessToken),
          ),
        );
      } else if (validUrl == 'http://127.0.0.1:8000/superv') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPageSupeurviseur(child:Notifications(accessToken: accessToken),accessToken: accessToken),
          ),
        );
      } else if (validUrl == 'http://127.0.0.1:8000/admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterPage(
                child: ListDepartement(accessToken: accessToken),
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
