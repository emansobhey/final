import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

import '../../../../core/routing/routes.dart';

class DonotHaveAnAccountRow extends StatelessWidget {
  const DonotHaveAnAccountRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?   ",
          style: MyFontStyle.font13RegularAcc.copyWith(
            color: MyColors.fontColor,
          ),
        ),
        TextButton(
          onPressed: () { Navigator.pushNamed(context, Routes.singUp);},
          child: Text(
            'Sign up',
            style: MyFontStyle.font13BoldUnderline.copyWith(
                color: MyColors.txt2Color,
                decoration: TextDecoration.underline,
                decorationColor: MyColors.txt2Color),
          ),
        ),
      ],
    );
  }
}
