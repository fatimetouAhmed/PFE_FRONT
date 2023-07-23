// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';
// import 'package:file_picker/file_picker.dart';
// import '../../bar/masterpageadmin.dart';
// import '../../models/etudiant.dart';
// import '../../models/matiere.dart';
//
//
// class EtudiantForm extends StatefulWidget {
//   final Etudiant etudiant;
//
//   EtudiantForm({Key? key, required this.etudiant}) : super(key: key);
//
//   @override
//   _EtudiantFormState createState() => _EtudiantFormState();
// }
//
// Future save(etudiant) async {
//   if (etudiant.id == 0) {
//     await http.post(
//       Uri.parse('http://127.0.0.1:8000/etudiants/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json;charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'nom': etudiant.nom,
//         'prenom': etudiant.prenom,
//         'photo': etudiant.photo,
//         'genre': etudiant.genre,
//         'date_N': etudiant.date_N,
//         'lieu_n': etudiant.lieu_n,
//         'email': etudiant.email,
//         'telephone': etudiant.telephone.toString(),
//         'nationalité':etudiant.nationalite,
//         'date_insecription': etudiant.date_insecription,
//       }),
//     );
//   }
//   else {
//
//     await http.put(
//       Uri.parse('http://127.0.0.1:8000/matieres/' + etudiant.id.toString()),
//       headers: <String, String>{
//         'Content-Type': 'application/json;charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'nom': etudiant.nom,
//         'prenom': etudiant.prenom,
//         'photo': etudiant.photo,
//         'genre': etudiant.genre,
//         'date_N': etudiant.date_N,
//         'lieu_n': etudiant.lieu_n,
//         'email': etudiant.email,
//         'telephone': etudiant.telephone.toString(),
//         'nationalité':etudiant.nationalite,
//         'date_insecription': etudiant.date_insecription,
//       }),
//     );
//   }
// }
//
// class _EtudiantFormState extends State<EtudiantForm> {
//   TextEditingController idController = new TextEditingController();
//   TextEditingController nomController = new TextEditingController();
//   TextEditingController prenomController = new TextEditingController();
//   FileEditingController photoController = FileEditingController();
//   TextEditingController nbre_heureController = new TextEditingController();
//   TextEditingController creditController = new TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       idController.text = this.widget.matiere.id.toString();
//       libelleController.text = this.widget.matiere.libelle;
//       nbre_heureController.text = this.widget.matiere.nbre_heure.toString();
//       creditController.text = this.widget.matiere.credit.toString();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             child: Form(
//               child: Column(
//                 children: [
//                   Visibility(
//                     visible: false,
//                     child: TextFormField(
//                       decoration: InputDecoration(hintText: 'Entrez id'),
//                       controller: idController,
//                     ),
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(hintText: 'Entrez libelle'),
//                     controller: libelleController,
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(hintText: 'Entrez nbre_heure'),
//                     controller: nbre_heureController,
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(hintText: 'Entrez credit'),
//                     controller: creditController,
//                   ),
//                   SizedBox(height: 20),
//                   MaterialButton(
//                     color: Colors.blue,
//                     textColor: Colors.white,
//                     child: Text("Submit"),
//                     minWidth: double.infinity,
//                     onPressed: () async {
//                       await save(
//                         Matiere(int.parse(idController.text), libelleController.text,int.parse(nbre_heureController.text),int.parse(creditController.text)),
//                       );
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               MasterPage(
//                                 child:
//                                 MatiereHome(),
//                               ),
//                         ),
//                       );
//
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
