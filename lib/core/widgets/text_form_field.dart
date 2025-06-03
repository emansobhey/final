import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class MyTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isObecure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const MyTextFormField(
      {super.key,
      required this.hint,
      this.suffixIcon,
      required this.isObecure,
      this.controller,
      this.validator,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: MyFontStyle.font13RegularAcc.copyWith(color: MyColors.fontColor),
      obscureText: isObecure,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              MyFontStyle.font13RegularAcc.copyWith(color: MyColors.fontColor),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
