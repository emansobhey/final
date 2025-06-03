import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class SocilaMediaSign extends StatelessWidget {
  const SocilaMediaSign({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.email,
          color: MyColors.txt1Color,
          size: 35,
        ),
        horizontalSpace(10),
        const Icon(
          Icons.facebook_outlined,
          color: MyColors.txt1Color,
          size: 35,
        )
      ],
    );
  }
}
