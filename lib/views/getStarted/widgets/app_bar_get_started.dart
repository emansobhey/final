import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class GetStartedAppBar extends StatelessWidget {
  const GetStartedAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 45,
          height: 45,
        ),
        horizontalSpace(14),
        Text(
          "Spokify",
          style:
              MyFontStyle.font13RegularAcc.copyWith(color: MyColors.whiteColor),
        ),
      ],
    );
  }
}
