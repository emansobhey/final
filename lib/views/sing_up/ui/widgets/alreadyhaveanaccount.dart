import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?   ",
          style: MyFontStyle.font13RegularAcc.copyWith(
            color: MyColors.fontColor,
          ),
        ),
        Text(
          "Sign in",
          style: MyFontStyle.font13BoldUnderline.copyWith(
              color: MyColors.txt2Color,
              decoration: TextDecoration.underline,
              decorationColor: MyColors.txt2Color),
        ),
      ],
    );
  }
}
