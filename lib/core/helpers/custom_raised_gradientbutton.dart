import 'package:flutter/material.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/button.dart';

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
    return RaisedGradientButton(
      width: width ?? double.infinity / 1.5,
      height: 70,
      gradient: const LinearGradient(
        colors: <Color>[
          MyColors.button1Color,
          MyColors.button2Color,
        ],
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style:
            MyFontStyle.font12RegularBtn.copyWith(color: MyColors.whiteColor),
      ),
    );
  }
}
