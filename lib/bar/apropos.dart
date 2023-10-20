// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
//
// class Apropos extends StatelessWidget {
//   const Apropos({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white.withOpacity(.94),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: ListView(
//             children: [
//               // user card
//               Container(
//                 height: 150,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: AssetImage("images/logo.jpg"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20,),
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {},
//                     icons: CupertinoIcons.pencil_outline,
//                     iconStyle: IconStyle(),
//                     title:
//                     'Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance',
//                     subtitle:
//                     "Make Ziar'App yours Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance Appearance",
//                     titleMaxLine: 1,
//                     subtitleMaxLine: 1,
//                   ),
//                   SettingsItem(
//                     onTap: () {},
//                     icons: Icons.fingerprint,
//                     iconStyle: IconStyle(
//                       iconsColor: Colors.white,
//                       withBackground: true,
//                       backgroundColor: Colors.red,
//                     ),
//                     title: 'Privacy',
//                     subtitle: "Lock Ziar'App to improve your privacy",
//                   ),
//                   SettingsItem(
//                     onTap: () {},
//                     icons: Icons.contacts,
//                     iconStyle: IconStyle(
//                       iconsColor: Colors.white,
//                       withBackground: true,
//                       backgroundColor: Colors.red,
//                     ),
//                     title: 'Email',
//                     subtitle: "fatimetouahmed@gmail.com",
//                     // trailing: Switch.adaptive(
//                     //   value: false,
//                     //   onChanged: (value) {},
//                     // ),
//                   ),
//                 ],
//               ),
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {},
//                     icons: Icons.info_rounded,
//                     iconStyle: IconStyle(
//                       backgroundColor: Colors.purple,
//                     ),
//                     title: 'About',
//                     subtitle: "Learn more about Ziar'App",
//                   ),
//                 ],
//               ),
//               // You can add a settings title
//
//             ],
//           ),
//         ),
//       );
//
//   }
// }
