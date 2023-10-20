import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';

import '../../models/user.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../forms/etudiantform.dart';
class ViewUser extends StatefulWidget {
  final String accessToken;
  final int id;
  ViewUser({Key? key, required this.accessToken, required this.id,
    // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {

  List<User> usersList = [User(0, '', '', '', '','','',0,'')];

  Future<List<User>> fetchUsers(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'user_data_by_id/'+id),headers: headers);
    var users = <User>[];
    for (var u in jsonDecode(response.body)) {
      users.add(User(u['id'], u['nom'], u['prenom'],u['email'],'', u['role'], u['photo'],0,''));
    }
    print(users);
    return users;
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(widget.id.toString()).then((users) {
      setState(() {
        this.usersList = users;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
        //  backgroundColor: Colors.white.withOpacity(.94),

        body:
        Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card

              CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Image.asset('images/users/${usersList[0].photo}',height: 150,width: 150,fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blueAccent, Colors.blueAccent],
                      // colors: [Colors.black54,Color.fromRGBO(0, 41, 102, 1)]
                    )
                ),
                child:
                SettingsGroup(
                  settingsGroupTitle: '',
                  items: [

                    SettingsItem(
                      onTap: () {},
                      // icons: Icons.near_me,
                      title:usersList[0].nom,
                    ),
                    SettingsItem(
                      onTap: () {},
                      // icons: CupertinoIcons.repeat,
                      title:usersList[0].prenom,
                    ),
                    SettingsItem(
                      onTap: () {},
                      // icons: CupertinoIcons.delete_solid,
                      title: usersList[0].email,
                      titleStyle: TextStyle(
                        // color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SettingsItem(
                      onTap: () {},
                      // icons: CupertinoIcons.repeat,
                      title:usersList[0].role,
                    ),

                  ],
                ),
              )
              )
            ],
          ),
        ),
      );

  }
}

