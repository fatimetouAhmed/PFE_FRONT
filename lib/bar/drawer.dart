import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre_etudiant.dart';
import '../screens/lists/listetudiermat.dart';
import '../screens/lists/listexamun.dart';
import '../screens/lists/listmatiere.dart';
import '../screens/lists/listdepartement.dart';
import '../screens/lists/listfiliere.dart';
import '../screens/lists/listsalle.dart';
import 'masterpageadmin.dart';

class NavBar extends StatelessWidget{
  const NavBar({super.key});
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text('George NcAllisier'),
              accountEmail: const Text('george@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('images/user.jpg'),),
            ),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              image: DecorationImage(image: AssetImage('images/img.jpg'),fit: BoxFit.cover)
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: ()=>print('Home'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users'),
            onTap: ()=>print('Users'),
          ),
          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text('Semestres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListSemestre(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Matieres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: MatiereHome(),
                    // HomeMatiere(
                    //   widgetName: ListMatiere(),
                    //   title: 'List',
                    //   index: 0,
                    // ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Salles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child:
                      ListSalle(),

                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2),
            title: Text('Etudiants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child:
                    ListSalle(),

                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.keyboard),
            title: Text('Filieres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListFiliere(
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.blind_outlined),
            title: Text('Departements'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListDepartement(),

                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text('Examuns'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListExamun(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text('EtidierMat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListEtudierMat(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.keyboard),
            title: Text('Semestre_Etudiant'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MasterPage(
                    child: ListSemestre_Etudiant(),
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: ()=>print('Logout'),
          ),
        ],
      ),
    );
  }
}