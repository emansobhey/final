import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class AppBarHome extends StatelessWidget {
  const AppBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.userProfile);
          },
          icon: const Icon(
            Icons.person_outlined,
            color: MyColors.button1Color,
            size: 35,
          ),
        ),
        horizontalSpace(60),
        Text(
          "Spokify",
          style: MyFontStyle.font28Regular.copyWith(color: MyColors.whiteColor),
        ),
        horizontalSpace(80),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search_outlined,
            color: MyColors.button1Color,
            size: 35,
          ),
        ),
      ],
    );
  }
}
