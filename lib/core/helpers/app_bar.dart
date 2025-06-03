import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class AppBarOfSpokify extends StatelessWidget {
  const AppBarOfSpokify({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
  });
  final String? text;
  final void Function()? onPressed;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.backgroundColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Image.asset(
          "assets/images/arrow.png",
          width: 35,
          height: 35,
        ),
      ),
      actions: [
        IconButton(
          icon: icon ?? SizedBox(),
          onPressed: onPressed,
        ),
      ],
      title: Text(
        text ?? "",
        style: MyFontStyle.font20.copyWith(color: MyColors.whiteColor),
      ),
      centerTitle: true,
    );
  }
}
