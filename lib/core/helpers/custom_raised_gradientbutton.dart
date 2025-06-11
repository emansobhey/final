import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import '../theming/my_colors.dart';
import '../theming/my_fonts.dart';
class CustomRaisedGradientButton extends StatelessWidget {
  const CustomRaisedGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
  });

  final void Function() onPressed;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: MyColors.backgroundColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: MyFontStyle.font12RegularBtn.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
