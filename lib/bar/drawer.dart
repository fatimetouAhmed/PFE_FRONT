// import 'package:flutter/material.dart';
// import 'package:pfe_front_flutter/screens/lists/listetudiant.dart';
// import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';
// import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
// import 'package:pfe_front_flutter/screens/lists/listsemestre_etudiant.dart';
// import '../screens/lists/listedepartementsuperviseur.dart';
// import '../screens/lists/listesemestre_matiere.dart';
// import '../screens/lists/listetudiermat.dart';
// import '../screens/lists/listexamun.dart';
// import '../screens/lists/listmatiere.dart';
// import '../screens/lists/listdepartement.dart';
// import '../screens/lists/listfiliere.dart';
// import '../screens/lists/listsalle.dart';
// import '../screens/lists/listsurveillant.dart';
// import '../screens/lists/listuser.dart';
// import '../screens/login_screen.dart';
// import 'masterpageadmin.dart';
//
// class NavBar extends StatelessWidget{
//   final String accessToken;
//   const NavBar({required this.accessToken, Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context){
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//               accountName: const Text('George NcAllisier'),
//               accountEmail: const Text('george@gmail.com'),
//             currentAccountPicture: CircleAvatar(
//               child: ClipOval(child: Image.asset('images/user.jpg'),),
//             ),
//             decoration: BoxDecoration(
//               color: Colors.pinkAccent,
//               image: DecorationImage(image: AssetImage('images/img.jpg'),fit: BoxFit.cover)
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Users'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,accessToken: accessToken,
//                     child: ListUser(  accessToken: accessToken
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.playlist_add),
//             title: Text('Semestres'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,accessToken: accessToken,
//                     child: ListSemestre(  accessToken: accessToken
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.receipt),
//             title: Text('Matieres'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: MatiereHome(  accessToken: accessToken
//                     ),accessToken: accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.receipt),
//             title: Text('Salles'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child:
//                       ListSalle(  accessToken:accessToken
//                       ),accessToken: accessToken,
//
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.person_2),
//             title: Text('Etudiants'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: EtudiantHome(  accessToken: accessToken
//                     ),accessToken: accessToken
//
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.keyboard),
//             title: Text('Filieres'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,accessToken: accessToken,
//                     child: ListFiliere(  accessToken: accessToken
//
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.playlist_add),
//             title: Text('Surveillance'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,accessToken: accessToken,
//                     child: ListSurveillance(  accessToken: accessToken
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.blind_outlined),
//             title: Text('Departements'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListDepartement(accessToken: accessToken),accessToken: accessToken
//
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.keyboard),
//             title: Text('Semestre Matiere'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListSemestre_Matiere(  accessToken:accessToken
//                     ),accessToken: accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.receipt),
//             title: Text('Departement Superviseur'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListDepartementSuperviseur(  accessToken: accessToken
//                     ),accessToken: accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.playlist_add),
//             title: Text('Examuns'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListExamun(  accessToken: accessToken
//                     ),accessToken: accessToken
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.playlist_add),
//             title: Text('Etidier Matiere'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListEtudierMat(  accessToken: accessToken
//                     ),accessToken: accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.keyboard),
//             title: Text('Semestre Etudiant'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MasterPage(
//                     index: 0,
//                     child: ListSemestre_Etudiant(  accessToken:accessToken
//                     ),accessToken: accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LoginScreen(accessToken: accessToken),
//                 ),
//               );
//             }
//           ),
//         ],
//       ),
//     );
//   }
// }