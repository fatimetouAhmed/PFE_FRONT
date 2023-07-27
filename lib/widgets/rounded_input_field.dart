import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/widgets/text_field_container.dart';

import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    required this.controller,
  }) : super(key: key);

  final String? hintText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: 'OpenSans'),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
